import 'package:flutter/material.dart';

import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';

/// Charger details row widget showing charger type, connector type, and battery temperature.
class ChargerInfoRow extends StatelessWidget {

  final String chargerType;
  final String powerValue;
  final String connectorType;
  final String temperature;

  const ChargerInfoRow({super.key, required this.chargerType, required this.powerValue, required this.connectorType, required this.temperature});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.xs
      ),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: AppColors.border.withValues(
              alpha: 0.3
          )
        )
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _InfoItem(
              icon: Icons.flash_on_rounded,
              title: chargerType,
              subtitle: powerValue
            )
          ),
          _buildDivider(),
          Expanded(
            child: _InfoItem(
              icon: Icons.link_rounded,
              title: 'Connector',
              subtitle: connectorType
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _InfoItem(
              icon: Icons.thermostat_rounded,
              title: 'Battery Temp.',
              subtitle: temperature
            )
          )
        ]
      )
    );

  }

  Widget _buildDivider() {

    return Container(
      height: 36,
      width: 2.5,
      color: AppColors.border.withValues(
          alpha: 0.5
      )
    );

  }

}

class _InfoItem extends StatelessWidget {

  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoItem({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Icon badge
        Container(
          padding: const EdgeInsets.all(AppSpacing.xxs),
          decoration: const BoxDecoration(
            color: AppColors.surfaceDark,
            shape: BoxShape.circle
          ),
          child: Icon(
            icon,
            color: AppColors.textSecondary,
            size: 18
          )
        ),
        const SizedBox(
            width: AppSpacing.xxs + 2
        ),
        // Labels — FittedBox ensures full text always visible, never ellipsis
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 1
                )
              ),
              const SizedBox(
                  height: 2
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  subtitle,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                  maxLines: 1
                )
              )
            ]
          )
        )
      ]
    );

  }

}