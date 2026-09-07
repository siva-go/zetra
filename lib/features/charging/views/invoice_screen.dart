import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/core/widgets/bottom_nav_bar.dart';
import 'package:zetra/features/charging/bloc/invoice_bloc.dart';
import 'package:zetra/features/charging/bloc/invoice_event.dart';
import 'package:zetra/features/charging/bloc/invoice_state.dart';
import 'package:zetra/features/charging/models/invoice_model.dart';

class InvoiceScreen extends StatelessWidget {

  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: BlocConsumer<InvoiceBloc, InvoiceState>(
          listener: (BuildContext context, InvoiceState state) {
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (BuildContext context, InvoiceState state) {

            if (state.status == InvoiceStatus.loading) {

              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.chargingGreenGlow
                )
              );

            }

            if (state.status == InvoiceStatus.failure) {

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      state.errorMessage ?? 'No invoice available',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.chargingGreenGlow.withValues(alpha: 0.2),
                        side: const BorderSide(color: AppColors.chargingGreenGlow),
                      ),
                      onPressed: () {
                        context.read<InvoiceBloc>().add(const InvoiceFetchRequested());
                      },
                      child: Text(
                        'Retry',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.chargingGreenGlow,
                        ),
                      ),
                    ),
                  ],
                ),
              );

            }

            final InvoiceDetailModel? invoice = state.invoice;

            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {

                final double h = constraints.maxHeight;
                final double vgap = h < 700 ? AppSpacing.xs : AppSpacing.sm;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const _AppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(height: vgap),
                            _OrderCard(invoice: invoice),
                            SizedBox(height: vgap),
                            _DownloadButton(invoice: invoice),
                            SizedBox(height: vgap),
                            Text(
                              AppLocalizations.of(context).sessionSummaryHeader,
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 10,
                                letterSpacing: 2,
                                color: AppColors.textTertiary,
                                fontWeight: FontWeight.w700
                              )
                            ),
                            SizedBox(height: vgap),
                            _HubCard(invoice: invoice),
                            SizedBox(height: vgap),
                            _StatsRow(invoice: invoice),
                            SizedBox(height: vgap),
                            _BillingCard(invoice: invoice),
                            SizedBox(height: vgap),
                            const _HelpCard(),
                            SizedBox(height: vgap)
                          ]
                        )
                      )
                    ),
                    const ZetraBottomNavBar(
                      currentIndex: 2
                    )
                  ]
                );

              }
            );

          }
        )
      )
    );

  }

}

class _AppBar extends StatelessWidget {

  const _AppBar();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => context.canPop() ? context.pop() : context.go('/home'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5)
                )
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.whiteColor,
                size: 16
              )
            )
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            AppLocalizations.of(context).invoice,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w700,
              fontSize: 18
            )
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.5)
              )
            ),
            child: const Icon(
              Icons.share_outlined,
              color: AppColors.whiteColor,
              size: 18
            )
          )
        ]
      )
    );

  }

}

class _OrderCard extends StatelessWidget {

  final InvoiceDetailModel? invoice;

  const _OrderCard({this.invoice});

  String _formatDate(DateTime dt) {

    return '${dt.day} ${_monthName(dt.month)} ${dt.year}';

  }

  String _monthName(int month) {

    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';

  }

