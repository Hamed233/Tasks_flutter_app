import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:manage_life_app/layout/login/login_screen.dart';
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

class ForgetPasswordScreen extends StatelessWidget {

  var emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is ResetPasswordSuccessful)
        {
          Helper.showCustomSnackBar(
            context, 
            content: "Password Reset Email Sent!", 
            bgColor: Colors.green,
            textColor: Colors.white
          );
      
          navigateAndFinish(
            context,
            LoginScreen(),
          );
    
        } else if (state is ResetPasswordFailed) {
          Helper.showCustomSnackBar(
            context, 
            content: "Your email not valid or not exist!", 
            bgColor: Colors.red,
            textColor: Colors.white
          );
        } else if (state is ResetPasswordLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator(),),
          );
        } 
      },
      builder: (context, state) {
        return Scaffold(
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
                              AppLocalizations.of(context)!.forgetPassowrdSubtext,
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
                              height: 25.0,
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
                                      AppCubit.get(context).resetPassword(emailController.text.trim());
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.submit,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.noAccountText,
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
                                        navigateTo(context, LoginScreen());
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.login,
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
