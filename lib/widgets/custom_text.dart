import 'package:clock_app/utils/color_resources.dart';
import 'package:clock_app/utils/font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color color;
  final double lineHeight;
  final TextAlign textAlign;
  final GestureTapCallback? onTap;
  final bool isUnderLine;
  final bool isSingleLine;
  final int? maxLines;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextStyle? style;

  CustomText(String text,
      {this.fontWeight = FontWeight.w400,
        this.fontStyle,
        this.fontSize = FontSize.fourteen,
        this.color = ColorResources.grey1Color,
        this.lineHeight = 1.5, // Line Height - 24
        this.textAlign = TextAlign.left,
        this.onTap,
        this.isUnderLine = false,
        this.isSingleLine = false,
        this.style,
        this.maxLines})
  // ignore: prefer_initializing_formals
      : text = text;

  @override
  _CustomTextState createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_this
    final Text textWidget = Text(
      widget.text,
      // ignore: unnecessary_this
      textAlign: this.widget.textAlign,
      overflow: widget.isSingleLine ? TextOverflow.ellipsis : null,
      maxLines: widget.maxLines,
      style: widget.style ??
          TextStyle(
              decoration: widget.isUnderLine
                  ? TextDecoration.underline
                  : TextDecoration.none,
              color: widget.color,
              fontSize: widget.fontSize,
              height: widget.lineHeight,
              fontStyle: widget.fontStyle,
              fontWeight: widget.fontWeight),
      softWrap: true,
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        child: textWidget,
      );
    } else {
      return textWidget;
    }
  }
}
