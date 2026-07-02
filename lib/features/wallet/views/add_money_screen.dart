import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/features/wallet/bloc/wallet_bloc.dart';
import 'package:zetra/features/wallet/bloc/wallet_event.dart';
import 'package:zetra/features/wallet/bloc/wallet_state.dart';

class _PaymentMethod {

  final String id;
  final String label;
  final IconData icon;
  final Color iconColor;

  const _PaymentMethod({required this.id, required this.label, required this.icon, required this.iconColor});

}

const List<_PaymentMethod> _paymentMethods = <_PaymentMethod>[
  _PaymentMethod(
    id: 'UPI',
    label: 'UPI',
    icon: Icons.smartphone_rounded,
    iconColor: Color(0xFF5AC8FA)
  ),
  _PaymentMethod(
    id: 'Card',
    label: 'Credit / Debit Card',
    icon: Icons.credit_card_rounded,
    iconColor: Color(0xFFFF9500)
  ),
  _PaymentMethod(
    id: 'NetBanking',
    label: 'Net Banking',
    icon: Icons.account_balance_rounded,
    iconColor: Color(0xFF9B59B6)
  ),
  _PaymentMethod(
    id: 'Wallet',
    label: 'Wallet',
    icon: Icons.account_balance_wallet_rounded,
    iconColor: Color(0xFF00C853)
  )
];

