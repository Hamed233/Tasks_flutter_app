import 'package:flutter/material.dart';

class BorderedContainer extends StatelessWidget {
  final String? title;
  final Widget? child;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;

  const BorderedContainer({
    Key? key,
    this.title,
    this.child,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16.0),
        width: width,
        height: height,
        margin: margin,
        child: title == null
            ? child
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
                  ),
                  if (child != null) ...[const SizedBox(height: 10.0), child!]
                ],
              ),
      ),
    );
  }
}
