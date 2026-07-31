import 'package:flutter/material.dart';
import 'package:zetra/app/themes/app_colors.dart';

class LiveActivityWidget extends StatelessWidget {

  final double soc; // 0.0 to 1.0
  final int timeRemainingMins;
  final double speedKw;
  final double costRm;
  final bool isDarkMode;
  final VoidCallback? onStopTap;

  const LiveActivityWidget({super.key, required this.soc, required this.timeRemainingMins, required this.speedKw, required this.costRm, required this.isDarkMode, this.onStopTap});

  @override
  Widget build(BuildContext context) {

    // Theme configurations based on mockup
    final Color cardBgColor = isDarkMode ? const Color(0xFF0C1017) : const Color(0xFFF1F3F5);
    final Color borderColor = isDarkMode ? const Color(0xFF1E2633) : const Color(0xFFE2E8F0);
    final Color textPrimary = isDarkMode ? Colors.white : const Color(0xFF1A202C);
    final Color textSecondary = isDarkMode ? const Color(0xFF8B949E) : const Color(0xFF718096);
    final Color zetraBadgeBg = isDarkMode ? const Color(0xFF132A26) : const Color(0xFFD1F5EA);
    final Color zetraBadgeText = isDarkMode ? const Color(0xFF00FFC2) : const Color(0xFF0E7055);
    // Stop Button Theme
    final Color stopBtnBg = isDarkMode ? const Color(0xFF2E1619) : const Color(0xFFFFECEF);
    final Color stopBtnText = isDarkMode ? const Color(0xFFEF4444) : const Color(0xFFDC2626);
    // Grid Box Theme
    final Color boxBg = isDarkMode ? const Color(0xFF161B22) : const Color(0xFFE2E8F0);
    final Color boxBorder = isDarkMode ? const Color(0xFF21262D) : const Color(0xFFCBD5E0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: borderColor,
            width: 1.5
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: isDarkMode ? 0.3 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8)
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4
                    ),
                    decoration: BoxDecoration(
                      color: zetraBadgeBg,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text(
                      'ZETRA',
                      style: TextStyle(
                        color: zetraBadgeText,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5
                      )
                    )
                  ),
                  const SizedBox(
                      width: 8
                  ),
                  Text(
                    'ACTIVE CHARGING',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1
                    )
                  )
                ]
              ),
              GestureDetector(
                onTap: onStopTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6
                  ),
                  decoration: BoxDecoration(
                    color: stopBtnBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: stopBtnText.withValues(alpha: 0.3)
                    )
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.stop_circle_rounded,
                        color: stopBtnText,
                        size: 14
                      ),
                      const SizedBox(
                          width: 4
                      ),
                      Text(
                        'Stop',
                        style: TextStyle(
                          color: stopBtnText,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ]
                  )
                )
              )
            ]
          ),
          const SizedBox(
              height: 16
          ),
          Row(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      value: soc,
                      strokeWidth: 4.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDarkMode ? const Color(0xFF00FFC2) : const Color(0xFF0E7055)
                      ),
                      backgroundColor: isDarkMode ? const Color(0xFF1F2937) : const Color(0xFFCBD5E0)
                    )
                  ),
                  Icon(
                    Icons.bolt,
                    color: isDarkMode ? const Color(0xFF00FFC2) : const Color(0xFF0E7055),
                    size: 24
                  )
                ]
              ),
              const SizedBox(
                  width: 16
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          '${(soc * 100).toInt()}',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        const SizedBox(
                            width: 2
                        ),
                        Text(
                          '%',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          )
                        )
                      ]
                    ),
                    const SizedBox(
                        height: 2
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          color: isDarkMode ? const Color(0xFF00FFC2) : const Color(0xFF0E7055),
                          size: 13
                        ),
                        const SizedBox(
                            width: 4
                        ),
                        Text(
                          '$timeRemainingMins mins left',
                          style: TextStyle(
                            color: isDarkMode ? const Color(0xFF00FFC2) : const Color(0xFF0E7055),
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ]
                    )
                  ]
                )
              ),
              // Detail Grid: Rate & Cost
              Column(
                children: <Widget>[
                  // Rate Card
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8
                    ),
                    decoration: BoxDecoration(
                      color: boxBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: boxBorder
                      )
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'RATE',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5
                          )
                        ),
                        Text(
                          '${speedKw.toInt()} kW',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ]
                    )
                  ),
                  const SizedBox(
                      height: 6
                  ),
                  // Cost Card
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8
                    ),
                    decoration: BoxDecoration(
                      color: boxBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: boxBorder
                      )
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'COST',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5
                          )
                        ),
                        Text(
                          'RM ${costRm.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ]
                    )
                  )
                ]
              )
            ]
          ),
          const SizedBox(
              height: 16
          ),
          // ── Bottom Linear Progress Bar ──
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: soc,
              minHeight: 4,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDarkMode ? const Color(0xFF00FFC2) : const Color(0xFF0E7055)
              ),
              backgroundColor: isDarkMode ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)
            )
          )
        ]
      )
    );

  }

}