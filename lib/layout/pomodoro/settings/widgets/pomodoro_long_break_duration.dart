import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:manage_life_app/models/pomodoro_setting_model.dart';
import 'package:manage_life_app/layout/settings/account_settings.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/providers/locale_provider.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/pomodoro_bloc/pomodoro_cubit.dart';
import 'package:manage_life_app/providers/pomodoro_bloc/pomodoro_states.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/light_colors.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PomodoroLongBreakDurationWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PomodoroCubit, PomodoroStates>(
      listener: (context, state) {},
      builder: (context, state) {

      PomodoroCubit pomoCubit = PomodoroCubit.get(context);
      
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
              Helper.showPomodoroSettingsBottomSheet(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
            ),
          ),
          title: Text(
            "Long Break Duration",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 15.0,
            end: 15.0,
            top: 20.0,
            bottom: 20.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(10),
              color: Theme.of(context).cardColor,
            ),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return longBreakBuilder(context, longBreakDurations[index], pomoCubit.pomoSettings.longBreak);
              },
              separatorBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: .5,
                  color: Colors.grey,
                );
              },
              itemCount: longBreakDurations.length,
              
            ),
          ),
          ),
      );
      }
    );
  }

  Widget longBreakBuilder(context, duration, longBreak) {

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () {
            PomodoroCubit.get(context).updatePomodoroSettings(context, CacheHelper.getData(key: "user_id"), "longBreak", duration: duration);
          },
          child: Row(
            children: [
              Text(
                duration.inMinutes.toString() + " Minutes",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Spacer(),
              if(duration.inMinutes == longBreak.inMinutes)
                Icon(
                  Icons.check,
                  color: mainColor,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

}
