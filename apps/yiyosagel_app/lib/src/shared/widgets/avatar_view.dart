import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class AvatarView extends StatelessWidget {
  const AvatarView({
    super.key,
    this.avatar = AppConstants.defaultGuestAvatar,
    this.photoUrl,
    this.size = 44,
    this.frameColor,
  });

  final String avatar;
  final String? photoUrl;
  final double size;
  final Color? frameColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.goldSoft,
        border: Border.all(color: frameColor ?? AppTheme.gold, width: frameColor == null ? 1 : 2.5),
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      child: photoUrl != null && photoUrl!.isNotEmpty
          ? Image.network(photoUrl!, width: size, height: size, fit: BoxFit.cover)
          : Text(avatar, style: TextStyle(fontSize: size * .48)),
    );
  }
}
