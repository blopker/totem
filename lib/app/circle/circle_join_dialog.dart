import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:totem/components/camera/camera_capture_component.dart';
import 'package:totem/components/widgets/index.dart';
import 'package:totem/models/index.dart';
import 'package:totem/services/providers.dart';
import 'package:totem/services/utils/device_type.dart';
import 'package:totem/theme/index.dart';

class CircleJoinDialog extends ConsumerStatefulWidget {
  const CircleJoinDialog(
      {Key? key, required this.circle, this.cropEnabled = false})
      : super(key: key);
  final Circle circle;
  final bool cropEnabled;

  static Future<Map<String, bool>?> showDialog(BuildContext context,
      {required Circle circle}) async {
    return showModalBottomSheet<Map<String, bool>?>(
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Theme.of(context).themeColors.blurBackground,
      builder: (_) => CircleJoinDialog(
        circle: circle,
      ),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CircleJoinDialogState();
}

class _CircleJoinDialogState extends ConsumerState<CircleJoinDialog> {
  late Future<UserProfile?> _userProfileFetch;
  final GlobalKey<CameraCaptureScreenState> _captureKey =
      GlobalKey<CameraCaptureScreenState>();

  @override
  void initState() {
    _userProfileFetch = ref.read(repositoryProvider).userProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).themeColors;
    final textStyles = Theme.of(context).textStyles;
    return (DeviceType.isPhone())
        ? BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
            child: SafeArea(
              top: true,
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                ),
                child: BottomTrayContainer(
                  fullScreen: true,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Container()),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              color: themeColors.primaryText,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraint) {
                            return SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      Theme.of(context).pageHorizontalPadding),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: constraint.maxHeight),
                                child: IntrinsicHeight(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        widget.circle.name,
                                        style: textStyles.dialogTitle,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 24),
                                      Divider(
                                        thickness: 1,
                                        height: 1,
                                        color: themeColors.divider,
                                      ),
                                      const SizedBox(height: 24),
                                      Expanded(child: _userInfo(context)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: DialogContainer(
                  padding: const EdgeInsets.only(
                      top: 50, bottom: 80, left: 40, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              widget.circle.name,
                              style: textStyles.headline1!.merge(
                                  const TextStyle(fontWeight: FontWeight.w400)),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                child: SvgPicture.asset('assets/close.svg'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const ContentDivider(),
                      const SizedBox(height: 24),
                      Center(
                        child: _desktopUserInfo(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _userInfo(BuildContext context) {
    final textStyles = Theme.of(context).textStyles;
    final themeColors = Theme.of(context).themeColors;
    final t = AppLocalizations.of(context)!;

    return FutureBuilder<UserProfile?>(
      future: _userProfileFetch,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: BusyIndicator(),
          );
        }
        if (asyncSnapshot.hasData) {
          UserProfile user = asyncSnapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                user.name,
                style: textStyles.headline3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                t.helpSessionProfileImage,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: Theme.of(context).maxRenderWidth),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                        child: Container(
                          color: themeColors.primaryText,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: CameraCapture(
                              key: _captureKey,
                              captureMode: CaptureMode.preview,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ThemedRaisedButton(
                        onPressed: () {
                          _join();
                        },
                        label: t.joinCircle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _desktopUserInfo(BuildContext context) {
    final themeColors = Theme.of(context).themeColors;
    final t = AppLocalizations.of(context)!;

    return FutureBuilder<UserProfile?>(
      future: _userProfileFetch,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: BusyIndicator(),
          );
        }
        if (asyncSnapshot.hasData) {
          // UserProfile user = asyncSnapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Text(
                  t.joinCircleMessage,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: Theme.of(context).maxRenderWidth,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24)),
                          child: Container(
                            color: themeColors.primaryText,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: CameraCapture(
                                key: _captureKey,
                                captureMode: CaptureMode.preview,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: Theme.of(context).maxRenderWidth,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Center(
                            child: ThemedRaisedButton(
                              onPressed: () {
                                _join();
                              },
                              label: t.joinCircle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  void _join() {
    Navigator.of(context).pop({
      'muted': _captureKey.currentState!.muted,
      'videoMuted': _captureKey.currentState!.videoMuted
    });
  }
}