  @override
  Widget build(BuildContext context) {

    const Color neonCyan = Color(0xFF00E5FF);

    final String number = invoice != null ? '#${invoice!.invoiceNumber}' : '#EVP-882910';
    final String dateStr = invoice != null ? _formatDate(invoice!.invoiceDate) : '24 Oct 2023';
    final String amountStr = invoice != null ? '₹${invoice!.grandTotal.toStringAsFixed(2)}' : '₹500.00';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: neonCyan.withValues(alpha: 0.55),
          width: 1.5
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: neonCyan.withValues(alpha: 0.22),
            blurRadius: 24,
            spreadRadius: 2
          ),
          BoxShadow(
            color: neonCyan.withValues(alpha: 0.10),
            blurRadius: 6
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'INVOICE ID',
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      color: AppColors.textTertiary
                    )
                  ),
                  const SizedBox(height: 2),
                  Text(
                    number,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 17
                    )
                  )
                ]
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 4
                ),
                decoration: BoxDecoration(
                  color: neonCyan.withValues(alpha: 0.1),
                  borderRadius: AppRadius.smBorder,
                  border: Border.all(
                    color: neonCyan.withValues(alpha: 0.4)
                  )
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: neonCyan
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateStr,
                      style: AppTypography.labelSmall.copyWith(
                        color: neonCyan,
                        fontSize: 10,
                        fontWeight: FontWeight.w600
                      )
                    )
                  ]
                )
              )
            ]
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: 1,
            color: AppColors.divider
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppLocalizations.of(context).totalAmountPaid,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11
            )
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                amountStr,
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: neonCyan,
                  shadows: <Shadow>[
                    Shadow(
                      color: neonCyan.withValues(alpha: 0.75),
                      blurRadius: 12
                    )
                  ]
                )
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  AppLocalizations.of(context).inclTaxes,
                  style: AppTypography.labelSmall.copyWith(
                    color: neonCyan,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2
                  )
                )
              )
            ]
          ),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xs
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: AppRadius.mdBorder,
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.4)
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.receipt_long_outlined,
                    color: neonCyan,
                    size: 16
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context).viewDigitalReceipt,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13
                    )
                  )
                ]
              )
            )
          )
        ]
      )
    );

  }

}

class _DownloadButton extends StatelessWidget {

  final InvoiceDetailModel? invoice;

  const _DownloadButton({this.invoice});

  @override
  Widget build(BuildContext context) {

    const Color neonCyan = Color(0xFF00E5FF);

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm
        ),
        decoration: BoxDecoration(
          color: neonCyan,
          borderRadius: AppRadius.lgBorder,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: neonCyan.withValues(alpha: 0.35),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 4)
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.download_rounded,
              color: AppColors.scaffoldDark,
              size: 20
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).downloadInvoice,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.scaffoldDark,
                fontWeight: FontWeight.w800,
                fontSize: 15
              )
            )
          ]
        )
      )
    );

  }

}

class _HubCard extends StatelessWidget {

  final InvoiceDetailModel? invoice;

  const _HubCard({this.invoice});

  @override
  Widget build(BuildContext context) {

    const Color neonGreen = Color(0xFF00FF66);
    final String station = invoice?.stationName ?? 'ZETRA GreenCharge Hub';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs
      ),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: neonGreen.withValues(alpha: 0.45),
          width: 1.5
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: neonGreen.withValues(alpha: 0.18),
            blurRadius: 20,
            spreadRadius: 1
          )
        ]
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: neonGreen.withValues(alpha: 0.1),
              borderRadius: AppRadius.smBorder,
              border: Border.all(
                color: neonGreen.withValues(alpha: 0.4)
              )
            ),
            child: const Icon(
              Icons.ev_station_rounded,
              color: Color(0xFF00FF66),
              size: 22
            )
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).chargingHub,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10
                  )
                ),
                const SizedBox(height: 2),
                Text(
                  station,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13
                  )
                )
              ]
            )
          )
        ]
      )
    );

  }

}

class _StatsRow extends StatelessWidget {

  final InvoiceDetailModel? invoice;

  const _StatsRow({this.invoice});

  String _formatDuration(int seconds) {

    final int h = seconds ~/ 3600;
    final int m = (seconds % 3600) ~/ 60;
    final int s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';

  }

  @override
  Widget build(BuildContext context) {

    const Color neonCyan = Color(0xFF00E5FF);
    const Color neonGreen = Color(0xFF00FF66);

    final String energyStr = invoice != null ? '${invoice!.energyDeliveredKwh.toStringAsFixed(1)} kWh' : '24.7 kWh';
    final String durationStr = invoice != null ? _formatDuration(invoice!.durationSeconds) : '00:47:22';

    return Row(
      children: <Widget>[
        _StatBox(
          label: AppLocalizations.of(context).energyConsumed,
          value: energyStr,
          icon: Icons.bolt_rounded,
          iconColor: neonGreen
        ),
        const SizedBox(width: AppSpacing.sm),
        _StatBox(
          label: AppLocalizations.of(context).duration,
          value: durationStr,
          icon: Icons.timer_outlined,
          iconColor: neonCyan
        )
      ]
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
    required this.iconColor
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
            color: iconColor.withValues(alpha: 0.40),
            width: 1.5
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: iconColor.withValues(alpha: 0.15),
              blurRadius: 16,
              spreadRadius: 1
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10
              )
            ),
            const SizedBox(height: 6),
            Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: iconColor,
                  size: 16
                ),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14
                  )
                )
              ]
            )
          ]
        )
      )
    );

  }

}

