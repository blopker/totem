import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:totem/app/circle/components/index.dart';
import 'package:totem/models/index.dart';
import 'package:totem/theme/index.dart';

import '../circle_session_page.dart';

class CircleSessionParticipant extends ConsumerWidget {
  const CircleSessionParticipant({Key? key, required this.participantId})
      : super(key: key);
  final String participantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participant = ref.watch(participantProvider(participantId));
    return Stack(
      children: [
        CircleParticipant(
            name: participant.name,
            role: participant.role,
            image: participant.sessionImage,
            me: participant.me),
        PositionedDirectional(
          top: 5,
          end: 5,
          child: _muteButton(context, participant),
        ),
      ],
    );
  }

  Widget _muteButton(BuildContext context, SessionParticipant participant) {
    final themeColors = Theme.of(context).themeColors;
    final bool muted = participant.muted;
    return Container(
      width: 32,
      height: 32,
      decoration: ShapeDecoration(
        color: muted ? themeColors.primaryText : themeColors.primary,
        shape: const CircleBorder(),
      ),
      child: Center(
        child: SvgPicture.asset(
          participant.muted
              ? 'assets/microphone_mute.svg'
              : 'assets/microphone.svg',
          color: muted ? themeColors.primary : themeColors.primaryText,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
