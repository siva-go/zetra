import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/core/l10n/app_localizations.dart';

import '../../../../app/themes/app_colors.dart';
import '../../../../app/themes/app_radius.dart';
import '../../../../app/themes/app_spacing.dart';
import '../../../../app/themes/app_typography.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

/// Invoice screen showing order ID, total paid, digital receipt link,
/// download button, session summary and billing breakdown — matching the
/// provided design mockup with neon / dark aesthetics.
class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            // Adaptive vertical gap – tighten on small screens
            final vgap = h < 700 ? AppSpacing.xs : AppSpacing.sm;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── App-bar ───────────────────────────────────────────────
                _AppBar(),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: vgap),

                        // ── Order-ID card ─────────────────────────────────
                        _OrderCard(),

                        SizedBox(height: vgap),

                        // ── Download Invoice button ───────────────────────
                        _DownloadButton(),

                        SizedBox(height: vgap),

                        // ── Session Summary label ─────────────────────────
                        Text(
                          AppLocalizations.of(context).sessionSummaryHeader,
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 10,
                            letterSpacing: 2,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: vgap),

                        // ── Hub info card ─────────────────────────────────
                        _HubCard(),

                        SizedBox(height: vgap),

                        // ── Energy / Duration row ─────────────────────────
                        _StatsRow(),

                        SizedBox(height: vgap),

                        // ── Billing breakdown card ────────────────────────
                        _BillingCard(),

                        SizedBox(height: vgap),

                        // ── Help card ─────────────────────────────────────
                        _HelpCard(),

                        SizedBox(height: vgap),
                      ],
                    ),
                  ),
                ),

                // ── Bottom nav ────────────────────────────────────────────
                const ZetraBottomNavBar(currentIndex: 3),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

/// Top app-bar with back arrow and title.
class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.canPop() ? context.pop() : context.go('/home'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.5), width: 1),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            AppLocalizations.of(context).invoice,
            style: AppTypography.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          // Share / export icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5), width: 1),
            ),
            child: const Icon(Icons.share_outlined,
                color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}