const List<int> _quickAmounts = <int>[500, 1000, 2000];

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> with SingleTickerProviderStateMixin {

  late final TextEditingController _amountController;
  late final FocusNode _amountFocus;
  late final AnimationController _shimmerController;

  @override
  void initState() {

    super.initState();

    final WalletState state = context.read<WalletBloc>().state;
    _amountController = TextEditingController(
        text: state.enteredAmount
    );
    _amountFocus = FocusNode();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 1400
      )
    )..repeat();

  }

  @override
  void dispose() {

    _amountController.dispose();
    _amountFocus.dispose();
    _shimmerController.dispose();
    super.dispose();

  }

  void _onQuickAmount(int amount) {

    HapticFeedback.selectionClick();
    _amountController.text = amount.toString();
    _amountController.selection = TextSelection.fromPosition(
      TextPosition(
          offset: _amountController.text.length
      )
    );
    context.read<WalletBloc>().add(QuickAmountSelected(amount));

  }

  void _onPay() {

    HapticFeedback.mediumImpact();
    context.read<WalletBloc>().add(const PaymentInitiated());

  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<WalletBloc, WalletState>(
      listener: (BuildContext ctx, WalletState state) {

        if (state.status == WalletStatus.success) {

          _showSuccessAndPop(ctx, state);

        }

      },
      builder: (BuildContext ctx2, WalletState state) {

        final bool isPaying = state.status == WalletStatus.paying;
        final bool isDark2 = isDark;

        return Scaffold(
          backgroundColor: isDark2 ? AppColors.scaffoldDark : AppColors.scaffoldLight,
          body: GestureDetector(
            onTap: () => _amountFocus.unfocus(),
            child: Column(
              children: <Widget>[
                _buildAppBar(isDark),
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
                              height: 20.h
                          ),
                          _buildAmountLabel(isDark),
                          SizedBox(
                              height: 10.h
                          ),
                          _buildAmountInput(isDark, state),
                          if (state.errorMessage != null) ...<Widget>[
                            SizedBox(
                                height: 6.h
                            ),
                            _buildError(state.errorMessage!)
                          ],
                          SizedBox(
                              height: 14.h
                          ),
                          _buildQuickAmountChips(isDark, state),
                          SizedBox(
                              height: 24.h
                          ),
                          _buildSectionLabel('Choose Payment Method', isDark),
                          SizedBox(
                              height: 12.h
                          ),
                          _buildPaymentMethods(isDark, state),
                          SizedBox(
                              height: 32.h
                          ),
                          _buildAddMoneyButton(isDark, state, isPaying),
                          SizedBox(
                              height: 12.h
                          ),
                          _buildSecuredLabel(isDark),
                          SizedBox(
                              height: 24.h
                          )
                        ]
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

  Widget _buildAppBar(bool isDark) {

    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
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
              horizontal: 8.w,
              vertical: 10.h
          ),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: textPrimary,
                  size: 18
                )
              ),
              Text(
                'Add Money',
                style: AppTypography.bodyLarge.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary
                )
              )
            ]
          )
        )
      ),
    ).animate().fadeIn(
        duration: 300.ms
    );

  }

  Widget _buildAmountLabel(bool isDark) {

    return Text(
      'Enter Amount',
      style: AppTypography.bodySmall.copyWith(
        fontSize: 13.sp,
        color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
        fontWeight: FontWeight.w500
      )
    ).animate().fadeIn(
        delay: 50.ms,
        duration: 400.ms
    );

  }

  Widget _buildAmountInput(bool isDark, WalletState state) {

    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: _amountFocus.hasFocus ? AppColors.primary : borderColor,
          width: _amountFocus.hasFocus ? 1.5 : 1
        ),
        boxShadow: _amountFocus.hasFocus ? <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(
                alpha: 0.18
            ),
            blurRadius: 14,
            spreadRadius: 1
          )
        ] : null
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
              width: 16.w
          ),
          ShaderMask(
            shaderCallback: (Rect bounds) => const LinearGradient(
              colors: <Color>[AppColors.primary, AppColors.primaryLight]
            ).createShader(bounds),
            child: Text(
              '₹',
              style: AppTypography.h3.copyWith(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.whiteColor
              )
            )
          ),
          SizedBox(
              width: 8.w
          ),
          Expanded(
            child: TextField(
              controller: _amountController,
              focusNode: _amountFocus,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6)
              ],
              onChanged: (String value) {

                context.read<WalletBloc>().add(AmountChanged(value));

              },
              style: AppTypography.h3.copyWith(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: textPrimary
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: '0',
                hintStyle: AppTypography.h3.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textHint : AppColors.textHintLight
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 16.h
                )
              )
            )
          ),
          SizedBox(
              width: 16.w
          )
        ]
      )
    ).animate().fadeIn(
        delay: 80.ms,
        duration: 400.ms
    ).slideY(
        begin: 0.05,
        curve: Curves.easeOutCubic
    );

  }

  Widget _buildError(String message) {

    return Row(
      children: <Widget>[
        const Icon(
            Icons.error_outline,
            color: AppColors.chargingRed,
            size: 14
        ),
        SizedBox(
            width: 6.w
        ),
        Text(
          message,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 12.sp,
            color: AppColors.chargingRed
          )
        )
      ]
    );

  }

  Widget _buildQuickAmountChips(bool isDark, WalletState state) {

    return Row(
      children: <Widget>[
        ..._quickAmounts.map((int amount) {

          final bool isSelected = state.selectedQuickAmount == amount;

          return Padding(
            padding: EdgeInsets.only(
                right: 10.w
            ),
            child: _QuickAmountChip(
              amount: amount,
              isSelected: isSelected,
              isDark: isDark,
              onTap: () => _onQuickAmount(amount)
            )
          );

        }),
        _OtherChip(
          isDark: isDark,
          isSelected: state.selectedQuickAmount == null && state.enteredAmount.isNotEmpty,
          onTap: () {

            _amountFocus.requestFocus();

          }
        )
      ]
    ).animate().fadeIn(
        delay: 120.ms,
        duration: 400.ms
    );

  }

  Widget _buildSectionLabel(String text, bool isDark) {

    return Text(
      text,
      style: AppTypography.bodyMedium.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight
      )
    ).animate().fadeIn(
        delay: 150.ms,
        duration: 400.ms
    );

  }

  Widget _buildPaymentMethods(bool isDark, WalletState state) {

    return Column(
      children: _paymentMethods.asMap().entries.map((MapEntry<int, _PaymentMethod> entry) {

        final int idx = entry.key;
        final _PaymentMethod method = entry.value;
        final bool isSelected = state.selectedPaymentMethod == method.id;

        return _PaymentMethodTile(
          method: method,
          isSelected: isSelected,
          isDark: isDark,
          onTap: () {

            HapticFeedback.selectionClick();
            context.read<WalletBloc>().add(PaymentMethodSelected(method.id));

          },
          index: idx
        );

      }).toList()
    );

  }

  Widget _buildAddMoneyButton(bool isDark, WalletState state, bool isPaying) {

    final double amount = double.tryParse(state.enteredAmount) ?? 0;
    final String label = amount > 0 ? 'Add  ₹${amount.toStringAsFixed(0)}' : 'Add Money';

    return GestureDetector(
      onTap: isPaying ? null : _onPay,
      child: AnimatedContainer(
        duration: const Duration(
            milliseconds: 200
        ),
        width: double.infinity,
        height: 54.h,
        decoration: BoxDecoration(
          borderRadius: AppRadius.lgBorder,
          gradient: LinearGradient(
            colors: isPaying ? <Color>[
              AppColors.primary.withValues(
                  alpha: 0.6
              ),
              AppColors.primaryLight.withValues(
                  alpha: 0.6
              )
            ] : const <Color>[
              Color(0xFF00C853),
              Color(0xFF00E676)
            ]
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF00C853).withValues(
                  alpha: 0.4
              ),
              blurRadius: 18,
              offset: const Offset(0, 6)
            )
          ]
        ),
        child: isPaying ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color?>(AppColors.blackColor),
              )
            ),
            SizedBox(
                width: 12.w
            ),
            Text(
              'Processing...',
              style: AppTypography.bodyLarge.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor
              )
            )
          ]
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
                Icons.add_rounded,
                color: AppColors.blackColor,
                size: 20
            ),
            SizedBox(
                width: 8.w
            ),
            Text(
              label,
              style: AppTypography.bodyLarge.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor
              )
            )
          ]
        )
      )
    ).animate().fadeIn(
        delay: 300.ms,
        duration: 400.ms
    );

  }

  Widget _buildSecuredLabel(bool isDark) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.lock_outline_rounded,
          color: isDark ? AppColors.textTertiary : AppColors.textTertiaryLight,
          size: 13
        ),
        SizedBox(
            width: 5.w
        ),
        Text(
          'Secured by Zetra Pay',
          style: AppTypography.bodySmall.copyWith(
            fontSize: 11.sp,
            color: isDark ? AppColors.textTertiary : AppColors.textTertiaryLight
          )
        )
      ]
    ).animate().fadeIn(
        delay: 350.ms,
        duration: 400.ms
    );

  }

  void _showSuccessAndPop(BuildContext ctx, WalletState state) {

    showDialog<void>(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => _PaymentSuccessDialog(
        amount: double.tryParse(state.enteredAmount) ?? 0,
        newBalance: state.balance,
        isDark: Theme.of(ctx).brightness == Brightness.dark
      )
    ).then((_) {

      ctx.read<WalletBloc>().add(const PaymentResultReceived(true));

      if (ctx.mounted) {

        ctx.pop();

      }

    });

  }

}


