import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class YgCard extends StatelessWidget {
  const YgCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).cardColor;
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.line),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: child,
    );

    if (onTap == null) return content;
    return InkWell(borderRadius: BorderRadius.circular(18), onTap: onTap, child: content);
  }
}
