from rembg import remove
from PIL import Image
import numpy as np
from collections import deque
from scipy.ndimage import binary_dilation
import io

INPUT = r"assets\images\neon_green.png"
OUTPUT = r"assets\images\neon_green.png"

# --- Step 1: rembg AI mask (good subject edges) ---
with open(INPUT, "rb") as f:
    raw = f.read()

ai_result = Image.open(io.BytesIO(remove(raw))).convert("RGBA")
ai_arr = np.array(ai_result, dtype=np.uint8)

# --- Step 2: also load original for colour analysis ---
orig = np.array(Image.open(io.BytesIO(raw)).convert("RGBA"), dtype=np.uint8)
r = orig[:,:,0].astype(np.float32)
g = orig[:,:,1].astype(np.float32)
b = orig[:,:,2].astype(np.float32)

h, w = orig.shape[:2]
brightness  = (r + g + b) / 3.0
max_ch = np.maximum(np.maximum(r, g), b)
min_ch = np.minimum(np.minimum(r, g), b)
saturation  = np.where(max_ch > 0, (max_ch - min_ch) / max_ch, 0.0)

# --- Step 3: flood-fill the remaining light-grey shadow in AI result ---
# Work on the alpha channel from AI: near-transparent pixels in bright areas = shadow
ai_alpha = ai_arr[:,:,3].astype(np.float32)

# Shadow = AI made it semi-transparent AND original pixel is light + desaturated
shadow_mask = (ai_alpha < 200) & (brightness > 160) & (saturation < 0.20)

# Flood fill from edges of the AI-transparent zone
fully_transparent = ai_alpha < 10
visited = fully_transparent.copy()
q = deque()
for y in range(h):
    for x in [0, w-1]:
        if shadow_mask[y, x] and not visited[y, x]:
            visited[y, x] = True; q.append((y, x))
for x in range(w):
    for y in [0, h-1]:
        if shadow_mask[y, x] and not visited[y, x]:
            visited[y, x] = True; q.append((y, x))
# Also seed from pixels adjacent to already fully-transparent AI background
expanded_bg = binary_dilation(fully_transparent, iterations=6)
extra_seeds = np.array(list(zip(*np.where(expanded_bg & shadow_mask & ~visited))))
for pos in extra_seeds:
    visited[pos[0], pos[1]] = True
    q.append((pos[0], pos[1]))

while q:
    cy, cx = q.popleft()
    for dy, dx in [(-1,0),(1,0),(0,-1),(0,1)]:
        ny, nx = cy+dy, cx+dx
        if 0 <= ny < h and 0 <= nx < w and not visited[ny,nx] and shadow_mask[ny,nx]:
            visited[ny,nx] = True
            q.append((ny, nx))

# --- Step 4: compose final alpha ---
final = ai_arr.copy()
# Force visited shadow pixels fully transparent
final[visited, 3] = 0

# Smooth transition: pixels in edge zone between shadow and car body
edge_zone = binary_dilation(visited, iterations=5) & ~visited & (ai_alpha < 240)
if np.any(edge_zone):
    eb = brightness[edge_zone] / 255.0
    es = saturation[edge_zone]
    blend = np.clip(1.0 - eb * (1.0 - es * 0.4) * 0.85, 0.0, 1.0)
    final[:,:,3][edge_zone] = (final[:,:,3][edge_zone] * blend).astype(np.uint8)

out = Image.fromarray(final, 'RGBA')
out.save(OUTPUT, 'PNG')
print("Done. Saved to", OUTPUT)
