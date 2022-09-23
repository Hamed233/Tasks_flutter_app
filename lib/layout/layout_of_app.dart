import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manage_life_app/api/notification_api.dart';
import 'package:manage_life_app/layout/notifications/notifications_screen.dart';
import 'package:manage_life_app/layout/account_screen/account_screen.dart';
import 'package:manage_life_app/layout/notes_screen/archived_notes_screen.dart';
import 'package:manage_life_app/layout/pomodoro/pomodoro_technique.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/providers/locale_provider.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/note_bloc/note_bloc.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart'
    as taskCubit;
import 'package:manage_life_app/routes/argument_bundle.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:manage_life_app/shared/utiles/utils.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:provider/provider.dart';

class AppLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Timer.periodic(Duration(minutes: 3), (Timer t) => taskCubit.TaskCubit.get(context).checkDeadlineOfTasks(context));

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var userId = CacheHelper.getData(key: "user_id");

        var isLoginWith = CacheHelper.getData(key: "isLoginWith");
        var socialUserData;

        return Scaffold(
          key: scaffoldKey,
          appBar: cubit.currentIndex == 1
              ? AppBar(
                  elevation: 0,
                  leading: Container(
                    width: 45.0,
                    height: 30.0,
                    child: CircleAvatar(
                      child: Center(
                        child: SvgPicture.asset(
                          Resources.dashboardActive,
                          width: 20,
                          height: 20,
                        ),
                      ),
                      radius: 20,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  titleSpacing: 0,
                  title: Text(
                    "Tasks",
                    style: TextStyle(color: mainColor),
                  ),
                  actions: appBarActions(context, cubit, isLoginWith, socialUserData, userId),
                )
              : null,
          body: cubit.mainScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            elevation: 0,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            currentIndex: cubit.currentIndex,
            items: bottomBarList(),
          ),
          floatingActionButton: floatingBtn(context, cubit),
        );
      },
    );
  }

  Widget floatingBtn(context, cubit) {
    if (cubit.currentIndex == 0) {
      return FloatingActionButton(
        backgroundColor: mainColor,
        child: Icon(Icons.add),
        onPressed: () {
          Helper.showNoteBottomSheet(context, isUpdate: false);
        },
      );
    } else if (cubit.currentIndex == 2) {
      return FloatingActionButton(
          backgroundColor: mainColor,
          child: Icon(Icons.add),
          onPressed: () {
            Helper.showTaskBottomSheet(context);
          });
    } 
    // else if (cubit.currentIndex == 3) {
    //   return FloatingActionButton(
    //       backgroundColor: mainColor,
    //       child: Icon(Icons.add),
    //       onPressed: () {
    //         Helper.showAddProjectBottomSheet(context);
    //       });
    // }

    return mainFloatingBTN(context);
  }

  List<BottomNavigationBarItem> bottomBarList() {
    return [
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          Resources.notesActive,
          width: 20,
          height: 20,
        ),
        activeIcon: SvgPicture.asset(
          Resources.notesInactive,
          width: 20,
          height: 20,
        ),
        label: 'Notes',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          Resources.dashboardInactive,
          width: 20,
          height: 20,
        ),
        activeIcon: SvgPicture.asset(
          Resources.dashboardActive,
          width: 20,
          height: 20,
        ),
        label: 'Summery',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          Resources.tasksInactive,
          width: 25,
          height: 23,
        ),
        activeIcon: SvgPicture.asset(
          Resources.tasksActive,
          width: 25,
          height: 23,
        ),
        label: 'Tasks',
      ),
      // BottomNavigationBarItem(
      //   icon: Icon(
      //     Icons.layers,
      //     size: 30,
      //   ),
      //   label: 'Projects',
      // ),
    ];
  }

  List<Widget> appBarActions(context, cubit, isLoginWith, socialUserData, userId) {
    return [
      if (cubit.currentIndex == 1)
        InkWell(
          onTap: () {
            cubit.getNotifications(context);
            navigateTo(
                context,
                NotificationScreen(
                  bundle: ArgumentBundle(),
                ));
          },
          child: IconButton(
            onPressed: () {
              navigateTo(
                  context,
                  NotificationScreen(
                    bundle: ArgumentBundle(),
                  ));
            },
            icon: Stack(
              children: <Widget>[
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '20',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      InkWell(
        child: Container(
          padding: EdgeInsetsDirectional.only(start: 5, end: 5),
          width: 50,
          child: CircleAvatar(
            backgroundImage: imageProfile(isLoginWith, socialUserData, imageProfile, cubit),
            radius: 15,
          ),
        ),
        onTap: () {
          if (userId != null) AppCubit.get(context).userInfo(userId);
          navigateTo(context, AccountScreen());
        },
      ),
      if (cubit.currentIndex == 0)
        IconButton(
          onPressed: () => NoteBloc.get(context).toggleViewType(),
          icon: Icon(
            NoteBloc.get(context).notesViewType == viewType.List
                ? Icons.developer_board
                : Icons.view_headline,
            color: CentralStation.fontColor,
          ),
        ),
    ];
  }

  imageProfile(isLoginWith, socialUserData, imageProfile, cubit) {
    if (isLoginWith == "Google") {
      socialUserData = FirebaseAuth.instance.currentUser!;
      return NetworkImage(socialUserData.photoURL);
    } else if (isLoginWith == "fb") {
      return NetworkImage(CacheHelper.getData(key: "userFBPicture"));
    } else if (isLoginWith == "Twitter") {
      return
          NetworkImage(CacheHelper.getData(key: "userTwitterPicture"));
    } else if (isLoginWith == "Native_email") {
      return cubit.userData != null
          ? NetworkImage(cubit.userData!.image!)
          : AssetImage('assets/images/avatar.jpg');
    } else {
      return AssetImage('assets/images/avatar.jpg');
    }
  }

}
