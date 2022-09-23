import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:manage_life_app/layout/forget_password/forget_password_screen.dart';
import 'package:manage_life_app/layout/register/register_screen.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/components/default_form_field.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../layout_of_app.dart';

class LoginScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppLoginSuccessState)
        {
          Helper.showCustomSnackBar(
            context, 
            content: AppLocalizations.of(context)!.doneLoginMessage, 
            bgColor: Colors.green,
            textColor: Colors.white
          );
      
          CacheHelper.saveData(
            key: 'user_id',
            value: state.uId,
          ).then((value)
          {
            CacheHelper.saveData(key: "isLoginWith", value: "Native_email");
            navigateAndFinish(
              context,
              AppLayout(),
            );
          });
    
        } else if (state is AppLoginErrorState) {
          Helper.showCustomSnackBar(
            context, 
            content: state.error, 
            bgColor: Colors.red,
            textColor: Colors.white
          );
        } else if (state is SignInWithGoogleSuccessful) {
          Helper.showCustomSnackBar(
            context, 
            content: AppLocalizations.of(context)!.doneLoginMessage, 
            bgColor: Colors.green,
            textColor: Colors.white
          );

          CacheHelper.saveData(key: "isLoginWith", value: "Google").then(((value) {
            navigateAndFinish(
                context,
                AppLayout(),
            );
          }));
        } else if (state is SignInWithGoogleFailed) {
          Helper.showCustomSnackBar(
            context, 
            content: state.error, 
            bgColor: Colors.red,
            textColor: Colors.white
          );
        } else if (state is SignInWithFBSuccessful) {
          Helper.showCustomSnackBar(
            context, 
            content: AppLocalizations.of(context)!.doneLoginMessage, 
            bgColor: Colors.green,
            textColor: Colors.white
          );

          CacheHelper.saveData(key: "isLoginWith", value: "fb").then(((value) {
            navigateAndFinish(
                context,
                AppLayout(),
            );
          }));
        } else if (state is SignInWithFBFailed) {
          Helper.showCustomSnackBar(
            context, 
            content: state.error, 
            bgColor: Colors.red,
            textColor: Colors.white
          );
        } else if (state is SignInWithTwitterSuccessful) {
          Helper.showCustomSnackBar(
            context, 
            content: AppLocalizations.of(context)!.doneLoginMessage, 
            bgColor: Colors.green,
            textColor: Colors.white
          );

          CacheHelper.saveData(key: "isLoginWith", value: "Twitter").then(((value) {
            navigateAndFinish(
                context,
                AppLayout(),
            );
          }));
        } else if (state is SignInWithTwitterFailed) {
          Helper.showCustomSnackBar(
            context, 
            content: state.error, 
            bgColor: Colors.red,
            textColor: Colors.white
          );
        } else if (state is AppLoginLoadingState || state is SignInWithGoogleLoading || state is SignInWithFBLoading || state is SignInWithTwitterLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator(),),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Color.fromARGB(255, 241, 241, 241),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: const Image(
                                      image: AssetImage('assets/images/logo.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.login.toUpperCase(),
                              style: TextStyle(
                                fontSize: 30.0,
                                letterSpacing: 3.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.loginSubtext,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            DefaultFormField(
                              type: TextInputType.emailAddress,
                              controller: emailController,
                              label: AppLocalizations.of(context)!.email,
                              focusedColorBorder: HexColor("#ced4da"),
                              labelColor: Colors.grey,
                              borderWidth: 50.0,
                              prefixColorIcon: Colors.grey,
                              prefix: Icons.alternate_email_outlined,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email!';
                                }
                                return null;
                              },
                              borderColor: HexColor("#ced4da"),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            DefaultFormField(
                              type: TextInputType.visiblePassword,
                              controller: passwordController,
                              label: AppLocalizations.of(context)!.password,
                              isPassword: AppCubit.get(context).isPassword,
                              focusedColorBorder: HexColor("#ced4da"),
                              labelColor: Colors.grey,
                              borderWidth: 50.0,
                              prefixColorIcon: Colors.grey,
                              prefix: Icons.password,
                              suffix: AppCubit.get(context).suffix,
                              maxLines: 1,
                              isSuffix: true,
                              suffixPressed: () => AppCubit.get(context).changePasswordVisibility(),
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password!';
                                }
                                return null;
                              },
                              borderColor: HexColor("#ced4da"),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: Text(
                                  AppLocalizations.of(context)!.forgetPassword,
                                ),
                                onPressed: () {
                                  navigateTo(context, ForgetPasswordScreen());
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            ConditionalBuilder(
                              condition: state is! AppLoginLoadingState || state is! SignInWithGoogleLoading,
                              builder: (context) => Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: mainColor,
                                ),
                                child: MaterialButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      AppCubit.get(context).userLogin(
                                        email: emailController.text, 
                                        password: passwordController.text);
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.login,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                              fallback: (context) => Center(child: CircularProgressIndicator()),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              children: [
                                Expanded(child: Divider(color: Color.fromARGB(255, 213, 212, 212), thickness: 1,)),
                                Text(
                                  " ${AppLocalizations.of(context)!.loginWith} ",
                                  style: TextStyle(
                                    color: Colors.grey
                                  ),
                                ),
                                Expanded(child: Divider(color: Color.fromARGB(255, 213, 212, 212), thickness: 1,)),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loginAndRegisterWithBuilder(context, state, Resources.facebook, "fb"),
                                SizedBox(width: 5,),
                                loginAndRegisterWithBuilder(context, state, Resources.google, "google"),
                                SizedBox(width: 5,),
                                loginAndRegisterWithBuilder(context, state, Resources.twitter, "twitter"),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.existAccountText,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(0),
                                  width: 70,
                                  child: TextButton(
                                      onPressed: () {
                                        navigateTo(context, RegisterScreen());
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.register,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            );
      },
    );
  }
}
