import 'package:clock_app/utils/color_resources.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomListTile extends StatefulWidget {
  final String? subTitle;
  final String? atime;
  final String? timeRange;
  final Widget? widget;
  final isEnable = false;
  final isClock = true;
  final String? clock;
  final isAlarm = false;
  final isTimer = false;
  final String? hrs;
  final String? sec;
  final String? min;
  final bool switchValue = true;
  void Function(bool)? aOn;
  void Function()? isPlayOrPause;
  final bool isPlay = false;

  CustomListTile({
    Key? key,
    this.atime,
    this.subTitle,
    this.timeRange,
    this.widget,
    this.clock,
    this.hrs,
    this.sec,
    this.min,
    this.aOn,
    this.isPlayOrPause,
  }) : super(key: key);

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: RichText(
          text: TextSpan(
        text: widget.isClock ? widget.clock : "",
        style: const TextStyle(fontSize: 30, color: ColorResources.grey1Color),
        children: <TextSpan>[
          if (widget.isAlarm) ...[
            TextSpan(
                text: widget.atime,
                style: TextStyle(
                    fontSize: 40,
                    color: widget.isEnable
                        ? ColorResources.black1Color
                        : ColorResources.grey1Color)),
            const TextSpan(text: "  ", style: TextStyle(fontSize: 20)),
            TextSpan(
                text: widget.timeRange,
                style: TextStyle(
                    fontSize: 20,
                    color: widget.isEnable
                        ? ColorResources.black1Color
                        : ColorResources.grey1Color))
          ],
          if (widget.isTimer) ...[
            TextSpan(text: widget.hrs, style: const TextStyle(fontSize: 40)),
            const TextSpan(text: "H  ", style: TextStyle(fontSize: 20)),
            TextSpan(text: widget.min, style: const TextStyle(fontSize: 40)),
            const TextSpan(text: "M  ", style: TextStyle(fontSize: 20)),
            TextSpan(text: widget.sec, style: const TextStyle(fontSize: 40)),
            const TextSpan(text: "S  ", style: TextStyle(fontSize: 20)),
          ]
        ],
      )),
      subtitle: CustomText(widget.subTitle ?? '',
          style: TextStyle(
              fontSize: 20,
              color: (widget.isAlarm && widget.isEnable)
                  ? ColorResources.black1Color
                  : (widget.isAlarm && widget.isEnable!)
                      ? ColorResources.grey2Color
                      : ColorResources.grey1Color)),
      trailing: (widget.isClock)
          ? RichText(
              text: TextSpan(text: "", children: [
                TextSpan(
                    text: widget.atime,
                    style: TextStyle(
                        fontSize: 40,
                        color: widget.isEnable
                            ? ColorResources.black1Color
                            : ColorResources.grey1Color)),
                const TextSpan(text: "  ", style: TextStyle(fontSize: 20)),
                TextSpan(
                    text: widget.timeRange,
                    style: TextStyle(
                        fontSize: 20,
                        color: widget.isEnable
                            ? ColorResources.black1Color
                            : ColorResources.grey1Color))
              ]),
            )
          : (widget.isAlarm)
              ? Switch(value: widget.switchValue, onChanged: widget.aOn)
              : IconButton(
                  onPressed: widget.isPlayOrPause,
                  icon: Icon(
                    (widget.isPlay) ? Icons.play_arrow_outlined : Icons.pause,
                    color: ColorResources.lav2Color,
                    size: 40,
                  )),
    );
  }
}
