
import 'package:flutter/material.dart';
import 'package:manage_life_app/shared/components/gradiant_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:manage_life_app/layout/layout_of_app.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.title,
    required this.image,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  bool isLast = false;

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value)
    {
      if (value) {
        navigateAndFinish(
          context,
          AppLayout(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final Locale appLocale = Localizations.localeOf(context);

    List<BoardingModel> boarding = [
      BoardingModel(
        image: 'assets/images/onboard/1.jpg',
        title: "Title1",
        body: "Praesent sapien massa, convallis a pellentesque nec, egestas non nisi. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula.",
      ),
      BoardingModel(
        image: 'assets/images/onboard/2.jpg',
        title: "Title2",
        body: "Praesent sapien massa, convallis a pellentesque nec, egestas non nisi. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula.",
      ),
      BoardingModel(
        image: 'assets/images/onboard/3.jpg',
        title: "Title3",
        body: "Praesent sapien massa, convallis a pellentesque nec, egestas non nisi. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula.",
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          if(!isLast)
            defaultTextButton(
              function: submit,
              text: AppLocalizations.of(context)!.skip,
              icon: Icons.arrow_forward_ios,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boardController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Center(
              child: SmoothPageIndicator(
                  controller: boardController,
                  effect: JumpingDotEffect(
                    dotColor: Colors.grey,
                    activeDotColor: mainColor,
                    spacing: 5.0,
                    dotHeight: 16,
                    dotWidth: 16,
                    jumpScale: .7,
                    verticalOffset: 15,
                  ),
                  count: boarding.length,
                ),
            )
          ],
        ),
      ),
    );
  }


  Widget buildBoardingItem(BoardingModel model) {

    final Locale appLocale = Localizations.localeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Image(
            image: AssetImage('${model.image}'),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.40,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Center(
          child: Text(
            '${model.title}',
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold
            ),
            textDirection: appLocale.toString() == "en" ? TextDirection.ltr : TextDirection.rtl,
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Center(
          child: Text(
            '${model.body}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
            ),
            textDirection: appLocale.toString() == "en" ? TextDirection.ltr : TextDirection.rtl,
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
        Container(
          width: 100,
          height: 35,
          child: RaisedGradientButton(
            child: Text(
              isLast ? AppLocalizations.of(context)!.login : AppLocalizations.of(context)!.next,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17
              ),
            ),
            gradient: LinearGradient(
              colors: <Color>[mainColor, Colors.deepPurpleAccent],
            ),
            onPressed: (){
              if (isLast) {
                submit();
              } else {
                boardController.nextPage(
                  duration: Duration(
                    milliseconds: 100,
                  ),
                  curve: Curves.fastLinearToSlowEaseIn,
                );
              }
            }
          ),
        ),
      ],
    );
  }
}
