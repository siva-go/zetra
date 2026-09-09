import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
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

/// Dark-themed Profile screen using BlocConsumer.
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
    const Color blueNeon = Color(0xFF00E5FF);

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
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
              color: blueNeon,
              backgroundColor: AppColors.cardDark,
              onRefresh: _onRefresh,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // ── Profile Photo Header ──────────────────────────────────
                  _ProfileHeader(
                    blueNeon: blueNeon,
                    user: state.user,
                  ),

                  // ── Wallet Balance Card ───────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      0,
                    ),
                    child: _WalletCard(blueNeon: blueNeon),
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
                          color: AppColors.cardDark,
                          borderRadius: AppRadius.lgBorder,
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.6),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
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
                                onTap: () => _showVehiclesSheet(
                                  context,
                                  state.vehicles,
                                ),
                              ),
                              _buildDivider(),

                              _MenuOptionItem(
                                icon: Icons.credit_card_rounded,
                                title:
                                    AppLocalizations.of(context).paymentMethods,
                                neonColor: const Color(0xFF8B5CF6),
                                onTap: () {},
                              ),
                              _buildDivider(),

                              _MenuOptionItem(
                                icon: Icons.pin_drop_rounded,
                                title:
                                    AppLocalizations.of(context).savedStations,
                                neonColor: const Color(0xFF00FF66),
                                onTap: () {},
                              ),
                              _buildDivider(),

                              _MenuOptionItem(
                                icon: Icons.history_rounded,
                                title: AppLocalizations.of(context)
                                    .chargingHistory,
                                neonColor: const Color(0xFFFF7F00),
                                onTap: () => context.push('/charging-history'),
                              ),
                              _buildDivider(),

                              _MenuOptionItem(
                                icon: Icons.receipt_long_rounded,
                                title: AppLocalizations.of(context).invoice,
                                neonColor: const Color(0xFFFF2D55),
                                onTap: () => context.push('/invoice'),
                              ),
                              _buildDivider(),

                              _MenuOptionItem(
                                icon: Icons.settings_rounded,
                                title: AppLocalizations.of(context).settings,
                                neonColor: const Color(0xFFFFD600),
                                onTap: () {},
                              ),
                              _buildDivider(),

                              _MenuOptionItem(
                                icon: Icons.help_outline_rounded,
                                title: AppLocalizations.of(context).helpSupport,
                                neonColor: const Color(0xFF00FFCC),
                                onTap: () {},
                              ),
                              _buildDivider(),

                              _MenuOptionItem(
                                icon: Icons.logout_rounded,
                                title: 'Logout',
                                neonColor: const Color(0xFFFF3B30),
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
                  const ZetraBottomNavBar(currentIndex: 3),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Divider(color: AppColors.divider, height: 1),
    );
  }

  void _showVehiclesSheet(
    BuildContext context,
    List<DriverVehicleModel> vehicles,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) => _VehiclesBottomSheet(vehicles: vehicles),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Profile Header
// ────────────────────────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final Color blueNeon;
  final UserProfileModel? user;

  const _ProfileHeader({
    required this.blueNeon,
    this.user,
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
                colors: <Color>[
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.2),
                  AppColors.scaffoldDark.withValues(alpha: 0.75),
                  AppColors.scaffoldDark,
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
                              color: Colors.white,
                              shadows: const <Shadow>[
                                Shadow(
                                  color: Colors.black87,
                                  offset: Offset(0, 1.5),
                                  blurRadius: 4,
                                ),
                              ],
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
                            color: blueNeon.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: blueNeon.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            user?.role ?? 'DRIVER',
                            style: TextStyle(
                              color: blueNeon,
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
                        color: AppColors.textSecondary.withValues(alpha: 0.95),
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
                onTap: () => _showEditProfileSheet(context, user),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: blueNeon.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: blueNeon.withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: blueNeon.withValues(alpha: 0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.edit_rounded, color: blueNeon, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: blueNeon,
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
            painter: HexagonPainter(glowColor: blueNeon),
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: Text(
                initials,
                style: TextStyle(
                  color: blueNeon,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  shadows: <Shadow>[
                    Shadow(
                      color: blueNeon.withValues(alpha: 0.6),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEditProfileSheet(BuildContext context, UserProfileModel? user) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) => _EditProfileBottomSheet(user: user),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Edit Profile Bottom Sheet using BlocConsumer
// ────────────────────────────────────────────────────────────────────────────
class _EditProfileBottomSheet extends StatefulWidget {
  final UserProfileModel? user;
  const _EditProfileBottomSheet({this.user});

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
    const Color blueNeon = Color(0xFF00E5FF);
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
              color: AppColors.scaffoldDark,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.6),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
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
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Title
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.person_rounded,
                        color: blueNeon,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Edit Profile',
                        style: AppTypography.labelLarge.copyWith(
                          color: Colors.white,
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
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(
                        Icons.badge_outlined,
                        color: blueNeon,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: AppColors.cardDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.border.withValues(alpha: 0.6),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.border.withValues(alpha: 0.6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: blueNeon, width: 1.5),
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
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'e.g. +919876543210',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(
                        Icons.phone_rounded,
                        color: blueNeon,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: AppColors.cardDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.border.withValues(alpha: 0.6),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.border.withValues(alpha: 0.6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: blueNeon, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Save Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueNeon,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 6,
                      shadowColor: blueNeon.withValues(alpha: 0.5),
                    ),
                    onPressed: state.isUpdating ? null : () => _save(context),
                    child: state.isUpdating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
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
  const _VehiclesBottomSheet({required this.vehicles});

  @override
  Widget build(BuildContext context) {
    const Color blueNeon = Color(0xFF00E5FF);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.6),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
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
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          Row(
            children: <Widget>[
              const Icon(Icons.electric_car_rounded, color: blueNeon, size: 24),
              const SizedBox(width: 8),
              Text(
                'My Registered Vehicles',
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white,
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
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                    size: 48,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No vehicles registered yet',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Vehicles linked to your driver profile will appear here.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
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
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: vehicle.isActive
                          ? blueNeon.withValues(alpha: 0.3)
                          : AppColors.border.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: blueNeon.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.electric_car_rounded,
                          color: blueNeon,
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              vehicle.vehicleNumber,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
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
                              ? const Color(0xFF00FF66).withValues(alpha: 0.15)
                              : Colors.white10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          vehicle.status,
                          style: TextStyle(
                            color: vehicle.isActive
                                ? const Color(0xFF00FF66)
                                : Colors.white60,
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
  const _WalletCard({required this.blueNeon});

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
            color: AppColors.cardDark,
            borderRadius: AppRadius.lgBorder,
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.6),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).walletBalance,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
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
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueNeon.withValues(alpha: 0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: blueNeon, width: 1.5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  elevation: 6,
                  shadowColor: blueNeon.withValues(alpha: 0.3),
                ),
                onPressed: () {
                  context.push('/wallet/add-money');
                },
                child: Text(
                  AppLocalizations.of(context).addMoney,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                    shadows: <Shadow>[Shadow(color: blueNeon, blurRadius: 4)],
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
  final VoidCallback onTap;

  const _MenuOptionItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.badgeText,
    required this.neonColor,
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
            color: neonColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: neonColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: neonColor.withValues(alpha: 0.25),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(icon, color: neonColor, size: 18),
        ),
        title: Text(
          title,
          style: AppTypography.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
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
                  color: neonColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: neonColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    color: neonColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
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

  HexagonPainter({required this.glowColor, this.strokeWidth = 2.0});

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
      old.glowColor != glowColor || old.strokeWidth != strokeWidth;
}
