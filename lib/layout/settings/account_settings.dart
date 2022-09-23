import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/components/default_form_field.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/light_colors.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/extensions.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettingsScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var imageProfile;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var appCubit = AppCubit.get(context);
        var userId = CacheHelper.getData(key: "user_id");
        var isLoginWithGoogle = CacheHelper.getData(key: "isLoginWithGoogle");
        var whoIs = UserType.Default.name.toString();
        var googleUserDate;
        var lang;

        if(appCubit.userData != null && userId != null) {
          emailController = TextEditingController(text: appCubit.userData!.email);
          usernameController = TextEditingController(text: appCubit.userData!.username);
          passwordController = TextEditingController(text: appCubit.userData!.password);
          imageProfile = appCubit.profileImage != null ? FileImage(appCubit.profileImage!) : NetworkImage(appCubit.userData!.image!); 
          lang = appCubit.userData!.user_settings!.language!;
          if(state is! GetSelectedValueOfWhoIs)
            whoIs = appCubit.userData!.whoIs!;
        } else if (isLoginWithGoogle != null) {
          emailController = TextEditingController(text: googleUserDate.email);
          usernameController = TextEditingController(text: googleUserDate.displayName);
          imageProfile = NetworkImage(googleUserDate.photoURL);
          googleUserDate = FirebaseAuth.instance.currentUser!;
        }

      return Directionality(
        textDirection: currentLang != null ? (currentLang == "ar" ? TextDirection.rtl : TextDirection.ltr) : (lang != null ? (lang == "ar" ? TextDirection.rtl : TextDirection.ltr) : TextDirection.ltr),
        child: Scaffold(
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
              AppLocalizations.of(context)!.accountDetails,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
            elevation: 0.0,
            actions: [
              defaultTextButton(function: () {
                  if (formKey.currentState!.validate() && state is! UpdatetUserDataLoadingState) {
                    if(appCubit.selectedValueOfWhoIs == 1) {
                      whoIs = UserType.Student.name.toString();
                    } else if (appCubit.selectedValueOfWhoIs == 2) {
                      whoIs = UserType.Freelancer.name.toString();
                    } else if (appCubit.selectedValueOfWhoIs == 3) {
                      whoIs = UserType.Programmer.name.toString();
                    } else if (appCubit.selectedValueOfWhoIs == 4) {
                      whoIs = UserType.Entrepreneur.name.toString();
                    }
                    AppCubit.get(context).updateUserInfo(
                      userId,
                      username: usernameController.text, 
                      email: emailController.text, 
                      password: passwordController.text,
                      whoIs: whoIs);
                  }
              }, text: AppLocalizations.of(context)!.save), // Check first if any edit!
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
                child: state is! UpdatetUserDataLoadingState ? Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(imageProfile != null) 
                        Center(
                          child: state is! ProfileImagePickedLoadingState ? CircleAvatar(
                            backgroundImage: imageProfile,
                            radius: 50,
                          ) : CircularProgressIndicator(color: mainColor,),
                        ),
                      if(userId != null)
                        Center(
                          child: TextButton(
                            child: Text(AppLocalizations.of(context)!.edit),
                            onPressed: () {
                              appCubit.getProfileImage(userId);
                            },
                          ),
                        ),
                      SizedBox(height: 30,),
                      Text(
                        AppLocalizations.of(context)!.username,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5,),
                      DefaultFormField(
                        type: TextInputType.text,
                        controller: usernameController,
                        focusedColorBorder: HexColor("#ced4da"),
                        labelColor: Colors.grey,
                        hintColor: Theme.of(context).textTheme.bodyText2?.color,
                        borderWidth: 10.0,
                        prefixColorIcon: Colors.grey,
                        prefix: Icons.person,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username!';
                          }
                          return null;
                        },
                        borderColor: HexColor("#ced4da"),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        AppLocalizations.of(context)!.email,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5,),
                      DefaultFormField(
                        type: TextInputType.emailAddress,
                        controller: emailController,
                        focusedColorBorder: HexColor("#ced4da"),
                        labelColor: Colors.grey,
                        borderWidth: 10.0,
                        prefixColorIcon: Colors.grey,
                        prefix: Icons.alternate_email,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email!';
                          }
                          return null;
                        },
                        borderColor: HexColor("#ced4da"),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        AppLocalizations.of(context)!.password,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5,),
                      DefaultFormField(
                        type: TextInputType.visiblePassword,
                        controller: passwordController,
                        focusedColorBorder: HexColor("#ced4da"),
                        labelColor: Colors.grey,
                        borderWidth: 10.0,
                        prefixColorIcon: Colors.grey,
                        prefix: Icons.password,
                        maxLines: 1,
                        isPassword: appCubit.isPassword,
                        isSuffix: true,
                        suffix: appCubit.suffix,
                        suffixPressed: () => appCubit.changePasswordVisibility(),
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password!';
                          }
                          return null;
                        },
                        borderColor: HexColor("#ced4da"),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        AppLocalizations.of(context)!.whoAreYou,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5,),
                      whoAreYouBuilder(context, whoIs, width: double.infinity, cubit: appCubit),
                    ]
                  ),
                ) : Center(child: CircularProgressIndicator(),),
              ),
            ),
          ) : Center(child: CircularProgressIndicator(),),
        ),
      );
      }
    );
  }
}
