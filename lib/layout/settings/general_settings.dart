import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:intl/intl.dart';
import 'package:manage_life_app/layout/settings/account_settings.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/light_colors.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GeneralSettingsScreen extends StatelessWidget {

  TimeOfDay selectedTime = TimeOfDay.now();
  var wakeUpTime;
  var sleepTime;
  var startWeekDay;
  var getCurrrentLang;


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
    
      var appCubit = AppCubit.get(context);
      wakeUpTime = appCubit.normalUserSettings.wakeUpAt;
      sleepTime  = appCubit.normalUserSettings.sleepAt;
      startWeekDay = appCubit.normalUserSettings.startWeekOn;
      getCurrrentLang = appCubit.normalUserSettings.language;

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
              Helper.showSettingsSheet(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).appBarTheme.iconTheme?.color,
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.generalSettings,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
          elevation: 0.2,
        ),
        
        body: state is! GetUserDataLoadingState ? Container(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 15.0,
              end: 15.0,
              top: 20.0,
              bottom: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Helper.showChooseLanguageBottomSheet(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.language,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            AppLocalizations.of(context)!.language,
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          Spacer(),
                          Text(
                            getCurrrentLang != null ? (getCurrrentLang == "en" ? AppLocalizations.of(context)!.english : AppLocalizations.of(context)!.arabic) : "Auto",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 5,),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.grey,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(10),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Helper.showStartWeekOnBottomSheet(context);
                            },
                            child: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.startWeekOn,
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  startWeekDay!,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              
                              _selectTime(context, "wake", appCubit);

                            },
                            child: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.wakesUpAt,
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  wakeUpTime.toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              _selectTime(context, "sleep", appCubit);
                            },
                            child: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.sleepAt,
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  sleepTime.toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20,),
               
              ],
            ),
          ),
        ) : Center(child: CircularProgressIndicator(),),
      );
      }
    );
  }

  _selectTime(BuildContext context, forWhat, appCubit) async {
      DateTime now = new DateTime.now();
      DateTime timeAsDateTime = DateFormat.jm().parse(forWhat == "wake" ? wakeUpTime : sleepTime);
      String timeAs24Hours = DateFormat("HH:mm").format(timeAsDateTime);
      TimeOfDay timeAsTimeOfDay = TimeOfDay.now().replacing(hour: int.parse(timeAs24Hours.split(' ').removeAt(0).split(":")[0]), minute: int.parse(timeAs24Hours.split(' ').removeAt(0).split(":")[1]));
      
      TimeOfDay initialTime;
      
      if(forWhat == "sleep") {
        initialTime = sleepTime == null ? appCubit.sleepTime : timeAsTimeOfDay;
      } else {
        initialTime = wakeUpTime == null ? appCubit.wakeUpTime : timeAsTimeOfDay;
      }
        
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: initialTime,
        initialEntryMode: TimePickerEntryMode.dial,
      );

      
      if(time != null && time != selectedTime) {
        forWhat == "sleep" ? appCubit.updateGeneralUserSettings(context, "sleepAt", time.format(context)) : appCubit.updateGeneralUserSettings(context, "wakeUpAt", time.format(context));
      }
  }
}