/// Card showing order ID, date and total amount paid.
class _OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color neonCyan = Color(0xFF00E5FF);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
            color: neonCyan.withValues(alpha: 0.55), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: neonCyan.withValues(alpha: 0.22),
            blurRadius: 24,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: neonCyan.withValues(alpha: 0.10),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ORDER ID row
          Row(
            children: [
              // Order-ID section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ORDER ID',
                      style: AppTypography.labelSmall.copyWith(
                          fontSize: 9,
                          letterSpacing: 1.5,
                          color: AppColors.textTertiary)),
                  const SizedBox(height: 2),
                  Text('#EVP-882910',
                      style: AppTypography.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 17)),
                ],
              ),
              const Spacer(),
              // Date badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs, vertical: 4),
                decoration: BoxDecoration(
                  color: neonCyan.withValues(alpha: 0.1),
                  borderRadius: AppRadius.smBorder,
                  border: Border.all(
                      color: neonCyan.withValues(alpha: 0.4), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 11, color: neonCyan),
                    const SizedBox(width: 4),
                    Text('24 Oct 2023',
                        style: AppTypography.labelSmall.copyWith(
                            color: neonCyan,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Divider
          Container(height: 1, color: AppColors.divider),

          const SizedBox(height: AppSpacing.sm),

          // Total amount
          Text(AppLocalizations.of(context).totalAmountPaid,
              style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹500.00',
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: neonCyan,
                  shadows: [
                    Shadow(
                      color: neonCyan.withValues(alpha: 0.75),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(AppLocalizations.of(context).inclTaxes,
                    style: AppTypography.labelSmall.copyWith(
                         color: neonCyan,
                         fontSize: 9,
                         fontWeight: FontWeight.w700,
                         letterSpacing: 1.2)),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // View Digital Receipt button
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: AppRadius.mdBorder,
                border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.4), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      color: neonCyan, size: 16),
                  const SizedBox(width: 6),
                  Text(AppLocalizations.of(context).viewDigitalReceipt,
                      style: AppTypography.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width cyan Download Invoice button.
class _DownloadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color neonCyan = Color(0xFF00E5FF);
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: neonCyan,
          borderRadius: AppRadius.lgBorder,
          boxShadow: [
            BoxShadow(
              color: neonCyan.withValues(alpha: 0.35),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.download_rounded,
                color: AppColors.scaffoldDark, size: 20),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context).downloadInvoice,
                style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.scaffoldDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

/// Hub name card with charging icon.
class _HubCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color neonGreen = Color(0xFF00FF66);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
            color: neonGreen.withValues(alpha: 0.45), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: neonGreen.withValues(alpha: 0.18),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: neonGreen.withValues(alpha: 0.1),
              borderRadius: AppRadius.smBorder,
              border: Border.all(
                  color: neonGreen.withValues(alpha: 0.4), width: 1),
            ),
            child: const Icon(Icons.ev_station_rounded,
                color: Color(0xFF00FF66), size: 22),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).chargingHub,
                  style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary, fontSize: 10)),
              const SizedBox(height: 2),
              Text('ZETRA GreenCharge Hub',
                  style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Two-column row with Energy Consumed and Duration stats.
class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color neonCyan = Color(0xFF00E5FF);
    const Color neonGreen = Color(0xFF00FF66);
    return Row(
      children: [
        _StatBox(
          label: AppLocalizations.of(context).energyConsumed,
          value: '24.7 kWh',
          icon: Icons.bolt_rounded,
          iconColor: neonGreen,
        ),
        const SizedBox(width: AppSpacing.sm),
        _StatBox(
          label: AppLocalizations.of(context).duration,
          value: '00:47:22',
          icon: Icons.timer_outlined,
          iconColor: neonCyan,
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: AppRadius.lgBorder,
          border: Border.all(
              color: iconColor.withValues(alpha: 0.40), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: 0.15),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary, fontSize: 10)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(icon, color: iconColor, size: 16),
                const SizedBox(width: 4),
                Text(value,
                    style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Billing breakdown card: unit price, base cost, GST, convenience fee,
/// credits applied, and a horizontal rule before the total.
class _BillingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color neonBlue = Color(0xFF00E5FF);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
            color: neonBlue.withValues(alpha: 0.50), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: neonBlue.withValues(alpha: 0.20),
            blurRadius: 22,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: neonBlue.withValues(alpha: 0.08),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unit price / base cost
          Row(
            children: [
              _BillingItem(
                  label: AppLocalizations.of(context).unitPrice, value: '₹18.20 / kWh'),
              const SizedBox(width: AppSpacing.sm),
              _BillingItem(
                  label: AppLocalizations.of(context).baseCost, value: '₹449.54'),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.sm),

          // GST, convenience fee, credits
          _LineItem(
              label: AppLocalizations.of(context).gst, value: '₹53.94'),
          const SizedBox(height: AppSpacing.xs),
          _LineItem(
              label: AppLocalizations.of(context).convenienceFee, value: '₹15.00'),
          const SizedBox(height: AppSpacing.xs),
          _LineItem(
            label: AppLocalizations.of(context).creditsApplied,
            value: '- ₹18.48',
            valueColor: neonBlue,
          ),

          const SizedBox(height: AppSpacing.sm),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.sm),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context).totalPaid,
                  style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
              Text(
                '₹500.00',
                style: AppTypography.bodyMedium.copyWith(
                  color: neonBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: neonBlue.withValues(alpha: 0.80),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Two-column billing item for unit price / base cost.
class _BillingItem extends StatelessWidget {
  final String label;
  final String value;

  const _BillingItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textTertiary, fontSize: 10)),
          const SizedBox(height: 2),
          Text(value,
              style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
        ],
      ),
    );
  }
}

/// Single billing line with label on left and value on right.
class _LineItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _LineItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary, fontSize: 12)),
        Text(value,
            style: AppTypography.bodySmall.copyWith(
                color: valueColor ?? Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

/// "Need help with this charge?" card at the bottom.
class _HelpCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color neonCyan = Color(0xFF00E5FF);
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: AppRadius.lgBorder,
          border: Border.all(
              color: AppColors.border.withValues(alpha: 0.4), width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.help_outline_rounded, color: neonCyan, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                AppLocalizations.of(context).needHelpWithCharge,
                style: AppTypography.bodySmall.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Colors.white54, size: 20),
          ],
        ),
      ),
    );
  }
}