class _BillingCard extends StatelessWidget {

  final InvoiceDetailModel? invoice;

  const _BillingCard({this.invoice});

  @override
  Widget build(BuildContext context) {

    const Color neonBlue = Color(0xFF00E5FF);

    final double pricePerKwh = invoice?.tariffSnapshot?.pricePerKwh ?? 18.20;
    final String unitPriceStr = '₹${pricePerKwh.toStringAsFixed(2)} / kWh';

    final double taxable = invoice != null ? (invoice!.taxableAmount) : 449.54;
    final double totalTax = invoice != null ? (invoice!.totalTax) : 53.94;
    final double discount = invoice != null ? (invoice!.discountPaise / 100.0) : 18.48;
    final double grandTotal = invoice != null ? invoice!.grandTotal : 500.00;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: neonBlue.withValues(alpha: 0.50),
          width: 1.5
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: neonBlue.withValues(alpha: 0.20),
            blurRadius: 22,
            spreadRadius: 2
          ),
          BoxShadow(
            color: neonBlue.withValues(alpha: 0.08),
            blurRadius: 6
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _BillingItem(
                label: AppLocalizations.of(context).unitPrice,
                value: unitPriceStr
              ),
              const SizedBox(width: AppSpacing.sm),
              _BillingItem(
                label: AppLocalizations.of(context).baseCost,
                value: '₹${taxable.toStringAsFixed(2)}'
              )
            ]
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: 1,
            color: AppColors.divider
          ),
          const SizedBox(height: AppSpacing.sm),
          _LineItem(
            label: AppLocalizations.of(context).gst,
            value: '₹${totalTax.toStringAsFixed(2)}'
          ),
          const SizedBox(height: AppSpacing.xs),
          _LineItem(
            label: AppLocalizations.of(context).convenienceFee,
            value: '₹15.00'
          ),
          if (discount > 0) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            _LineItem(
              label: AppLocalizations.of(context).creditsApplied,
              value: '- ₹${discount.toStringAsFixed(2)}',
              valueColor: neonBlue
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: 1,
            color: AppColors.divider
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).totalPaid,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14
                )
              ),
              Text(
                '₹${grandTotal.toStringAsFixed(2)}',
                style: AppTypography.bodyMedium.copyWith(
                  color: neonBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  shadows: <Shadow>[
                    Shadow(
                      color: neonBlue.withValues(alpha: 0.80),
                      blurRadius: 10
                    )
                  ]
                )
              )
            ]
          )
        ]
      )
    );

  }

}

class _BillingItem extends StatelessWidget {

  final String label;
  final String value;

  const _BillingItem({
    required this.label,
    required this.value
  });

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: 10
            )
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w700,
              fontSize: 13
            )
          )
        ]
      )
    );

  }

}

class _LineItem extends StatelessWidget {

  final String label;
  final String value;
  final Color? valueColor;

  const _LineItem({
    required this.label,
    required this.value,
    this.valueColor
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12
          )
        ),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            color: valueColor ?? AppColors.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 12
          )
        )
      ]
    );

  }

}

class _HelpCard extends StatelessWidget {

  const _HelpCard();

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.4)
        )
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.4)
              )
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: AppColors.textSecondary,
              size: 18
            )
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Need help with this bill?',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12
                  )
                ),
                const SizedBox(height: 2),
                Text(
                  'Contact ZETRA Support',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.chargingGreenGlow,
                    fontSize: 11,
                    fontWeight: FontWeight.w600
                  )
                )
              ]
            )
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
            size: 18
          )
        ]
      )
    );

  }

}