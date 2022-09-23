import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:manage_life_app/layout/settings/account_settings.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/providers/locale_provider.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/light_colors.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Languages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
      final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Localizations.localeOf(context);
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
          title: Text(
            AppLocalizations.of(context)!.chooseLanguage,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        provider.setLocale(Locale("en"));
                        AppCubit.get(context).updateGeneralUserSettings(context, "lang", "en");
                      },
                      child: Row(
                        children: [
                          Text(
                            "English",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          Spacer(),
                          if("en" == locale.languageCode)
                            Icon(
                              Icons.check,
                              color: mainColor,
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
                        provider.setLocale(Locale("ar"));
                        AppCubit.get(context).updateGeneralUserSettings(context, "lang", "ar");
                      },
                      child: Row(
                        children: [
                          Text(
                            "Arabic",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          Spacer(),
                          if("ar" == locale.languageCode)
                            Icon(
                              Icons.check,
                              color: mainColor,
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
          ),
      );
      }
    );
  }

  // Widget _languageBuilder(context, title, lang) {
  //   final provider = Provider.of<LocaleProvider>(context);
  //   final locale = provider.locale ?? Localizations.localeOf(context);
  //   return Container(
  //     child: Padding(
  //       padding: const EdgeInsets.all(10.0),
  //       child: InkWell(
  //         onTap: () {
  //           final provider =
  //               Provider.of<LocaleProvider>(
  //                   context, listen: false);
  //               provider.setLocale(locale);
  //         //  provider.setLocale(Locale(lang));
  //         },
  //         child: Row(
  //           children: [
  //             Text(
  //               title,
  //               style: TextStyle(
  //                 fontSize: 17,
  //               ),
  //             ),
  //             Spacer(),
  //             if(lang == locale.languageCode)
  //               Icon(
  //                 Icons.check,
  //                 color: mainColor,
  //                 size: 16,
  //               ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
