import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/widgets/bottom_nav_bar.dart';
import 'package:zetra/features/wallet/bloc/wallet_bloc.dart';
import 'package:zetra/features/wallet/bloc/wallet_event.dart';
import 'package:zetra/features/wallet/bloc/wallet_state.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> with TickerProviderStateMixin {

  late final AnimationController _pulseController;

  @override
  void initState() {

    super.initState();
    context.read<WalletBloc>().add(const WalletInitialized());
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 1800
      )
    )..repeat(
        reverse: true
    );

  }

  @override
  void dispose() {

    _pulseController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: AppColors.navBackground,
      systemNavigationBarIconBrightness: Brightness.light
    ));

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (BuildContext ctx, WalletState state) {

          return Column(
            children: <Widget>[
              _buildAppBar(isDark, state),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                            height: 8.h
                        ),
                        _buildBalanceCard(isDark, state),
                        SizedBox(
                            height: 20.h
                        ),
                        _buildWalletIllustration(isDark),
                        SizedBox(
                            height: 24.h
                        ),
                        _buildRecentTransactionsHeader(isDark),
                        SizedBox(
                            height: 12.h
                        ),
                        _buildTransactionsList(isDark, state),
                        SizedBox(
                            height: 16.h
                        )
                      ]
                    )
                  )
                )
              ),
              ZetraBottomNavBar(
                onTap: (int idx) {

                  if (idx == 0) {

                    context.go('/home');

                  }

                }
              )
            ]
          );

        }
      )
    );

  }

  Widget _buildAppBar(bool isDark, WalletState state) {

    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color cardBg = isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;

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
              Text(
                'Wallet',
                style: AppTypography.h3.copyWith(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary
                )
              ),
              const Spacer(),
              Icon(
                  Icons.notifications_outlined,
                  color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                  size: 20.h
              )
            ]
          )
        )
      )
    ).animate().fadeIn(
        duration: 400.ms
    ).slideY(
        begin: -0.05
    );

  }

  Widget _buildBalanceCard(bool isDark, WalletState state) {

    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
            color: borderColor
        ),
        boxShadow: isDark ? <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(
                alpha: 0.05
            ),
            blurRadius: 24,
            offset: const Offset(0, 4)
          )
        ] : <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(
                alpha: 0.06
            ),
            blurRadius: 16,
            offset: const Offset(0, 4)
          )
        ]
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Current Balance',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 12.sp,
                    color: textSecondary
                  )
                ),
                SizedBox(
                    height: 4.h
                ),
                ShaderMask(
                  shaderCallback: (Rect bounds) {

                    return (state.isLowBalance ? const LinearGradient(
                      colors: <Color>[
                        AppColors.chargingRed,
                        AppColors.chargingRedLight
                      ]
                    )
                        : const LinearGradient(
                      colors: <Color>[
                        AppColors.primary,
                        AppColors.primaryLight
                      ]
                    )).createShader(bounds);

                  },
                  child: Text(
                    '₹ ${state.balance.toStringAsFixed(2)}',
                    style: AppTypography.h3.copyWith(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.whiteColor
                    )
                  )
                ),
                SizedBox(
                    height: 8.h
                ),
                if (state.isLowBalance) _buildLowBalanceBadge()
              ]
            )
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: textSecondary,
            size: 22
          )
        ]
      )
    ).animate().fadeIn(
        duration: 500.ms,
        delay: 100.ms
    ).slideY(
        begin: 0.05,
        curve: Curves.easeOutCubic
    );

  }

  Widget _buildLowBalanceBadge() {

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (BuildContext ctx, Widget? child) {

        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 4.h
          ),
          decoration: BoxDecoration(
            color: AppColors.chargingRed.withValues(
              alpha: 0.15 + _pulseController.value * 0.08
            ),
            borderRadius: AppRadius.roundBorder,
            border: Border.all(
              color: AppColors.chargingRed.withValues(
                  alpha: 0.6
              )
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.chargingRed.withValues(
                  alpha: 0.15 + _pulseController.value * 0.1
                ),
                blurRadius: 8,
                spreadRadius: 1
              )
            ]
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.chargingRed,
                size: 11
              ),
              SizedBox(
                  width: 4.w
              ),
              Text(
                'Low Balance',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 10.sp,
                  color: AppColors.chargingRed,
                  fontWeight: FontWeight.w600
                )
              )
            ]
          )
        );

      }
    );

  }

  Widget _buildWalletIllustration(bool isDark) {

    return Container(
      width: double.infinity,
      height: 220.h,
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgBorder,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? <Color>[const Color(0xFF0D1A2D), const Color(0xFF0A1520)] : <Color>[const Color(0xFFE8F5E9), const Color(0xFFE3F2FD)]
        ),
        border: Border.all(
          color: isDark ? AppColors.primary.withValues(
              alpha: 0.15
          ) : AppColors.primary.withValues(
              alpha: 0.2
          )
        )
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    AppColors.primary.withValues(
                        alpha: 0.12
                    ),
                    Colors.transparent
                  ]
                )
              )
            )
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    const Color(0xFF5AC8FA).withValues(
                        alpha: 0.08
                    ),
                    Colors.transparent
                  ]
                )
              )
            )
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/ic_wallet.png',
                  width: 150.w,
                  height: 100.h,
                  fit: BoxFit.contain
                ),
                SizedBox(
                    height: 10.h
                ),
                Text(
                  'Add money to continue charging',
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 13.sp,
                    color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600
                  )
                ),
                SizedBox(
                    height: 14.h
                ),
                GestureDetector(
                  onTap: () {

                    HapticFeedback.mediumImpact();
                    context.push('/wallet/add-money');

                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w
                    ),
                    width: double.infinity,
                    height: 42.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.lgBorder,
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color(0xFFFF073A),
                          Color(0xFF8B5CF6),
                          Color(0xFF2979FF)
                        ]
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withValues(
                              alpha: 0.55
                          ),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 4)
                        )
                      ]
                    ),
                    child: Text(
                      'Add Money',
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor
                      )
                    )
                  )
                )
              ]
            )
          )
        ]
      )
    ).animate().fadeIn(
        duration: 500.ms,
        delay: 200.ms
    ).scale(
      begin: const Offset(0.97, 0.97),
      curve: Curves.easeOutCubic
    );

  }

  Widget _buildRecentTransactionsHeader(bool isDark) {

    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Recent Transactions',
          style: AppTypography.bodyLarge.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary
          )
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'View All',
            style: AppTypography.bodySmall.copyWith(
              fontSize: 13.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600
            )
          )
        )
      ]
    ).animate().fadeIn(
        duration: 500.ms,
        delay: 350.ms
    );

  }

  Widget _buildTransactionsList(bool isDark, WalletState state) {

    return Column(
      children: state.recentTransactions.asMap().entries.map((MapEntry<int, WalletTransaction> entry) {

        return _buildTransactionTile(isDark, entry.value, entry.key);

      }).toList()
    );

  }

  Widget _buildTransactionTile(bool isDark, WalletTransaction txn, int index) {

    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color amountColor = txn.isCredit ? AppColors.primary : AppColors.chargingRed;
    final String amountStr = '${txn.isCredit ? '+' : '-'} ₹${txn.amount.toStringAsFixed(2)}';

    return Container(
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: txn.isCredit ? AppColors.primary.withValues(
                  alpha: 0.12
              ) : AppColors.chargingRed.withValues(
                  alpha: 0.1
              ),
              borderRadius: AppRadius.smBorder
            ),
            child: Icon(
              txn.isCredit ? Icons.account_balance_wallet_rounded : Icons.ev_station_rounded,
              color: txn.isCredit ? AppColors.primary : AppColors.chargingRed,
              size: 18
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
                  txn.title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: textPrimary
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis
                ),
                SizedBox(
                    height: 2.h
                ),
                Text(
                  txn.subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11.sp,
                    color: textSecondary
                  )
                )
              ]
            )
          ),
          Text(
            amountStr,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: amountColor
            )
          )
        ]
      )
    ).animate().fadeIn(
      duration: 400.ms,
      delay: Duration(
          milliseconds: 400 + index * 60
      )
    ).slideX(
        begin: 0.05,
        curve: Curves.easeOutCubic
    );

  }

}