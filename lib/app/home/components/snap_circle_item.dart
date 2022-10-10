import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:totem/components/widgets/index.dart';
import 'package:totem/models/index.dart';
import 'package:totem/theme/index.dart';

class SnapCircleItem extends StatelessWidget {
  const SnapCircleItem({
    Key? key,
    required this.circle,
    required this.onPressed,
  }) : super(key: key);
  final SnapCircle circle;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textStyles = themeData.textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 8.0, horizontal: themeData.pageHorizontalPadding),
      child: InkWell(
        hoverColor: Colors.transparent,
        onTap: () {
          onPressed(circle);
        },
        child: ListItemContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CircleImage(
                  circle: circle,
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            circle.name,
                            style: textStyles.headline3,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          _sessionInfo(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(Icons.arrow_forward,
                  size: 24, color: themeData.themeColors.iconNext),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sessionInfo(BuildContext context) {
    //final timeFormat = DateFormat.Hm();
    final t = AppLocalizations.of(context)!;
    String status = "";
    switch (circle.state) {
      case SessionState.live:
        status = t.sessionInProgress;
        break;
      case SessionState.waiting:
        status = t.sessionWaiting;
        break;
      default:
        break;
    }
    final themeColor = Theme.of(context).themeColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (circle.description != null && circle.description!.isNotEmpty) ...[
          Text(
            circle.description!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 8,
          ),
        ],
        if (circle.createdBy != null) ...[
          Text(
            t.createdBy(circle.createdBy!.name),
            style: TextStyle(color: themeColor.primaryText, fontSize: 13),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
        Divider(
          height: 5,
          thickness: 1,
          color: themeColor.divider,
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                status,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            Text(
              t.participantCount(circle.participantCount),
            ),
          ],
        ),
      ],
    );
  }
}
