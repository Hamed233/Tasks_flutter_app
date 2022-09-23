import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manage_life_app/layout/settings/settings.dart';
import 'package:manage_life_app/modules/widgets/active_project_card.dart';
import 'package:manage_life_app/modules/widgets/task_column.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/extensions.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:manage_life_app/modules/widgets/top_container.dart';
import 'package:manage_life_app/shared/styles/light_colors.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountScreen extends StatelessWidget {

  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  final dataMap = <String, double>{
    "Ecommerce": 5,
    "Social": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };

  @override
  Widget build(BuildContext context) {
      
    var username = AppLocalizations.of(context)!.guest;
    var isLoginWith = CacheHelper.getData(key: "isLoginWith");
    var googleUserDate;
    var imageURL;
    var whoIs = "Default";

    var userData = AppCubit.get(context).userData;

    if(isLoginWith == "Google") {
      googleUserDate = FirebaseAuth.instance.currentUser!;
      username = googleUserDate.displayName;
      imageURL = NetworkImage(googleUserDate.photoURL);
    } else if (isLoginWith == "fb") {
      imageURL = NetworkImage(CacheHelper.getData(key: "userFBPicture"));
      username = CacheHelper.getData(key: "userFBName");
    } else if (isLoginWith == "Twitter") {
      imageURL = NetworkImage(CacheHelper.getData(key: "userTwitterPicture"));
      username = CacheHelper.getData(key: "userTwitterName");
    } else if (isLoginWith == "Native_email" && userData != null) {
      imageURL = NetworkImage(userData.image!);
      username = userData.username!;
      whoIs = userData.whoIs!;
    } else {
      imageURL = AssetImage('assets/images/avatar.jpg');
    }

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Helper.showSettingsSheet(context);
                          }, 
                          icon: Icon(Icons.settings,
                            color: Colors.white, size: 30.0),
                        ),
                        // Icon(
                        //   Icons.search,
                        //     color: LightColors.kDarkBlue, size: 25.0),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircularPercentIndicator(
                            radius: 50.0,
                            lineWidth: 5.0,
                            animation: true,
                            percent: 0.75,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.green,
                            backgroundColor: Colors.white,
                            center: CircleAvatar(
                              backgroundColor: LightColors.kBlue,
                              radius: 35.0,
                              backgroundImage: imageURL),
                          ),
                          SizedBox(height: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  username,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5,),
                              Container(
                                child: Text(
                                  whoIs,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w400,
                                    wordSpacing: 3
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30,),
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.auto_graph_outlined,
                              ),
                              SizedBox(width: 5,),
                              subheading(AppLocalizations.of(context)!.goals),
                            ],
                          ),
                          Container(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    ActiveProjectsCard(
                                      cardColor: LightColors.kGreen,
                                      loadingPercent: 0.25,
                                      title: AppLocalizations.of(context)!.dailyGoal,
                                      subtitle: '1/5 ${AppLocalizations.of(context)!.tasks}',
                                    ),
                                    SizedBox(width: 20.0),
                                    ActiveProjectsCard(
                                      cardColor: LightColors.kRed,
                                      loadingPercent: 0.6,
                                      title: AppLocalizations.of(context)!.weeklyGoal,
                                      subtitle: '3/35 ${AppLocalizations.of(context)!.tasks}',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    ActiveProjectsCard(
                                      cardColor: LightColors.kDarkYellow,
                                      loadingPercent: 0.45,
                                      title: AppLocalizations.of(context)!.monthlyGoal,
                                      subtitle: '0/150 ${AppLocalizations.of(context)!.tasks}',
                                    ),
                                    SizedBox(width: 20.0),
                                    ActiveProjectsCard(
                                      cardColor: LightColors.kBlue,
                                      loadingPercent: 0.9,
                                      title: AppLocalizations.of(context)!.yearlyGoal,
                                      subtitle: '0/1800 ${AppLocalizations.of(context)!.tasks}',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 20,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.analytics_outlined,
                              ),
                              SizedBox(width: 5,),
                              subheading('${AppLocalizations.of(context)!.today} vs. ${AppLocalizations.of(context)!.yesterdayActivities}'),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          TaskColumn(
                            icon: Resources.tasksListWhite,
                            iconBackgroundColor: AppTheme.allTasksColor,
                            title: AppLocalizations.of(context)!.tasks,
                            subtitle: '5 ${AppLocalizations.of(context)!.tasks} vs. 10 ${AppLocalizations.of(context)!.tasks}',
                            isSvg: true,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TaskColumn(
                            icon: Icons.play_for_work,
                            iconBackgroundColor: AppTheme.inprogressTasksColor,
                            title: 'In Progress',
                            subtitle: '2 ${AppLocalizations.of(context)!.tasks} vs. 10 ${AppLocalizations.of(context)!.tasks}',
                          ),
                          SizedBox(height: 15.0),
                          TaskColumn(
                            icon: Icons.check_circle_outline,
                            iconBackgroundColor: AppTheme.doneTasksColor,
                            title: AppLocalizations.of(context)!.done,
                            subtitle: '18 ${AppLocalizations.of(context)!.tasksDone} vs. 10 ${AppLocalizations.of(context)!.tasks}',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.area_chart_outlined,
                          ),
                          SizedBox(width: 5,),
                          subheading(AppLocalizations.of(context)!.projectsProgress),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    PieChart(
                      key: ValueKey(key),
                      dataMap: dataMap,
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 3.2 > 300
                          ? 300
                          : MediaQuery.of(context).size.width / 3.0,
                      gradientList: gradientList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.disc,
                      centerText: AppLocalizations.of(context)!.projects,
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: false,
                      ),
                      emptyColor: Colors.grey,
                      emptyColorGradient: [
                        Color(0xff6c5ce7),
                        Colors.blue,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