class _QuickAmountChip extends StatelessWidget {

  final int amount;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _QuickAmountChip({required this.amount, required this.isSelected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {

    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
            milliseconds: 200
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 18.w,
            vertical: 10.h
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(
              alpha: isDark ? 0.15 : 0.1
          ) : cardBg,
          borderRadius: AppRadius.lgBorder,
          border: Border.all(
            color: isSelected ? AppColors.primary : borderColor,
            width: isSelected ? 1.5 : 1
          ),
          boxShadow: isSelected ? <BoxShadow>[
            BoxShadow(
              color: AppColors.primary.withValues(
                  alpha: 0.2
              ),
              blurRadius: 10,
            )
          ] : null
        ),
        child: Text(
          '₹$amount',
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.primary : (isDark ? AppColors.textPrimary : AppColors.textPrimaryLight)
          )
        )
      )
    );

  }
}

// ─── "Other" chip ─────────────────────────────────────────────────────────────

class _OtherChip extends StatelessWidget {
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  const _OtherChip({
    required this.isDark,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.1)
              : cardBg,
          borderRadius: AppRadius.lgBorder,
          border: Border.all(
            color: isSelected ? AppColors.primary : borderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          'Other',
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? AppColors.primary
                : (isDark
                    ? AppColors.textPrimary
                    : AppColors.textPrimaryLight),
          ),
        ),
      ),
    );
  }
}

