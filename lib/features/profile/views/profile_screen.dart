import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/app/themes/light/app_light_colors.dart';
import 'package:zetra/app/themes/light/app_light_shadows.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/core/storage/secure_storage.dart';
import 'package:zetra/core/widgets/bottom_nav_bar.dart';
import 'package:zetra/features/authentication/bloc/auth_bloc.dart';
import 'package:zetra/features/authentication/bloc/auth_event.dart';
import 'package:zetra/features/profile/bloc/profile_bloc.dart';
import 'package:zetra/features/profile/bloc/profile_event.dart';
import 'package:zetra/features/profile/bloc/profile_state.dart';
import 'package:zetra/features/profile/models/driver_vehicle_model.dart';
import 'package:zetra/features/profile/models/user_profile_model.dart';
import 'package:zetra/features/wallet/bloc/wallet_bloc.dart';
import 'package:zetra/features/wallet/bloc/wallet_event.dart';
import 'package:zetra/features/wallet/bloc/wallet_state.dart';

/// Theme-aware Profile screen supporting both Dark and Light modes.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(const WalletLoadRequested());
    context.read<ProfileBloc>().add(const ProfileLoadRequested());
  }

  Future<void> _onRefresh() async {
    context.read<WalletBloc>().add(const WalletLoadRequested());
    context.read<ProfileBloc>().add(const ProfileRefreshed());
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color blueNeon = Color(0xFF00E5FF);
    final Color accentColor = isDark ? blueNeon : const Color(0xFF5B4DFF);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            isDark ? AppColors.scaffoldDark : AppLightColors.scaffold,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : AppLightColors.scaffold,
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (BuildContext context, ProfileState state) {
            if (state.hasSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.successMessage!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFF10B981),
                  duration: const Duration(seconds: 2),
                ),
              );
              context.read<ProfileBloc>().add(const ProfileClearMessages());
            } else if (state.hasError && !state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFEF4444),
                  duration: const Duration(seconds: 3),
                ),
              );
              context.read<ProfileBloc>().add(const ProfileClearMessages());
            }
          },
          builder: (BuildContext context, ProfileState state) {
            final int vehicleCount = state.vehicles.length;

            return RefreshIndicator(
              color: accentColor,
              backgroundColor: isDark ? AppColors.cardDark : AppLightColors.card,
              onRefresh: _onRefresh,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // ── Profile Photo Header ──────────────────────────────────
                  _ProfileHeader(
                    blueNeon: blueNeon,
                    user: state.user,
                    isDark: isDark,
                  ),

                  // ── Wallet Balance Card ───────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      0,
                    ),
                    child: _WalletCard(
                      blueNeon: blueNeon,
                      isDark: isDark,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // ── Menu Options ─────────────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : AppLightColors.card,
                          borderRadius: AppRadius.lgBorder,
                          border: Border.all(
                            color: isDark
                                ? AppColors.border.withValues(alpha: 0.6)
                                : AppLightColors.border,
                          ),
                          boxShadow: isDark
                              ? <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : AppLightShadows.card,
                        ),
                        child: ClipRRect(
                          borderRadius: AppRadius.lgBorder,
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            children: <Widget>[
                              // My Vehicles
                              _MenuOptionItem(
                                icon: Icons.electric_car_rounded,
                                title: 'My Vehicles',
                                subtitle: vehicleCount > 0
                                    ? '$vehicleCount registered'
                                    : 'No vehicles added',
                                badgeText: vehicleCount > 0
                                    ? '$vehicleCount'
                                    : null,
                                neonColor: const Color(0xFF00E5FF),
                                isDark: isDark,
                                onTap: () => _showVehiclesSheet(
                                  context,
                                  state.vehicles,
                                  isDark,
                                ),
                              ),
                              _buildDivider(isDark),

                              _MenuOptionItem(
                                icon: Icons.credit_card_rounded,
                                title:
                                    AppLocalizations.of(context).paymentMethods,
                                neonColor: const Color(0xFF8B5CF6),
                                isDark: isDark,
                                onTap: () {},
                              ),
                              _buildDivider(isDark),

                              _MenuOptionItem(
                                icon: Icons.pin_drop_rounded,
                                title:
                                    AppLocalizations.of(context).savedStations,
                                neonColor: const Color(0xFF00FF66),
                                isDark: isDark,
                                onTap: () {},
                              ),
                              _buildDivider(isDark),

                              _MenuOptionItem(
                                icon: Icons.history_rounded,
                                title: AppLocalizations.of(context)
                                    .chargingHistory,
                                neonColor: const Color(0xFFFF7F00),
                                isDark: isDark,
                                onTap: () => context.push('/charging-history'),
                              ),
                              _buildDivider(isDark),

                              _MenuOptionItem(
                                icon: Icons.receipt_long_rounded,
                                title: AppLocalizations.of(context).invoice,
                                neonColor: const Color(0xFFFF2D55),
                                isDark: isDark,
                                onTap: () => context.push('/invoice'),
                              ),
                              _buildDivider(isDark),

                              _MenuOptionItem(
                                icon: Icons.settings_rounded,
                                title: AppLocalizations.of(context).settings,
                                neonColor: const Color(0xFFFFD600),
                                isDark: isDark,
                                onTap: () {},
                              ),
                              _buildDivider(isDark),

                              _MenuOptionItem(
                                icon: Icons.help_outline_rounded,
                                title: AppLocalizations.of(context).helpSupport,
                                neonColor: const Color(0xFF00FFCC),
                                isDark: isDark,
                                onTap: () {},
                              ),
                              _buildDivider(isDark),

                              _MenuOptionItem(
                                icon: Icons.logout_rounded,
                                title: 'Logout',
                                neonColor: const Color(0xFFFF3B30),
                                isDark: isDark,
                                onTap: () async {
                                  context
                                      .read<AuthBloc>()
                                      .add(LogoutRequested());
                                  await GetIt.instance<SecureStorage>()
                                      .clearTokens();
                                  if (context.mounted) {
                                    context.go('/login');
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // ── Bottom Nav ──────────────────────────────────────────
                  const ZetraBottomNavBar(currentIndex: 2),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Divider(
        color: isDark ? AppColors.divider : AppLightColors.divider,
        height: 1,
      ),
    );
  }

  void _showVehiclesSheet(
    BuildContext context,
    List<DriverVehicleModel> vehicles,
    bool isDark,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) => _VehiclesBottomSheet(
        vehicles: vehicles,
        isDark: isDark,
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Profile Header
// ────────────────────────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final Color blueNeon;
  final UserProfileModel? user;
  final bool isDark;

  const _ProfileHeader({
    required this.blueNeon,
    this.user,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final double headerHeight =
        (MediaQuery.of(context).size.height * 0.28).clamp(160.0, 220.0);

    final String displayName = user?.displayName ?? 'Driver';
    final String contactInfo = (user?.email != null && user!.email!.isNotEmpty)
        ? user!.email!
        : (user?.phone ?? 'ZETRA EV Driver');
    final String initials = user?.initials ?? 'Z';
    final Color badgeGlow = isDark ? blueNeon : const Color(0xFF7C3AED);
    final Color badgeText = isDark ? blueNeon : const Color(0xFF6D28D9);

    return Stack(
      children: <Widget>[
        Container(
          height: headerHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/profile.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? <Color>[
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.2),
                        AppColors.scaffoldDark.withValues(alpha: 0.75),
                        AppColors.scaffoldDark,
                      ]
                    : <Color>[
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.05),
                        AppLightColors.scaffold.withValues(alpha: 0.8),
                        AppLightColors.scaffold,
                      ],
                stops: const <double>[0, 0.4, 0.85, 1],
              ),
            ),
          ),
        ),

        // User Info & Edit Button
        Positioned(
          bottom: AppSpacing.xs,
          left: AppSpacing.md,
          right: AppSpacing.md,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            'Hi, $displayName! 👋',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelLarge.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppLightColors.textPrimary,
                              shadows: isDark
                                  ? const <Shadow>[
                                      Shadow(
                                        color: Colors.black87,
                                        offset: Offset(0, 1.5),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: (isDark ? blueNeon : const Color(0xFF5B4DFF))
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: (isDark ? blueNeon : const Color(0xFF5B4DFF))
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            user?.role ?? 'DRIVER',
                            style: TextStyle(
                              color: isDark ? blueNeon : const Color(0xFF5B4DFF),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contactInfo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondary.withValues(alpha: 0.95)
                            : AppLightColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Edit Profile Button
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _showEditProfileSheet(context, user, isDark),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? blueNeon.withValues(alpha: 0.15)
                        : AppLightColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? blueNeon.withValues(alpha: 0.5)
                          : AppLightColors.border,
                      width: 1.2,
                    ),
                    boxShadow: isDark
                        ? <BoxShadow>[
                            BoxShadow(
                              color: blueNeon.withValues(alpha: 0.2),
                              blurRadius: 8,
                            ),
                          ]
                        : AppLightShadows.card,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.edit_rounded,
                        color: isDark ? blueNeon : AppLightColors.textPrimary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: isDark ? blueNeon : AppLightColors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Top Left Hexagon Badge with Initials
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.md,
          child: CustomPaint(
            painter: HexagonPainter(glowColor: badgeGlow, isDark: isDark),
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: Text(
                initials,
                style: TextStyle(
                  color: badgeText,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  shadows: isDark
                      ? <Shadow>[
                          Shadow(
                            color: blueNeon.withValues(alpha: 0.6),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEditProfileSheet(
    BuildContext context,
    UserProfileModel? user,
    bool isDark,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) => _EditProfileBottomSheet(
        user: user,
        isDark: isDark,
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Edit Profile Bottom Sheet using BlocConsumer
// ────────────────────────────────────────────────────────────────────────────
class _EditProfileBottomSheet extends StatefulWidget {
  final UserProfileModel? user;
  final bool isDark;

  const _EditProfileBottomSheet({
    this.user,
    required this.isDark,
  });

  @override
  State<_EditProfileBottomSheet> createState() =>
      _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<_EditProfileBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.fullName ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String name = _nameController.text.trim();
    final String phone = _phoneController.text.trim();

    context.read<ProfileBloc>().add(
          ProfileUpdateRequested(
            fullName: name.isNotEmpty ? name : null,
            phone: phone.isNotEmpty ? phone : null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDark;
    const Color blueNeon = Color(0xFF00E5FF);
    final Color accentColor = isDark ? blueNeon : const Color(0xFF5B4DFF);
    final EdgeInsets insets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: insets,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (BuildContext context, ProfileState state) {
          if (state.hasSuccess) {
            Navigator.of(context).pop();
          }
        },
        builder: (BuildContext context, ProfileState state) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.scaffoldDark : AppLightColors.card,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(
                color: isDark
                    ? AppColors.border.withValues(alpha: 0.6)
                    : AppLightColors.border,
              ),
              boxShadow: isDark
                  ? <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.6),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ]
                  : <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Sheet Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : AppLightColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Title
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.person_rounded,
                        color: accentColor,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Edit Profile',
                        style: AppTypography.labelLarge.copyWith(
                          color:
                              isDark ? Colors.white : AppLightColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Full Name field
                  Text(
                    'Full Name',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppLightColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(
                      color:
                          isDark ? Colors.white : AppLightColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.white38
                            : AppLightColors.textTertiary,
                      ),
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: accentColor,
                        size: 20,
                      ),
                      filled: true,
                      fillColor:
                          isDark ? AppColors.cardDark : AppLightColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.border.withValues(alpha: 0.6)
                              : AppLightColors.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.border.withValues(alpha: 0.6)
                              : AppLightColors.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: accentColor, width: 1.5),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Full name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Phone Number field
                  Text(
                    'Phone Number',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppLightColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneController,
                    style: TextStyle(
                      color:
                          isDark ? Colors.white : AppLightColors.textPrimary,
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'e.g. +919876543210',
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.white38
                            : AppLightColors.textTertiary,
                      ),
                      prefixIcon: Icon(
                        Icons.phone_rounded,
                        color: accentColor,
                        size: 20,
                      ),
                      filled: true,
                      fillColor:
                          isDark ? AppColors.cardDark : AppLightColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.border.withValues(alpha: 0.6)
                              : AppLightColors.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.border.withValues(alpha: 0.6)
                              : AppLightColors.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: accentColor, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Save Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 6,
                      shadowColor: accentColor.withValues(alpha: 0.5),
                    ),
                    onPressed: state.isUpdating ? null : () => _save(context),
                    child: state.isUpdating
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Vehicles Bottom Sheet
// ────────────────────────────────────────────────────────────────────────────
class _VehiclesBottomSheet extends StatelessWidget {
  final List<DriverVehicleModel> vehicles;
  final bool isDark;

  const _VehiclesBottomSheet({
    required this.vehicles,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    const Color blueNeon = Color(0xFF00E5FF);
    final Color accentColor = isDark ? blueNeon : const Color(0xFF5B4DFF);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.scaffoldDark : AppLightColors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: isDark
              ? AppColors.border.withValues(alpha: 0.6)
              : AppLightColors.border,
        ),
        boxShadow: isDark
            ? <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ]
            : <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Sheet Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : AppLightColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          Row(
            children: <Widget>[
              Icon(
                Icons.electric_car_rounded,
                color: accentColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'My Registered Vehicles',
                style: AppTypography.labelLarge.copyWith(
                  color: isDark ? Colors.white : AppLightColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          if (vehicles.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.no_crash_rounded,
                    color: isDark
                        ? AppColors.textSecondary.withValues(alpha: 0.5)
                        : AppLightColors.textTertiary,
                    size: 48,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No vehicles registered yet',
                    style: AppTypography.bodyMedium.copyWith(
                      color:
                          isDark ? Colors.white70 : AppLightColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Vehicles linked to your driver profile will appear here.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppLightColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vehicles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (BuildContext context, int index) {
                final DriverVehicleModel vehicle = vehicles[index];
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.cardDark : AppLightColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: vehicle.isActive
                          ? (isDark
                              ? blueNeon.withValues(alpha: 0.3)
                              : AppLightColors.primary.withValues(alpha: 0.4))
                          : (isDark
                              ? AppColors.border.withValues(alpha: 0.4)
                              : AppLightColors.border),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (isDark ? blueNeon : const Color(0xFF5B4DFF))
                              .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.electric_car_rounded,
                          color: isDark ? blueNeon : const Color(0xFF5B4DFF),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              vehicle.displayTitle,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : AppLightColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              vehicle.vehicleNumber,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppLightColors.textSecondary,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: vehicle.isActive
                              ? (isDark
                                  ? const Color(0xFF00FF66)
                                      .withValues(alpha: 0.15)
                                  : AppLightColors.primaryLight)
                              : (isDark
                                  ? Colors.white10
                                  : AppLightColors.elevated),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          vehicle.status,
                          style: TextStyle(
                            color: vehicle.isActive
                                ? (isDark
                                    ? const Color(0xFF00FF66)
                                    : AppLightColors.primary)
                                : (isDark
                                    ? Colors.white60
                                    : AppLightColors.textTertiary),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Wallet Balance Card
// ────────────────────────────────────────────────────────────────────────────
class _WalletCard extends StatelessWidget {
  final Color blueNeon;
  final bool isDark;

  const _WalletCard({
    required this.blueNeon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (BuildContext context, WalletState state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (BuildContext context, WalletState state) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppLightColors.card,
            borderRadius: AppRadius.lgBorder,
            border: Border.all(
              color: isDark
                  ? AppColors.border.withValues(alpha: 0.6)
                  : AppLightColors.border,
            ),
            boxShadow: isDark
                ? <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : AppLightShadows.card,
          ),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).walletBalance,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppLightColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹ ${state.balance.toStringAsFixed(2)}',
                    style: AppTypography.labelLarge.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppLightColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? blueNeon.withValues(alpha: 0.15)
                      : const Color(0xFF5B4DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: isDark
                        ? BorderSide(color: blueNeon, width: 1.5)
                        : BorderSide.none,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  elevation: isDark ? 6 : 2,
                  shadowColor: isDark
                      ? blueNeon.withValues(alpha: 0.3)
                      : const Color(0xFF5B4DFF).withValues(alpha: 0.4),
                ),
                onPressed: () {
                  context.push('/wallet/add-money');
                },
                child: Text(
                  '+ ${AppLocalizations.of(context).addMoney}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                    shadows: isDark
                        ? <Shadow>[Shadow(color: blueNeon, blurRadius: 4)]
                        : null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Menu Option Item
// ────────────────────────────────────────────────────────────────────────────
class _MenuOptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? badgeText;
  final Color neonColor;
  final bool isDark;
  final VoidCallback onTap;

  const _MenuOptionItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.badgeText,
    required this.neonColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 4,
        ),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark
                ? neonColor.withValues(alpha: 0.12)
                : AppLightColors.surface,
            shape: BoxShape.circle,
            border: isDark
                ? Border.all(
                    color: neonColor.withValues(alpha: 0.3),
                    width: 1.5,
                  )
                : Border.all(
                    color: AppLightColors.border,
                  ),
            boxShadow: isDark
                ? <BoxShadow>[
                    BoxShadow(
                      color: neonColor.withValues(alpha: 0.25),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: isDark ? neonColor : AppLightColors.textSecondary,
            size: 18,
          ),
        ),
        title: Text(
          title,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? Colors.white : AppLightColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondary.withValues(alpha: 0.8)
                      : AppLightColors.textSecondary,
                  fontSize: 11,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (badgeText != null)
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: (isDark ? neonColor : AppLightColors.primary)
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (isDark ? neonColor : AppLightColors.primary)
                        .withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    color: isDark ? neonColor : AppLightColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark
                  ? AppColors.textSecondary
                  : AppLightColors.textTertiary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Hexagon Badge Painter
// ────────────────────────────────────────────────────────────────────────────
class HexagonPainter extends CustomPainter {
  final Color glowColor;
  final double strokeWidth;
  final bool isDark;

  HexagonPainter({
    required this.glowColor,
    this.strokeWidth = 2.0,
    this.isDark = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double padding = 6.0 + strokeWidth;
    final double radius = (math.min(w, h) / 2) - padding;

    final Path path = Path();
    for (int i = 0; i < 6; i++) {
      final double angle = -math.pi / 2 + (i * math.pi / 3);
      final double x = cx + radius * math.cos(angle);
      final double y = cy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    if (isDark) {
      canvas.drawPath(
        path,
        Paint()
          ..color = glowColor.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 8.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      canvas.drawPath(
        path,
        Paint()
          ..color = glowColor.withValues(alpha: 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 3.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    } else {
      canvas.drawPath(
        path,
        Paint()
          ..color = glowColor.withValues(alpha: 0.08)
          ..style = PaintingStyle.fill,
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = glowColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(covariant HexagonPainter old) =>
      old.glowColor != glowColor ||
      old.strokeWidth != strokeWidth ||
      old.isDark != isDark;
}
