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

class Invoice extends StatefulWidget {

  final String? invoiceId;

  const Invoice({super.key, this.invoiceId});

  @override
  State<Invoice> createState() => _InvoiceState();

}

class _InvoiceState extends State<Invoice> {

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      context.read<InvoiceBloc>().add(
        InvoiceFetchRequested(
            invoiceId: widget.invoiceId
        )
      );

    });

  }

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
                  behavior: SnackBarBehavior.floating
                )
              );

            }

            if (state.downloadedPdfPath != null && state.downloadedPdfPath!.isNotEmpty) {

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: <Widget>[
                      const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.greenAccent,
                          size: 20
                      ),
                      const SizedBox(
                          width: AppSpacing.sm
                      ),
                      Expanded(
                        child: Text(
                          'Invoice PDF downloaded: ${state.downloadedPdfPath!.split('/').last.split(r'\').last}',
                          style: AppTypography.bodySmall.copyWith(
                              color: AppColors.whiteColor
                          )
                        )
                      )
                    ]
                  ),
                  backgroundColor: AppColors.surfaceDark,
                  behavior: SnackBarBehavior.floating
                )
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

            final InvoiceDetailModel? invoice = state.invoice;

            if (invoice == null) {

              return Column(
                children: <Widget>[
                  const _AppBar(),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E5FF).withValues(
                                    alpha: 0.1
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF00E5FF).withValues(
                                      alpha: 0.3
                                  ),
                                  width: 1.5
                                )
                              ),
                              child: const Icon(
                                Icons.receipt_long_outlined,
                                size: 40,
                                color: Color(0xFF00E5FF)
                              )
                            ),
                            const SizedBox(
                                height: AppSpacing.md
                            ),
                            Text(
                              'No Invoices Available',
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 18
                              )
                            ),
                            const SizedBox(
                                height: AppSpacing.xs
                            ),
                            Text(
                              state.errorMessage ?? 'You do not have any completed charging session invoices yet. Once a session completes, your GST invoice will appear here.',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary
                              )
                            ),
                            const SizedBox(
                                height: AppSpacing.lg
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Color(0xFF00E5FF)
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                      vertical: AppSpacing.xs
                                    )
                                  ),
                                  onPressed: () {

                                    context.read<InvoiceBloc>().add(
                                      InvoiceFetchRequested(
                                          invoiceId: widget.invoiceId
                                      )
                                    );

                                  },
                                  icon: const Icon(
                                      Icons.refresh_rounded,
                                      color: Color(0xFF00E5FF),
                                      size: 18
                                  ),
                                  label: Text(
                                    'Refresh',
                                    style: AppTypography.labelLarge.copyWith(
                                      color: const Color(0xFF00E5FF)
                                    )
                                  )
                                ),
                                const SizedBox(
                                    width: AppSpacing.sm
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.chargingGreenGlow,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                      vertical: AppSpacing.xs
                                    )
                                  ),
                                  onPressed: () => context.push('/scan-qr'),
                                  icon: const Icon(
                                      Icons.qr_code_scanner_rounded,
                                      color: AppColors.scaffoldDark,
                                      size: 18
                                  ),
                                  label: Text(
                                    'Start Charging',
                                    style: AppTypography.labelLarge.copyWith(
                                      color: AppColors.scaffoldDark,
                                      fontWeight: FontWeight.w700
                                    )
                                  )
                                )
                              ]
                            )
                          ]
                        )
                      )
                    )
                  ),
                  const ZetraBottomNavBar(
                      currentIndex: 2
                  )
                ]
              );

            }

            // Real live invoice data rendered exclusively
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
                            SizedBox(
                                height: vgap
                            ),
                            _OrderCard(
                                invoice: invoice
                            ),
                            SizedBox(
                                height: vgap
                            ),
                            _DownloadButton(
                              invoice: invoice,
                              isDownloading: state.isDownloadingPdf
                            ),
                            SizedBox(
                                height: vgap
                            ),
                            Text(
                              AppLocalizations.of(context).sessionSummaryHeader,
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 10,
                                letterSpacing: 2,
                                color: AppColors.textTertiary,
                                fontWeight: FontWeight.w700
                              )
                            ),
                            SizedBox(
                                height: vgap
                            ),
                            _HubCard(
                                invoice: invoice
                            ),
                            SizedBox(
                                height: vgap
                            ),
                            _StatsRow(
                                invoice: invoice
                            ),
                            SizedBox(
                                height: vgap
                            ),
                            _BillingCard(
                                invoice: invoice
                            ),
                            if (invoice.organizationSnapshot != null) ...<Widget>[
                              SizedBox(
                                  height: vgap
                              ),
                              _OrganizationCard(
                                  snapshot: invoice.organizationSnapshot!
                              )
                            ],
                            SizedBox(
                                height: vgap
                            ),
                            const _HelpCard(),
                            SizedBox(
                                height: vgap
                            )
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
            onTap: () => context.canPop() ? context.pop() : context.go('/profile'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border.withValues(
                      alpha: 0.5
                  )
                )
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.whiteColor,
                size: 16
              )
            )
          ),
          const SizedBox(
              width: AppSpacing.sm
          ),
          Text(
            AppLocalizations.of(context).invoice,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w700,
              fontSize: 18
            )
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Use "Download GST Invoice" below to save and share the PDF.'),
                  duration: Duration(
                      seconds: 2
                  )
                )
              );

            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border.withValues(
                      alpha: 0.5
                  )
                )
              ),
              child: const Icon(
                Icons.share_outlined,
                color: AppColors.whiteColor,
                size: 18
              )
            )
          )
        ]
      )
    );

  }

}

