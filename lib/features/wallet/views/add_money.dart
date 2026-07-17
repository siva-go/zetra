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

class AddMoney extends StatefulWidget {
  const AddMoney({super.key});

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> with SingleTickerProviderStateMixin {

  late final TextEditingController _amountController;
  late final FocusNode _amountFocus;
  late final AnimationController _shimmerController;

  @override
  void initState() {

    super.initState();

    _amountController = TextEditingController();
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

          final double amount = double.tryParse(state.enteredAmount) ?? 0.0;
          ctx.read<WalletBloc>().add(const PaymentResultReceived(true));
          ctx.push('/wallet/payment-status', extra: <String, dynamic>{
            'isSuccess': true,
            'amount': amount,
            'newBalance': state.balance,
          });

        } else if (state.status == WalletStatus.error &&
            state.errorMessage != 'Please enter a valid amount') {

          final double amount = double.tryParse(state.enteredAmount) ?? 0.0;
          ctx.read<WalletBloc>().add(const PaymentResultReceived(false));
          ctx.push('/wallet/payment-status', extra: <String, dynamic>{
            'isSuccess': false,
            'amount': amount,
            'newBalance': state.balance,
          });

        }

      },
      builder: (BuildContext ctx2, WalletState state) {

        final bool isPaying = state.status == WalletStatus.paying;

        return Scaffold(
          backgroundColor: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
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
                          _buildAmountCard(isDark, state),
                          if (state.errorMessage != null) ...<Widget>[
                            SizedBox(
                                height: 6.h
                            ),
                            _buildError(state.errorMessage!)
                          ],
                          SizedBox(
                              height: 20.h
                          ),
                          _buildPaymentMethodsCard(isDark, state),
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

  /// Single card that contains the amount label, ₹ input, and quick-amount chips.
  Widget _buildAmountCard(bool isDark, WalletState state) {

    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color labelColor = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: _amountFocus.hasFocus ? AppColors.primary : borderColor,
          width: _amountFocus.hasFocus ? 1.5 : 1
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: (isDark ? AppColors.blackColor : AppColors.textSecondaryLight).withValues(
                alpha: 0.06
            ),
            blurRadius: 12,
            offset: const Offset(0, 3)
          )
        ]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Label
            Text(
              'Enter Amount',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12.sp,
                color: labelColor,
                fontWeight: FontWeight.w500
              )
            ),
            SizedBox(
                height: 10.h
            ),
            // ₹ symbol + text field inline
            Row(
              children: <Widget>[
                Text(
                  '₹',
                  style: AppTypography.h3.copyWith(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w700,
                    color: textPrimary
                  )
                ),
                SizedBox(
                    width: 6.w
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
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w700,
                      color: textPrimary
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: '0',
                      hintStyle: AppTypography.h3.copyWith(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textHint : AppColors.textHintLight
                      ),
                      contentPadding: EdgeInsets.zero
                    )
                  )
                )
              ]
            ),
            SizedBox(
                height: 16.h
            ),
            // Quick-amount chips row
            _buildQuickAmountChips(isDark, state)
          ]
        )
      )
    ).animate().fadeIn(
      delay: 60.ms,
      duration: 400.ms
    ).slideY(
      begin: 0.04,
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
                right: 8.w
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
          onTap: () => _amountFocus.requestFocus()
        )
      ]
    );

  }

  Widget _buildSectionLabel(String text, bool isDark) {

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 18.w
      ),
      child: Text(
        text,
        style: AppTypography.bodyMedium.copyWith(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight
        )
      ).animate().fadeIn(
          delay: 150.ms,
          duration: 400.ms
      )
    );

  }

  /// Payment methods grouped inside a single rounded card with dividers.
  Widget _buildPaymentMethodsCard(bool isDark, WalletState state) {

    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color dividerColor = isDark ? AppColors.divider : AppColors.dividerLight;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
            color: borderColor
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: (isDark ? AppColors.blackColor : AppColors.textSecondaryLight).withValues(
                alpha: 0.06
            ),
            blurRadius: 12,
            offset: const Offset(0, 3)
          )
        ]
      ),
      child: ClipRRect(
        borderRadius: AppRadius.lgBorder,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                height: 20.h
            ),
            _buildSectionLabel('Choose Payment Method', isDark),
            SizedBox(
                height: 10.h
            ),
            ..._paymentMethods.asMap().entries.map((MapEntry<int, _PaymentMethod> entry) {

              final int idx = entry.key;
              final _PaymentMethod method = entry.value;
              final bool isSelected = state.selectedPaymentMethod == method.id;
              final bool isLast = idx == _paymentMethods.length - 1;

              return Column(
                  children: <Widget>[
                    _PaymentMethodTile(
                        method: method,
                        isSelected: isSelected,
                        isDark: isDark,
                        onTap: () {

                          HapticFeedback.selectionClick();
                          context.read<WalletBloc>().add(PaymentMethodSelected(method.id));

                        },
                        index: idx
                    ),
                    if (!isLast)
                      Divider(
                          height: 1,
                          thickness: 1,
                          color: dividerColor,
                          indent: 66.w,
                          endIndent: 0
                      )
                  ]
              );

            })
          ]
        )
      )
    ).animate().fadeIn(
        delay: 180.ms,
        duration: 400.ms
    ).slideY(
        begin: 0.04,
        curve: Curves.easeOutCubic
    );

  }

  Widget _buildAddMoneyButton(bool isDark, WalletState state, bool isPaying) {

    final double amount = double.tryParse(state.enteredAmount) ?? 0;
    final String label = amount > 0 ? 'Pay  ₹${amount.toStringAsFixed(0)}' : 'Pay';

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
                valueColor: AlwaysStoppedAnimation<Color?>(AppColors.blackColor)
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
        ) : Center(
          child: Text(
            label,
            style: AppTypography.bodyLarge.copyWith(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.whiteColor
            )
          )
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



}


