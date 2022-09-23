import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manage_life_app/shared/components/constants.dart';

class TaskColumn extends StatelessWidget {
  final icon;
  final Color? iconBackgroundColor;
  final String? title;
  final String? subtitle;
  bool isSvg;
  TaskColumn({
    this.icon,
    this.iconBackgroundColor,
    this.title,
    this.subtitle,
    this.isSvg = false,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: iconBackgroundColor,
          child: isSvg ? SvgPicture.asset(icon, width: 20, height: 25) : Icon(
            icon,
            size: 25.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title!,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle!,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45),
            ),
          ],
        )
      ],
    );
  }
}