class _OrderCard extends StatelessWidget {

  final InvoiceDetailModel invoice;

  const _OrderCard({required this.invoice});

  String _formatDate(DateTime dt) {

    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final String month = (dt.month >= 1 && dt.month <= 12) ? months[dt.month - 1] : '';
    return '${dt.day} $month ${dt.year}';

  }

  Color _statusColor(String status) {

    switch (status.toUpperCase()) {

      case 'PAID':
        return const Color(0xFF00FF66);
      case 'ISSUED':
      case 'GENERATED':
        return const Color(0xFF00E5FF);
      case 'DRAFT':
        return Colors.amberAccent;
      case 'REFUNDED':
        return Colors.purpleAccent;
      case 'CANCELLED':
        return Colors.redAccent;
      default:
        return const Color(0xFF00E5FF);

    }

  }

  @override
  Widget build(BuildContext context) {

    const Color neonCyan = Color(0xFF00E5FF);
    final Color statusColor = _statusColor(invoice.status);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: neonCyan.withValues(
              alpha: 0.55
          ),
          width: 1.5
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: neonCyan.withValues(
                alpha: 0.22
            ),
            blurRadius: 24,
            spreadRadius: 2
          ),
          BoxShadow(
            color: neonCyan.withValues(
                alpha: 0.10
            ),
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
                    'INVOICE NUMBER',
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      color: AppColors.textTertiary
                    )
                  ),
                  const SizedBox(
                      height: 2
                  ),
                  Text(
                    '#${invoice.invoiceNumber}',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16
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
                  color: statusColor.withValues(
                      alpha: 0.12
                  ),
                  borderRadius: AppRadius.smBorder,
                  border: Border.all(
                    color: statusColor.withValues(
                        alpha: 0.5
                    )
                  )
                ),
                child: Text(
                  invoice.status.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1
                  )
                )
              )
            ]
          ),
          const SizedBox(
              height: AppSpacing.xs
          ),
          Row(
            children: <Widget>[
              const Icon(
                Icons.calendar_today_outlined,
                size: 12,
                color: neonCyan
              ),
              const SizedBox(
                  width: 4
              ),
              Text(
                _formatDate(invoice.invoiceDate),
                style: AppTypography.labelSmall.copyWith(
                  color: neonCyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w600
                )
              ),
              if (invoice.customerName != null && invoice.customerName!.isNotEmpty) ...<Widget>[
                const SizedBox(
                    width: AppSpacing.sm
                ),
                const Icon(
                  Icons.person_outline_rounded,
                  size: 13,
                  color: AppColors.textTertiary
                ),
                const SizedBox(
                    width: 4
                ),
                Expanded(
                  child: Text(
                    invoice.customerName!,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                  )
                )
              ]
            ]
          ),
          const SizedBox(
              height: AppSpacing.sm
          ),
          Container(
            height: 1,
            color: AppColors.divider
          ),
          const SizedBox(
              height: AppSpacing.sm
          ),
          Text(
            AppLocalizations.of(context).totalAmountPaid,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11
            )
          ),
          const SizedBox(
              height: 4
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '₹${invoice.grandTotal.toStringAsFixed(2)}',
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: neonCyan,
                  shadows: <Shadow>[
                    Shadow(
                      color: neonCyan.withValues(
                          alpha: 0.75
                      ),
                      blurRadius: 12
                    )
                  ]
                )
              ),
              const SizedBox(
                  width: 6
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 4
                ),
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
          )
        ]
      )
    );

  }

}

class _DownloadButton extends StatelessWidget {

  final InvoiceDetailModel invoice;
  final bool isDownloading;

  const _DownloadButton({required this.invoice, required this.isDownloading});

