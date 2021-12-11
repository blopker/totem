import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:totem/models/index.dart';
import 'package:totem/services/index.dart';
import 'package:totem/theme/index.dart';

class RectProfileImage extends ConsumerWidget {
  const RectProfileImage({
    Key? key,
    this.size = 64,
    this.fillColor,
    this.textColor,
    this.textSize = 30,
    this.useIcon = true,
  }) : super(key: key);
  final double size;
  final Color? fillColor;
  final Color? textColor;
  final double textSize;
  final bool useIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileChanges = ref.watch(TotemRepository.userProfileProvider);
    return SizedBox(
      width: size,
      height: size,
      child: userProfileChanges.when(
        data: (userProfile) => _component(context, userProfile),
        loading: () => _userPlaceholder(context),
        error: (_, __) => _userPlaceholder(context),
      ),
    );
  }

  Widget _component(BuildContext context, UserProfile? userProfile) {
    return SizedBox(
        width: size,
        height: size,
        child: userProfile != null
            ? (!userProfile.hasImage
                ? _userPlaceholder(context, userProfile: userProfile)
                : CachedNetworkImage(
                    imageUrl: userProfile.image!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(size / 4)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        _userPlaceholder(context, userProfile: userProfile),
                  ))
            : Container());
  }

  Widget _userPlaceholder(BuildContext context, {UserProfile? userProfile}) {
    final themeColors = Theme.of(context).themeColors;
    return Container(
      decoration: BoxDecoration(
        color: fillColor ?? themeColors.profileBackground,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(size / 4)),
      ),
      child: useIcon
          ? Center(
              child: SvgPicture.asset('assets/profile.svg'),
            )
          : Text(
              userProfile?.userInitials ?? "",
              style: TextStyle(
                  color: textColor ?? themeColors.primaryText,
                  fontSize: textSize,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
    );
  }
}