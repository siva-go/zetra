import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/widgets/bottom_nav_bar.dart';
import 'package:zetra/features/station/bloc/scan_qr_bloc.dart';
import 'package:zetra/features/station/bloc/scan_qr_event.dart';
import 'package:zetra/features/station/bloc/scan_qr_state.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> with SingleTickerProviderStateMixin {

  late final MobileScannerController _scannerController;
  late final AnimationController _laserController;

  @override
  void initState() {

    super.initState();

    context.read<ScanQrBloc>().add(const ScanQrInitialized());

    _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates
    );

    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 2000
      ),
    )..repeat(
        reverse: true
    );

  }

  @override
  void dispose() {

    _scannerController.dispose();
    _laserController.dispose();
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

    return BlocConsumer<ScanQrBloc, ScanQrState>(
        listener: (BuildContext context, ScanQrState state) {

          if (state.status == ScanQrStatus.success) {

            HapticFeedback.heavyImpact();

            context.pop();

          }

        },
        builder: (BuildContext context, ScanQrState state) {

          return Scaffold(
              backgroundColor: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
              body: Column(
                  children: <Widget>[
                    _buildTopBar(isDark, state),
                    Expanded(
                        child: Center(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 14.w
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.w,
                                          vertical: 50.h
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
                                        borderRadius: AppRadius.lgBorder,
                                        border: Border.all(
                                          color: isDark ? AppColors.border : AppColors.borderLight
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: isDark ? Colors.black.withValues(
                                                alpha: 0.3
                                            ) : Colors.black.withValues(
                                                alpha: 0.05
                                            ),
                                            blurRadius: 16,
                                            offset: const Offset(0, 8)
                                          )
                                        ]
                                      ),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            SizedBox(
                                                width: 250.w,
                                                height: 250.h,
                                                child: Stack(
                                                    children: <Widget>[
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(4),
                                                        child: MobileScanner(
                                                          controller: _scannerController,
                                                          onDetect: (BarcodeCapture capture) {

                                                            final List<Barcode> barcodes = capture.barcodes;

                                                            if (barcodes.isNotEmpty) {

                                                              final String? code = barcodes.first.rawValue;

                                                              if (code != null) {

                                                                context.read<ScanQrBloc>().add(
                                                                    QrCodeDetected(code)
                                                                );

                                                              }

                                                            }

                                                          }
                                                        )
                                                      ),
                                                      _buildNeonCorners(isDark),
                                                      _buildLaserLine()
                                                    ]
                                                )
                                            ),
                                            SizedBox(
                                                height: 32.h
                                            ),
                                            Text(
                                              'Align QR code within the frame',
                                              style: AppTypography.bodyLarge.copyWith(
                                                  color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                                                  fontWeight: FontWeight.w500
                                              )
                                            ).animate().fadeIn(
                                                duration: 500.ms,
                                                delay: 300.ms
                                            )
                                          ]
                                      )
                                  ),
                                  SizedBox(
                                      height: 32.h
                                  ),
                                  _buildManualIdButton(isDark)
                                ]
                            )
                        )
                    ),
                    const ZetraBottomNavBar(
                        currentIndex: 1,
                        // onTap: (int idx) {
                        //
                        //   if (idx == 0) {
                        //
                        //     context.go('/home');
                        //
                        //   } else if (idx == 3) {
                        //
                        //     // Profile etc.
                        //
                        //   }
                        //
                        // }
                    )
                  ]
              )
          );

        }

    );

  }

  Widget _buildTopBar(bool isDark, ScanQrState state) {

    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;

    return SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: textPrimary,
                          size: 20
                      )
                  ),
                  Text(
                      'Scan QR Code',
                      style: AppTypography.bodyLarge.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: textPrimary
                      )
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                          Icons.filter_center_focus_outlined,
                          color: textPrimary,
                          size: 24
                      )
                  )
                ]
            )
        ).animate().fadeIn(
            duration: 400.ms
        ).slideY(
            begin: -0.1
        )
    );

  }

  Widget _buildNeonCorners(bool isDark) {

    const Color neonColor = AppColors.primary;

    return Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: _buildCorner(neonColor,
                  top: true,
                  left: true
              )
          ),
          Positioned(
              top: 0,
              right: 0,
              child: _buildCorner(neonColor,
                  top: true,
                  left: false
              )
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: _buildCorner(neonColor,
                  top: false,
                  left: true
              )
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: _buildCorner(neonColor,
                  top: false,
                  left: false
              )
          )
        ]
    ).animate().fadeIn(
        duration: 600.ms,
        delay: 200.ms
    );
  }

  Widget _buildCorner(Color color, {required bool top, required bool left}) {

    return Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
            border: Border(
                top: top ? BorderSide(
                    color: color,
                    width: 3
                ) : BorderSide.none,
                bottom: !top ? BorderSide(
                    color: color,
                    width: 3
                ) : BorderSide.none,
                left: left ? BorderSide(
                    color: color,
                    width: 3
                ) : BorderSide.none,
                right: !left ? BorderSide(
                    color: color,
                    width: 3
                ) : BorderSide.none
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: color.withValues(
                      alpha: 0.5
                  ),
                  blurRadius: 12,
                  spreadRadius: 1
              )
            ]
        )
    );

  }

  Widget _buildLaserLine() {

    return AnimatedBuilder(
        animation: _laserController,
        builder: (BuildContext context, Widget? child) {

          return Positioned(
              top: _laserController.value * (250.h - 4),
              left: 10.w,
              right: 10.w,
              child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppColors.primary.withValues(
                                alpha: 0.8
                            ),
                            blurRadius: 10,
                            spreadRadius: 2
                        )
                      ]
                  )
              )
          );

        }

    );

  }

  Widget _buildManualIdButton(bool isDark) {

    return GestureDetector(
        onTap: () {

          HapticFeedback.selectionClick();
          context.read<ScanQrBloc>().add(const EnterManualIdTapped());

        },
        child: Container(
          width: MediaQuery.sizeOf(context).width / 1.1,
            padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h
            ),
            decoration: BoxDecoration(
                color: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isDark ? AppColors.border : AppColors.borderLight
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: isDark ? Colors.black.withValues(
                          alpha: 0.3
                      ) : Colors.black.withValues(
                          alpha: 0.05
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 4)
                  )
                ]
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                      Icons.badge_outlined,
                      color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                      size: 20
                  ),
                  SizedBox(
                    width: 13.w
                  ),
                  Text(
                      'Enter Station ID Manually',
                      style: AppTypography.bodyLarge.copyWith(
                          color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600
                      )
                  ),
                  const Spacer(),
                  Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                      size: 22
                  )
                ]
            )
        )
    ).animate().fadeIn(
        duration: 500.ms,
        delay: 400.ms
    ).slideY(
        begin: 0.2
    );

  }

}