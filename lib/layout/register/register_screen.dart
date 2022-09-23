import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:manage_life_app/layout/login/login_screen.dart';
import 'package:manage_life_app/models/user_model.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/components/default_form_field.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  UserModel? model;

  final formKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if(state is AppRegisterSuccessState) {
              Helper.showCustomSnackBar(
                context, 
                content: AppLocalizations.of(context)!.doneRegisterMessage, 
                bgColor: Colors.green,
                textColor: Colors.white
              );
    
              navigateAndFinish(
                context,
                LoginScreen(),
              );
          } else if (state is AppRegisterErrorState) {
              Helper.showCustomSnackBar(
                context, 
                content: state.error, 
                bgColor: Colors.red,
                textColor: Colors.white
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
                            AppLocalizations.of(context)!.register.toUpperCase(),
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
                            AppLocalizations.of(context)!.registerSubtext,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          DefaultFormField(
                            type: TextInputType.text,
                            controller: usernameController,
                            label: AppLocalizations.of(context)!.username,
                            focusedColorBorder: HexColor("#ced4da"),
                            labelColor: Colors.grey,
                            borderWidth: 50.0,
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
                          const SizedBox(
                            height: 10.0,
                          ),
                          DefaultFormField(
                            type: TextInputType.emailAddress,
                            controller: emailController,
                            label: AppLocalizations.of(context)!.email,
                            focusedColorBorder: HexColor("#ced4da"),
                            labelColor: Colors.grey,
                            borderWidth: 50.0,
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
                          const SizedBox(
                            height: 10.0,
                          ),
                          DefaultFormField(
                            type: TextInputType.visiblePassword,
                            controller: passwordController,
                            label: AppLocalizations.of(context)!.password,
                            focusedColorBorder: HexColor("#ced4da"),
                            labelColor: Colors.grey,
                            borderWidth: 50.0,
                            prefixColorIcon: Colors.grey,
                            prefix: Icons.person,
                            isPassword: AppCubit.get(context).isPassword,
                            suffix: AppCubit.get(context).suffix,
                            isSuffix: true,
                            maxLines: 1,
                            suffixPressed: () => AppCubit.get(context).changePasswordVisibility(),
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password!';
                              }
                              return null;
                            },
                            borderColor: HexColor("#ced4da"),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! AppRegisterLoadingState,
                            builder: (context) => Container(
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: mainColor,
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    AppCubit.get(context).userRegister(
                                      name: usernameController.text, 
                                      email: emailController.text, 
                                      password: passwordController.text);
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.register,
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
                                AppLocalizations.of(context)!.existAccountText,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(0),
                                width: 55,
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
