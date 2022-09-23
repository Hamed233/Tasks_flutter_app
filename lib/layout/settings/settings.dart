import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:manage_life_app/layout/login/login_screen.dart';
import 'package:manage_life_app/layout/settings/account_settings.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/shared/components/animated_toggle_widget.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/light_colors.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
      
      var userId = CacheHelper.getData(key: "user_id");
      var isLoginWith = CacheHelper.getData(key: "isLoginWith");
      
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: Container(),
          title: Text(
            AppLocalizations.of(context)!.settings,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
          elevation: 0.0,
          actions: [
            defaultTextButton(function: () => Navigator.pop(context), text: "Done"),
          ],
        ),
        body: state is! GetUserDataLoadingState ? SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
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
                  if(isLoginWith == "Native_email")
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Helper.showAccountSettingsBottomSheet(context, userId != null ? userId : null);
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
                                Icons.person_pin,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10,),
                              Text(
                                AppLocalizations.of(context)!.account,
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
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
                                AppCubit.get(context).userInfo(CacheHelper.getData(key: "user_id"));
                                Helper.showGeneralSettingsBottomSheet(context);
                              },
                              child: Row(
                                children: [
                                 Icon(
                                    Icons.settings,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    AppLocalizations.of(context)!.general,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
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
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.dark_mode,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    AppLocalizations.of(context)!.toggleMode,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
                                  AnimatedToggle(
                                    values: [AppLocalizations.of(context)!.dark, AppLocalizations.of(context)!.light],
                                    onToggleCallback: () {
                                      AppCubit.get(context).changeAppMode();
                                    },
                                    buttonColor: Theme.of(context).scaffoldBackgroundColor,
                                    backgroundColor: Color.fromARGB(255, 213, 212, 212),
                                    textColor: Colors.grey,
                                    isDark: AppCubit.get(context).isDark,
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
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.notifications_none,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    AppLocalizations.of(context)!.notifications,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
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
                      ],
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
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.help_outline,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    AppLocalizations.of(context)!.helpFeedback,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
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
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    AppLocalizations.of(context)!.about,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
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
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.new_releases_outlined,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    AppLocalizations.of(context)!.whatIsNew,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
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
                      ],
                    ),
                  ),
        
                  SizedBox(height: 20,),
        
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          if(isLoginWith != null) {
                            AppCubit.get(context).signOut(context);
                          } else {
                            navigateTo(context, LoginScreen());
                          }
                        },
                        child: state is! SignoutLoading ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                               isLoginWith != null ? Icons.logout_outlined : Icons.login,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10,),
                            Text(
                              isLoginWith != null ? "Logout" : "Login",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ) : Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25,),
                ],
              ),
            ),
          ),
        ) : Center(child: CircularProgressIndicator(color: mainColor, strokeWidth: 3)),
      );
      }
    );
  }
}
