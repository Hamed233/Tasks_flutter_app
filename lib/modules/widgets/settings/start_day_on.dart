import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:manage_life_app/layout/settings/account_settings.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/light_colors.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class StartWeekOn extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var appCubit = AppCubit.get(context);
        var startDay = appCubit.normalUserSettings.startWeekOn != null ? appCubit.normalUserSettings.startWeekOn : "Saturday";
    
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
              Helper.showGeneralSettingsBottomSheet(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
            ),
          ),
          title: Text("Start Week On"),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _dayBuilder(context, "Saturday", startDay),
                Divider(),
                _dayBuilder(context, "Sunday", startDay),
                Divider(),
                _dayBuilder(context, "Monday", startDay),
                Divider(),
                _dayBuilder(context, "Tuesday", startDay),
                Divider(),
                _dayBuilder(context, "Wednesday", startDay),
                Divider(),
                _dayBuilder(context, "Thursday", startDay),
                Divider(),
                _dayBuilder(context, "Friday", startDay),
            
              ],
            ),
          ),
          ),
      );
      }
    );
  }

  Widget _dayBuilder(context, day, startWeekDay) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            AppCubit.get(context).updateGeneralUserSettings(context, "startWeekOn", day);
          },
          child: Row(
            children: [
              Text(
                day,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Spacer(),

              if(day == startWeekDay)
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