  @override
  Widget build(BuildContext context) {

    const Color neonCyan = Color(0xFF00E5FF);

    return GestureDetector(
      onTap: isDownloading ? null : () {

        context.read<InvoiceBloc>().add(
          InvoiceDownloadPdfRequested(
              invoiceId: invoice.id
          )
        );

      },
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
              color: neonCyan.withValues(
                  alpha: 0.35
              ),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 4)
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isDownloading) ...<Widget>[
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.scaffoldDark
                )
              ),
              const SizedBox(
                  width: AppSpacing.sm
              ),
              Text(
                'Generating PDF...',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.scaffoldDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 14
                )
              )
            ] else ...<Widget>[
              const Icon(
                Icons.picture_as_pdf_rounded,
                color: AppColors.scaffoldDark,
                size: 20
              ),
              const SizedBox(
                  width: 8
              ),
              Text(
                AppLocalizations.of(context).downloadInvoice,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.scaffoldDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 14
                )
              )
            ]
          ]
        )
      )
    );

  }

}

class _HubCard extends StatelessWidget {

  final InvoiceDetailModel invoice;

  const _HubCard({required this.invoice});

  @override
  Widget build(BuildContext context) {

    const Color neonGreen = Color(0xFF00FF66);
    final String station = invoice.stationName ?? 'EV Charging Hub';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs
      ),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: neonGreen.withValues(
              alpha: 0.45
          ),
          width: 1.5
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: neonGreen.withValues(
                alpha: 0.18
            ),
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
              color: neonGreen.withValues(
                  alpha: 0.1
              ),
              borderRadius: AppRadius.smBorder,
              border: Border.all(
                color: neonGreen.withValues(
                    alpha: 0.4
                )
              )
            ),
            child: const Icon(
              Icons.ev_station_rounded,
              color: Color(0xFF00FF66),
              size: 22
            )
          ),
          const SizedBox(
              width: AppSpacing.sm
          ),
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
                const SizedBox(
                    height: 2
                ),
                Text(
                  station,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13
                  )
                ),
                if (invoice.chargePointId != null && invoice.chargePointId!.isNotEmpty) ...<Widget>[
                  const SizedBox(
                      height: 2
                  ),
                  Text(
                    'Point: ${invoice.chargePointId}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10
                    )
                  )
                ]
              ]
            )
          ),
          if (invoice.placeOfSupply != null && invoice.placeOfSupply!.isNotEmpty) ...<Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: AppRadius.smBorder
              ),
              child: Text(
                invoice.placeOfSupply!,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 10
                )
              )
            )
          ]
        ]
      )
    );

  }

}

class _StatsRow extends StatelessWidget {

  final InvoiceDetailModel invoice;

  const _StatsRow({required this.invoice});

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

    return Row(
      children: <Widget>[
        _StatBox(
          label: AppLocalizations.of(context).energyConsumed,
          value: '${invoice.energyDeliveredKwh.toStringAsFixed(2)} kWh',
          icon: Icons.bolt_rounded,
          iconColor: neonGreen
        ),
        const SizedBox(
            width: AppSpacing.sm
        ),
        _StatBox(
          label: AppLocalizations.of(context).duration,
          value: _formatDuration(invoice.durationSeconds),
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

  const _StatBox({required this.label, required this.value, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: AppRadius.mdBorder,
          border: Border.all(
            color: iconColor.withValues(
                alpha: 0.35
            )
          )
        ),
        child: Row(
          children: <Widget>[
            Icon(
                icon,
                color: iconColor,
                size: 18
            ),
            const SizedBox(
                width: 8
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 10
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                  ),
                  const SizedBox(
                      height: 2
                  ),
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
            )
          ]
        )
      )
    );

  }

}

class _BillingCard extends StatelessWidget {

  final InvoiceDetailModel invoice;

  const _BillingCard({required this.invoice});

