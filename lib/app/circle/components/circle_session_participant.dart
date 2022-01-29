import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:totem/app/circle/index.dart';
import 'package:totem/models/index.dart';
import 'package:totem/theme/index.dart';

class CircleSessionParticipant extends ConsumerWidget {
  const CircleSessionParticipant({Key? key, required this.participantId})
      : super(key: key);
  final String participantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participant = ref.watch(participantProvider(participantId));
    return GestureDetector(
      onTap: () {
        CircleSessionParticipantDialog.showDialog(
          context,
          participant: participant,
        );
      },
      child: Stack(
        children: [
          CircleParticipant(
              name: participant.name,
              role: participant.role,
              image: participant.sessionImage,
              me: participant.me),
          PositionedDirectional(
            top: 5,
            end: 5,
            child: _muteIndicator(context, participant),
          ),
        ],
      ),
    );
  }

  Widget _muteIndicator(BuildContext context, SessionParticipant participant) {
    final themeColors = Theme.of(context).themeColors;
    final bool muted = participant.muted;
    if (muted) {
      return Container(
        width: 32,
        height: 32,
        decoration: ShapeDecoration(
          color: muted ? themeColors.primaryText : themeColors.primary,
          shape: const CircleBorder(),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/microphone_mute.svg',
            color: themeColors.primary,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
    return Container();
  }
}