class _QuickAmountChip extends StatelessWidget {

  final int amount;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _QuickAmountChip({required this.amount, required this.isSelected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {

    final Color chipBg = isSelected ? AppColors.primary : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);
    final Color borderColor = isSelected ? AppColors.primary : (isDark ? AppColors.border : AppColors.borderLight);
    final Color textColor = isSelected ? AppColors.whiteColor : (isDark ? AppColors.textPrimary : AppColors.textPrimaryLight);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
            milliseconds: 180
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 6.h
        ),
        decoration: BoxDecoration(
          color: chipBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
              color: borderColor
          )
        ),
        child: Text(
          '₹${_formatAmount(amount)}',
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: textColor
          )
        )
      )
    );

  }

  String _formatAmount(int v) {

    if (v >= 1000) {

      return '${(v / 1000).toStringAsFixed(v % 1000 == 0 ? 0 : 1)},000';

    }

    return v.toString();

  }

}

class _OtherChip extends StatelessWidget {

  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  const _OtherChip({required this.isDark, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {

    final Color chipBg = isSelected ? AppColors.primary : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);
    final Color borderColor = isSelected ? AppColors.primary : (isDark ? AppColors.border : AppColors.borderLight);
    final Color textColor = isSelected ? AppColors.whiteColor : (isDark ? AppColors.textPrimary : AppColors.textPrimaryLight);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
            milliseconds: 180
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 6.h
        ),
        decoration: BoxDecoration(
          color: chipBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
              color: borderColor
          )
        ),
        child: Text(
          'Other',
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: textColor
          )
        )
      )
    );

  }

}

class _PaymentMethodTile extends StatelessWidget {

  final _PaymentMethod method;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;
  final int index;

  const _PaymentMethodTile({required this.method, required this.isSelected, required this.isDark, required this.onTap, required this.index});

  @override
  Widget build(BuildContext context) {

    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Material(
      color: isSelected ? (isDark ? method.iconColor.withValues(
          alpha: 0.07
      ) : method.iconColor.withValues(
          alpha: 0.04
      )) : cardBg,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h
          ),
          child: Row(
            children: <Widget>[
              // Icon box
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: method.iconColor.withValues(
                      alpha: 0.12
                  ),
                  borderRadius: BorderRadius.circular(8.r)
                ),
                child: Icon(
                    method.icon,
                    color: method.iconColor,
                    size: 18
                )
              ),
              SizedBox(
                  width: 14.w
              ),
              // Label
              Expanded(
                child: Text(
                  method.label,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: textPrimary
                  )
                )
              ),
              // Trailing indicator
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
                color: isSelected ? AppColors.primary : textSecondary,
                size: 20
              )
            ]
          )
        )
      )
    );

  }

}