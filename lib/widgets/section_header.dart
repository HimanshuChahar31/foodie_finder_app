import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle = '',
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h3),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(subtitle, style: AppTextStyles.bodyMedium),
                  ),
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}
