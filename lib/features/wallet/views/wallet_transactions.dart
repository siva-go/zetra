import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/features/wallet/bloc/wallet_bloc.dart';
import 'package:zetra/features/wallet/bloc/wallet_event.dart';
import 'package:zetra/features/wallet/bloc/wallet_state.dart';
import 'package:zetra/features/wallet/models/wallet_model.dart';

class WalletTransactionsScreen extends StatelessWidget {
  const WalletTransactionsScreen({super.key});

  Future<void> _onRefresh(BuildContext context) async {

    await HapticFeedback.lightImpact();
    if (context.mounted) {

      context.read<WalletBloc>().add(const WalletLoadRequested());

    }

  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (BuildContext ctx, WalletState state) {

          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {

            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!)
              )
            );

          }

        },
        builder: (BuildContext ctx, WalletState state) {

          final List<WalletTransactionModel> filteredTxns = state.filteredTransactions;

          return Column(
            children: <Widget>[
              _buildAppBar(ctx, isDark),
              _buildBalanceSummary(ctx, isDark, state),
              _buildFilterChips(ctx, isDark, state.transactionFilter),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: isDark ? AppColors.cardDark : AppColors.whiteColor,
                  onRefresh: () => _onRefresh(ctx),
                  child: filteredTxns.isEmpty
                      ? _buildEmptyState(isDark, state)
                      : _buildTransactionsList(ctx, isDark, filteredTxns, state)
                )
              )
            ]
          );

        }
      )
    );

  }

  Widget _buildAppBar(BuildContext context, bool isDark) {

    final Color cardBg = isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 0.5
          )
        )
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h
          ),
          child: Row(
            children: <Widget>[
              InkWell(
                borderRadius: AppRadius.roundBorder,
                onTap: () {

                  HapticFeedback.lightImpact();
                  if (context.canPop()) {

                    context.pop();

                  } else {

                    context.go('/wallet');

                  }

                },
                child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: textPrimary,
                    size: 20.h
                  )
                )
              ),
              SizedBox(
                width: 8.w
              ),
              Text(
                'All Transactions',
                style: AppTypography.h3.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary
                )
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: textPrimary,
                  size: 22.h
                ),
                onPressed: () => _onRefresh(context)
              )
            ]
          )
        )
      )
    ).animate().fadeIn(
      duration: 350.ms
    );

  }

  Widget _buildBalanceSummary(BuildContext context, bool isDark, WalletState state) {

    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.mdBorder,
        border: Border.all(
          color: borderColor
        ),
        boxShadow: isDark ? null : <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(
              alpha: 0.04
            ),
            blurRadius: 8,
            offset: const Offset(0, 2)
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).currentBalance,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12.sp,
                  color: textSecondary
                )
              ),
              SizedBox(
                height: 2.h
              ),
              Text(
                '₹${state.balance.toStringAsFixed(2)}',
                style: AppTypography.bodyLarge.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: textPrimary
                )
              )
            ]
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.blackColor,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 8.h
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.smBorder
              )
            ),
            onPressed: () {

              HapticFeedback.lightImpact();
              context.push('/wallet/add-money');

            },
            icon: const Icon(
              Icons.add_rounded,
              size: 18
            ),
            label: Text(
              AppLocalizations.of(context).addMoney,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp
              )
            )
          )
        ]
      )
    ).animate().fadeIn(
      duration: 400.ms,
      delay: 100.ms
    );

  }

  Widget _buildFilterChips(
    BuildContext context,
    bool isDark,
    WalletTransactionFilter currentFilter
  ) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h
      ),
      child: Row(
        children: <Widget>[
          _buildChip(
            label: 'All',
            icon: Icons.list_alt_rounded,
            isSelected: currentFilter == WalletTransactionFilter.all,
            isDark: isDark,
            onTap: () {

              HapticFeedback.selectionClick();
              context.read<WalletBloc>().add(
                const WalletTransactionFilterChanged(WalletTransactionFilter.all)
              );

            }
          ),
          SizedBox(
            width: 8.w
          ),
          _buildChip(
            label: 'Credits (+)',
            icon: Icons.arrow_downward_rounded,
            isSelected: currentFilter == WalletTransactionFilter.credits,
            isDark: isDark,
            onTap: () {

              HapticFeedback.selectionClick();
              context.read<WalletBloc>().add(
                const WalletTransactionFilterChanged(WalletTransactionFilter.credits)
              );

            }
          ),
          SizedBox(
            width: 8.w
          ),
          _buildChip(
            label: 'Debits (-)',
            icon: Icons.arrow_upward_rounded,
            isSelected: currentFilter == WalletTransactionFilter.debits,
            isDark: isDark,
            onTap: () {

              HapticFeedback.selectionClick();
              context.read<WalletBloc>().add(
                const WalletTransactionFilterChanged(WalletTransactionFilter.debits)
              );

            }
          )
        ]
      )
    );

  }

  Widget _buildChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap
  }) {

    const Color selectedBg = AppColors.primary;
    final Color unselectedBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    const Color selectedTextColor = AppColors.blackColor;
    final Color unselectedTextColor = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color borderColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.border : AppColors.borderLight);

    return InkWell(
      borderRadius: AppRadius.roundBorder,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 8.h
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: AppRadius.roundBorder,
          border: Border.all(
            color: borderColor
          ),
          boxShadow: isSelected ? <BoxShadow>[
            BoxShadow(
              color: AppColors.primary.withValues(
                alpha: 0.3
              ),
              blurRadius: 8,
              offset: const Offset(0, 2)
            )
          ] : null
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 14.sp,
              color: isSelected ? selectedTextColor : unselectedTextColor
            ),
            SizedBox(
              width: 6.w
            ),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? selectedTextColor : unselectedTextColor
              )
            )
          ]
        )
      )
    );

  }

  Widget _buildTransactionsList(
    BuildContext context,
    bool isDark,
    List<WalletTransactionModel> transactions,
    WalletState state
  ) {

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {

        if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {

          if (state.hasMoreTransactions && !state.isLoadingTransactions) {

            context.read<WalletBloc>().add(const WalletTransactionsLoadMore());

          }

        }
        return false;

      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()
        ),
        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
        itemCount: transactions.length + (state.isLoadingTransactions ? 1 : 0),
        itemBuilder: (BuildContext ctx, int index) {

          if (index == transactions.length) {

            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16.h
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2.5
                  )
                )
              )
            );

          }

          final WalletTransactionModel txn = transactions[index];
          return _buildTransactionCard(ctx, isDark, txn, index);

        }
      )
    );

  }

  Widget _buildTransactionCard(
    BuildContext context,
    bool isDark,
    WalletTransactionModel txn,
    int index
  ) {

    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color amountColor = txn.isCredit ? AppColors.primary : AppColors.chargingRed;
    final String amountStr = '${txn.isCredit ? '+' : '-'} ₹${txn.amount.toStringAsFixed(2)}';
    final String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(txn.createdAt);

    return InkWell(
      borderRadius: AppRadius.mdBorder,
      onTap: () {

        HapticFeedback.selectionClick();
        _showTransactionDetailModal(context, txn, isDark);

      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10.h
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 12.h
        ),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: AppRadius.mdBorder,
          border: Border.all(
            color: borderColor
          ),
          boxShadow: isDark ? null : <BoxShadow>[
            BoxShadow(
              color: AppColors.blackColor.withValues(
                alpha: 0.04
              ),
              blurRadius: 8,
              offset: const Offset(0, 2)
            )
          ]
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: txn.isCredit
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.chargingRed.withValues(alpha: 0.1),
                borderRadius: AppRadius.smBorder
              ),
              child: Icon(
                txn.isCredit
                    ? Icons.account_balance_wallet_rounded
                    : Icons.ev_station_rounded,
                color: txn.isCredit ? AppColors.primary : AppColors.chargingRed,
                size: 20
              )
            ),
            SizedBox(
              width: 12.w
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    txn.description ?? (txn.isCredit ? 'Wallet Top-up' : 'Charging Session'),
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: textPrimary
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                  ),
                  SizedBox(
                    height: 3.h
                  ),
                  Text(
                    formattedDate,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11.sp,
                      color: textSecondary
                    )
                  ),
                  if (txn.reference != null && txn.reference!.isNotEmpty) ...<Widget>[
                    SizedBox(
                      height: 3.h
                    ),
                    Text(
                      'Ref: ${txn.reference}',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 10.sp,
                        color: isDark ? AppColors.textTertiary : AppColors.textTertiaryLight
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis
                    )
                  ]
                ]
              )
            ),
            SizedBox(
              width: 8.w
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  amountStr,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: amountColor
                  )
                ),
                SizedBox(
                  height: 2.h
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 2.h
                  ),
                  decoration: BoxDecoration(
                    color: (txn.isCredit ? AppColors.primary : AppColors.chargingOrange).withValues(
                      alpha: 0.1
                    ),
                    borderRadius: AppRadius.smBorder
                  ),
                  child: Text(
                    txn.type,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: txn.isCredit ? AppColors.primary : AppColors.chargingOrange
                    )
                  )
                )
              ]
            )
          ]
        )
      )
    ).animate().fadeIn(
      duration: 350.ms,
      delay: Duration(
        milliseconds: 50 + (index % 10) * 30
      )
    ).slideX(
      begin: 0.04,
      curve: Curves.easeOutCubic
    );

  }

  Widget _buildEmptyState(bool isDark, WalletState state) {

    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    if (state.status == WalletStatus.loading) {

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator.adaptive(),
            SizedBox(
              height: 16.h
            ),
            Text(
              'Loading transactions...',
              style: AppTypography.bodyMedium.copyWith(
                color: textSecondary
              )
            )
          ]
        )
      );

    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.cardDark
                            : AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.border : AppColors.borderLight
                        )
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        size: 38,
                        color: isDark ? AppColors.textSecondary : AppColors.primary
                      )
                    ),
                    SizedBox(
                      height: 16.h
                    ),
                    Text(
                      'No Transactions Found',
                      style: AppTypography.bodyLarge.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: textPrimary
                      )
                    ),
                    SizedBox(
                      height: 6.h
                    ),
                    Text(
                      state.transactionFilter == WalletTransactionFilter.all
                          ? 'You do not have any wallet transactions yet.'
                          : 'No ${state.transactionFilter.name} found in your transaction history.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 13.sp,
                        color: textSecondary
                      )
                    )
                  ]
                )
              )
            )
          )
        );

      }
    );

  }

  void _showTransactionDetailModal(
    BuildContext context,
    WalletTransactionModel txn,
    bool isDark
  ) {

    final Color cardBg = isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight;
    final Color containerBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color amountColor = txn.isCredit ? AppColors.primary : AppColors.chargingRed;
    final String amountStr = '${txn.isCredit ? '+' : '-'} ₹${txn.amount.toStringAsFixed(2)}';
    final String formattedDate = DateFormat('dd MMMM yyyy, hh:mm:ss a').format(txn.createdAt);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24)
        )
      ),
      builder: (BuildContext ctx) {

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.border : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2)
                  )
                ),
                SizedBox(
                  height: 20.h
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: txn.isCredit
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.chargingRed.withValues(alpha: 0.12),
                    shape: BoxShape.circle
                  ),
                  child: Icon(
                    txn.isCredit
                        ? Icons.account_balance_wallet_rounded
                        : Icons.ev_station_rounded,
                    color: txn.isCredit ? AppColors.primary : AppColors.chargingRed,
                    size: 28
                  )
                ),
                SizedBox(
                  height: 12.h
                ),
                Text(
                  amountStr,
                  style: AppTypography.h3.copyWith(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: amountColor
                  )
                ),
                SizedBox(
                  height: 4.h
                ),
                Text(
                  txn.description ?? (txn.isCredit ? 'Wallet Credit' : 'Wallet Debit'),
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: textPrimary
                  )
                ),
                SizedBox(
                  height: 20.h
                ),
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: containerBg,
                    borderRadius: AppRadius.mdBorder,
                    border: Border.all(
                      color: borderColor
                    )
                  ),
                  child: Column(
                    children: <Widget>[
                      _buildDetailRow('Transaction ID', txn.id, textSecondary, textPrimary, isDark),
                      Divider(
                        height: 20.h,
                        color: borderColor
                      ),
                      _buildDetailRow('Date & Time', formattedDate, textSecondary, textPrimary, isDark),
                      Divider(
                        height: 20.h,
                        color: borderColor
                      ),
                      _buildDetailRow('Type', txn.type, textSecondary, textPrimary, isDark),
                      if (txn.reference != null && txn.reference!.isNotEmpty) ...<Widget>[
                        Divider(
                          height: 20.h,
                          color: borderColor
                        ),
                        _buildDetailRow('Reference', txn.reference!, textSecondary, textPrimary, isDark)
                      ],
                      Divider(
                        height: 20.h,
                        color: borderColor
                      ),
                      _buildDetailRow('Status', 'Success', textSecondary, AppColors.primary, isDark)
                    ]
                  )
                ),
                SizedBox(
                  height: 16.h
                ),
                SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: borderColor
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.smBorder
                      )
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(
                      'Close',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textPrimary
                      )
                    )
                  )
                )
              ]
            )
          )
        );

      }
    );

  }

  Widget _buildDetailRow(
    String label,
    String value,
    Color labelColor,
    Color valueColor,
    bool isDark
  ) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 12.sp,
            color: labelColor
          )
        ),
        SizedBox(
          width: 12.w
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: valueColor
            ),
            overflow: TextOverflow.ellipsis
          )
        )
      ]
    );

  }

}