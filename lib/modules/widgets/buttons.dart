import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/extensions.dart';

class RippleButton extends StatelessWidget {
  final String text;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final VoidCallback onTap;

  const RippleButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.prefixWidget,
    this.suffixWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.purpleGradient.withHorizontalGradient,
        boxShadow: AppTheme.getShadow(AppTheme.cornflowerBlue),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              prefixWidget ?? Container(),
              AutoSizeText(
                text,
                style: AppTheme.text1.withWhite,
                textAlign: TextAlign.center,
                minFontSize: 8,
                maxLines: 1,
              ),
              suffixWidget ?? Container(),
            ],
          )).addRipple(onTap: onTap),
    );
  }
}

class DateButton extends StatelessWidget {
  final String text;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final VoidCallback onTap;

  const DateButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.prefixWidget,
    this.suffixWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(.5),
        ),
      ),
      child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              prefixWidget ?? Container(),
              SizedBox(width: 5,),
              AutoSizeText(
                text,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
                minFontSize: 8,
                maxFontSize: 14,
                maxLines: 1,
              ),
            ],
          )).addRipple(onTap: onTap),
    );
  }
}

class RippleCircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const RippleCircleButton({
    Key? key,
    required this.onTap, required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.purpleGradient.withHorizontalGradient,
        boxShadow: AppTheme.getShadow(AppTheme.cornflowerBlue),
        shape: BoxShape.circle,
      ),
      child: Padding(
          padding: EdgeInsets.all(16),
          child: child,
          ).addRipple(onTap: onTap),
    );
  }
}

class PinkButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback onTap;

  const PinkButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.pinkGradient.withHorizontalGradient,
        boxShadow: AppTheme.getShadow(AppTheme.frenchRose),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  SizedBox(width: 8),
                  Text(
                    text,
                    style: AppTheme.headline3.withWhite,
                    textAlign: TextAlign.center,

                  ),
                ],
              )
            : Text(
                text,
                style: AppTheme.headline3.withWhite,
                textAlign: TextAlign.center,
              ),
      ).addRipple(onTap: onTap),
    );
  }
}