  @override
  Widget build(BuildContext context) {

    const Color neonBlue = Color(0xFF00E5FF);

    final String unitPriceStr = invoice.tariffSnapshot != null && invoice.tariffSnapshot!.pricePerKwh > 0 ? '₹${invoice.tariffSnapshot!.pricePerKwh.toStringAsFixed(2)} / kWh' : '—';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: neonBlue.withValues(
              alpha: 0.50
          ),
          width: 1.5
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: neonBlue.withValues(
                alpha: 0.20
            ),
            blurRadius: 22,
            spreadRadius: 2
          ),
          BoxShadow(
            color: neonBlue.withValues(
                alpha: 0.08
            ),
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
              const SizedBox(
                  width: AppSpacing.sm
              ),
              _BillingItem(
                label: AppLocalizations.of(context).baseCost,
                value: '₹${invoice.taxableAmount.toStringAsFixed(2)}'
              )
            ]
          ),
          const SizedBox(
              height: AppSpacing.sm
          ),
          Container(
              height: 1,
              color: AppColors.divider
          ),
          const SizedBox(
              height: AppSpacing.sm
          ),
          _LineItem(
            label: AppLocalizations.of(context).gst,
            value: '₹${invoice.totalTax.toStringAsFixed(2)}'
          ),
          if (invoice.cgstAmountPaise > 0) ...<Widget>[
            const SizedBox(
                height: AppSpacing.xs
            ),
            _LineItem(
              label: '  CGST ${invoice.cgstRate != null ? '(${invoice.cgstRate}%)' : ''}',
              value: '₹${(invoice.cgstAmountPaise / 100.0).toStringAsFixed(2)}',
              isSubItem: true
            )
          ],
          if (invoice.sgstAmountPaise > 0) ...<Widget>[
            const SizedBox(
                height: AppSpacing.xs
            ),
            _LineItem(
              label: '  SGST ${invoice.sgstRate != null ? '(${invoice.sgstRate}%)' : ''}',
              value: '₹${(invoice.sgstAmountPaise / 100.0).toStringAsFixed(2)}',
              isSubItem: true
            )
          ],
          if (invoice.igstAmountPaise > 0) ...<Widget>[
            const SizedBox(
                height: AppSpacing.xs
            ),
            _LineItem(
              label: '  IGST ${invoice.igstRate != null ? '(${invoice.igstRate}%)' : ''}',
              value: '₹${(invoice.igstAmountPaise / 100.0).toStringAsFixed(2)}',
              isSubItem: true
            )
          ],
          if (invoice.connectionFeePaise > 0) ...<Widget>[
            const SizedBox(
                height: AppSpacing.xs
            ),
            _LineItem(
              label: AppLocalizations.of(context).convenienceFee,
              value: '₹${(invoice.connectionFeePaise / 100.0).toStringAsFixed(2)}'
            )
          ],
          if (invoice.discountPaise > 0) ...<Widget>[
            const SizedBox(
                height: AppSpacing.xs
            ),
            _LineItem(
              label: AppLocalizations.of(context).creditsApplied,
              value: '- ₹${(invoice.discountPaise / 100.0).toStringAsFixed(2)}',
              valueColor: const Color(0xFF00FF66)
            )
          ],
          const SizedBox(
              height: AppSpacing.sm
          ),
          Container(
              height: 1,
              color: AppColors.divider
          ),
          const SizedBox(
              height: AppSpacing.sm
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total Amount',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14
                )
              ),
              Text(
                '₹${invoice.grandTotal.toStringAsFixed(2)}',
                style: AppTypography.bodyLarge.copyWith(
                  color: neonBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 16
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

  const _BillingItem({required this.label, required this.value});

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
          const SizedBox(
              height: 2
          ),
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
  final bool isSubItem;

  const _LineItem({required this.label, required this.value, this.valueColor, this.isSubItem = false});

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isSubItem ? AppColors.textTertiary : AppColors.textSecondary,
            fontSize: isSubItem ? 11 : 12
          )
        ),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            color: valueColor ?? AppColors.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: isSubItem ? 11 : 12
          )
        )
      ]
    );

  }

}

class _OrganizationCard extends StatelessWidget {

  final InvoiceOrganizationSnapshotModel snapshot;

  const _OrganizationCard({required this.snapshot});

  @override
  Widget build(BuildContext context) {

    final String name = snapshot.legalName ?? snapshot.name ?? '';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.mdBorder,
        border: Border.all(
          color: AppColors.border.withValues(
              alpha: 0.35
          )
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (name.isNotEmpty) ...<Widget>[
            Text(
              name,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w700,
                fontSize: 12
              )
            ),
            const SizedBox(
                height: 2
            ),
          ],
          if (snapshot.gstNumber != null && snapshot.gstNumber!.isNotEmpty) ...<Widget>[
            Text(
              'GSTIN: ${snapshot.gstNumber}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10
              )
            )
          ],
          if (snapshot.address != null && snapshot.address!.isNotEmpty) ...<Widget>[
            const SizedBox(
                height: 2
            ),
            Text(
              snapshot.address!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10
              )
            )
          ],
          if (snapshot.invoiceFooter != null && snapshot.invoiceFooter!.isNotEmpty) ...<Widget>[
            const SizedBox(
                height: 4
            ),
            Text(
              snapshot.invoiceFooter!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontStyle: FontStyle.italic
              )
            )
          ]
        ]
      )
    );

  }

}

class _HelpCard extends StatelessWidget {

  const _HelpCard();

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: AppRadius.mdBorder,
        border: Border.all(
          color: AppColors.border.withValues(
              alpha: 0.35
          )
        )
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.headset_mic_outlined,
            color: AppColors.textSecondary,
            size: 18
          ),
          const SizedBox(
              width: AppSpacing.sm
          ),
          Expanded(
            child: Text(
              'Need help with this invoice? Contact support in Profile > Help.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11
              )
            )
          )
        ]
      )
    );

  }

}