// ─── Payment method tile ──────────────────────────────────────────────────────

class _PaymentMethodTile extends StatelessWidget {
  final _PaymentMethod method;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;
  final int index;

  const _PaymentMethodTile({
    required this.method,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color textPrimary =
        isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? method.iconColor.withValues(alpha: 0.08)
                  : method.iconColor.withValues(alpha: 0.05))
              : cardBg,
          borderRadius: AppRadius.mdBorder,
          border: Border.all(
            color: isSelected ? method.iconColor.withValues(alpha: 0.5) : borderColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: method.iconColor.withValues(alpha: 0.12),
                    blurRadius: 10,
                    spreadRadius: 0,
                  )
                ]
              : isDark
                  ? null
                  : <BoxShadow>[
                      BoxShadow(
                        color: AppColors.blackColor.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
        ),
        child: Row(
          children: <Widget>[
            // Icon container
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: method.iconColor.withValues(alpha: 0.12),
                borderRadius: AppRadius.smBorder,
              ),
              child: Icon(method.icon, color: method.iconColor, size: 18),
            ),
            SizedBox(width: 14.w),
            // Label
            Expanded(
              child: Text(
                method.label,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ),
            // Radio / chevron
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.check, color: Colors.black, size: 12),
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                color: textSecondary,
                size: 20,
              ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 180 + index * 60), duration: 400.ms)
        .slideX(begin: 0.05, curve: Curves.easeOutCubic);
  }
}

// ─── Payment success dialog ───────────────────────────────────────────────────

class _PaymentSuccessDialog extends StatefulWidget {
  final double amount;
  final double newBalance;
  final bool isDark;

  const _PaymentSuccessDialog({
    required this.amount,
    required this.newBalance,
    required this.isDark,
  });

  @override
  State<_PaymentSuccessDialog> createState() => _PaymentSuccessDialogState();
}

class _PaymentSuccessDialogState extends State<_PaymentSuccessDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDark;
    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: AppRadius.xxlBorder,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Success icon
            ScaleTransition(
              scale: CurvedAnimation(
                parent: _ctrl,
                curve: Curves.elasticOut,
              ),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.15),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Payment Successful!',
              style: AppTypography.bodyLarge.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(height: 6.h),
            ShaderMask(
              shaderCallback: (Rect bounds) => const LinearGradient(
                colors: <Color>[AppColors.primary, AppColors.primaryLight],
              ).createShader(bounds),
              child: Text(
                '₹ ${widget.amount.toStringAsFixed(2)}',
                style: AppTypography.h3.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Added to your wallet',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 13.sp,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.textSecondaryLight,
              ),
            ),
            SizedBox(height: 20.h),
            // Current balance row
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
                borderRadius: AppRadius.mdBorder,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Current Balance',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 12.sp,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '₹ ${widget.newBalance.toStringAsFixed(2)}',
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.textSecondaryLight,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Back to Home
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.lgBorder,
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Back to Home',
                    style: AppTypography.bodyLarge.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutCubic),
    );
  }
}
