import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/themes.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: LottieBuilder.asset(Resources.loading,
            height: MediaQuery.of(context).size.height * 0.2),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: LottieBuilder.asset(Resources.empty,
            height: MediaQuery.of(context).size.height * 0.3),
      ),
    );
  }
}

class FailureWidget extends StatelessWidget {

  final String message;

  const FailureWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(message);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LottieBuilder.asset(Resources.error,
                  height: MediaQuery.of(context).size.height * 0.12),
              SizedBox(height: 20),
              Text(message, style: AppTheme.text1),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {

  final searchIn;
  const SearchWidget({Key? key, required this.searchIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(Resources.search,
                height: MediaQuery.of(context).size.height * 0.2),
            SizedBox(height: 20),
            Text("Search ${searchIn} Here", style: AppTheme.text1),
          ],
        ),
      ),
    );
  }
}

class ThinkingWidget extends StatelessWidget {

  const ThinkingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: LottieBuilder.asset(Resources.thinking,
                  height: MediaQuery.of(context).size.height * 0.2),
            ),
          ],
        ),
      ),
    );
  }
}

class GarbageWidget extends StatelessWidget {

  const GarbageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Center(
        child: LottieBuilder.asset(Resources.garbage,
            height: MediaQuery.of(context).size.height * 0.2),
      ),
    );
  }
}
