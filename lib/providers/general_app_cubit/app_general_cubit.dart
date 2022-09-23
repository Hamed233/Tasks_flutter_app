
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:manage_life_app/api/notification_api.dart';
import 'package:manage_life_app/l10n/l10n.dart';
import 'package:manage_life_app/layout/account_screen/account_screen.dart';
import 'package:manage_life_app/layout/layout_of_app.dart';
import 'package:manage_life_app/layout/notes_screen/notes_screen.dart';
import 'package:manage_life_app/layout/pomodoro/settings/settings_tab.dart';
import 'package:manage_life_app/layout/projects_screen/projects/presentation/pages/projects.dart';
import 'package:manage_life_app/layout/summery_screen/summery_screen.dart';
import 'package:manage_life_app/layout/tasks_screens/list_of_tasks.dart';
import 'package:manage_life_app/layout/tasks_screens/tasks_screen.dart';
import 'package:manage_life_app/models/general_user_settings_model.dart';
import 'package:manage_life_app/models/notification_model.dart';
import 'package:manage_life_app/models/pomodoro_setting_model.dart';
import 'package:manage_life_app/models/user_model.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/note_bloc/note_bloc.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:manage_life_app/shared/utiles/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 1;

  List<Widget> mainScreens = [
    NotesScreen(),
    SummeryScreen(),
    TasksScreen(),
    // ProjectsScreen()
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  bool isDark = false;

  changeAppMode({
    bool? fromShared
  })
  {
    if (fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }

  timeOfWakeUpAndSleep(context, {
    selectedTime,
    forWakeUp = true
  }) {
    if(forWakeUp) {
      CacheHelper.saveData(key: 'WakeUpTime', value: selectedTime);
    } else {
      CacheHelper.saveData(key: 'SleepTime', value: selectedTime);
    }
    emit(ChangeeWakeUpOrSleepTime());
  }

  UserNormalSettings normalUserSettings = UserNormalSettings();
  
  Future updateGeneralUserSettings(context, updateColumn, newValue) async {
    emit(UpdateGeneralUserSettingsLoading());
    
    var column;
    if(updateColumn == "lang") {
      column = "language";
    } else if (updateColumn == "startWeekOn") {
      column = "startWeekOn";
    } else if (updateColumn == "wakeUpAt") {
      column = "wakeUpAt";
    } else if (updateColumn == "sleepAt") {
      column = "sleepAt";
    }

    var userId = CacheHelper.getData(key: "user_id");

    if(userId != null) {
      await FirebaseFirestore.instance.collection("users").doc(userId).update({'user_settings.$column': newValue}).then((value) {
        if(updateColumn == "lang") {
          normalUserSettings.language = newValue;
        } else if (updateColumn == "startWeekOn") {
          normalUserSettings.startWeekOn = newValue;
        } else if (updateColumn == "wakeUpAt") {
          normalUserSettings.wakeUpAt = newValue;
        } else if (updateColumn == "sleepAt") {
          normalUserSettings.sleepAt = newValue;
        }
        emit(UpdateGeneralUserSettings());
      });

    }
  }

  bool actionsHidden = true;

  showAddActions() {
    actionsHidden = !actionsHidden;
    emit(ShowOrHiddenAddActions());
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined ;

    emit(ChangePasswordVisibilityState());
  }

  // Get Date of Task
  final DateTime today = new DateTime.now();
  late String startDate = new DateFormat('dd, MMMM yyyy').format(today).toString(),
      endDate = new DateFormat('dd, MMMM yyyy').format(today).toString();
  late String? currentTime = new DateFormat('hh:mm a').format(today).toString();


  Future<List<Map<String, dynamic>>> getNotificationsList() async {
    Database db = await DatabaseHelper.instance.db;
    final List<Map<String, dynamic>> result = await db.query(DatabaseHelper.instance.notificationsTable, orderBy: "id DESC");
    return result;
  }

  List<NotificationModel> notifications = [];
  // Get All notifications
  Future getNotifications(context) async {

    final List<Map<String, dynamic>> notificationsMapList = await getNotificationsList();
    notifications = [];

    emit(GettingNotificationsLoading());

    notificationsMapList.forEach((notificationMap) {
      DateTime currentDateTime = new DateTime.now();
      var startDateTimeAndTime = notificationMap['start_date'] + " " + notificationMap['start_time'];
      DateTime sdt = DateFormat("dd, MMMM yyyy HH:mm a").parse(startDateTimeAndTime);

      if(sdt.isBefore(currentDateTime) || currentDateTime == sdt) {
        notifications.add(NotificationModel.fromMap(notificationMap));
      }

    });

    emit(GettingNotificationsDone());
  }

  Future makeNotificationOpend(context, payload) async {
    
    emit(NotificationsOpendIsLoading());

    Database db = await DatabaseHelper.instance.db;
    await db.rawUpdate('UPDATE ${DatabaseHelper.instance.notificationsTable} SET is_open = ? WHERE payload = ?', [1, '$payload']).then((value) {
      getNotifications(context);
      emit(NotificationsIsOpend());
    });

  }


  void userRegister({
    required String name,
    required String email,
    required String password,
  })
  {
    emit(AppRegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      print(value.user);
      createUser(
        uId: value.user!.uid,
        name: name,
        email: email,
        password: password,
      );
    }).catchError((error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          error = "Email already used. Go to login page.";
          print(error);
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          error = "Wrong email/password combination.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          error = "No user found with this email.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          error = "User disabled.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          error = "Too many requests to log into this account.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          error = "Server error, please try again later.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          error = "Email address is invalid.";
          emit(AppRegisterErrorState(error));
          break;
        default:
          error = "Register failed. Please try again.";
          emit(AppRegisterErrorState(error));
          break;
      }
      print(error.toString());
      emit(AppRegisterErrorState(error.toString()));
    });
  }

  void createUser({
    required String name,
    required String email,
    required String password,
    required String uId,
})
  {
    UserModel model = UserModel.withId(
      username: name,
      email: email,
      password: password,
      image: "assets/images/avatar.jpg",
      id: uId,
      isVerfied: false, 
      date: DateTime.now().toIso8601String(),
      pomo_settings: PomodoroSetting(),
      user_settings: UserNormalSettings(),
    );


    FirebaseFirestore.instance.collection('users')
        .doc(uId.toString()).set(model.toMap()).then((value) {
      emit(AppRegisterSuccessState());
    }).catchError((error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          error = "Email already used. Go to login page.";
          print(error);
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          error = "Wrong email/password combination.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          error = "No user found with this email.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          error = "User disabled.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          error = "Too many requests to log into this account.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          error = "Server error, please try again later.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          error = "Email address is invalid.";
          emit(AppRegisterErrorState(error));
          break;
        default:
          error = "Register failed. Please try again.";
          emit(AppRegisterErrorState(error));
          break;
      }
      print(error.toString());
    });
  }

  void userLogin({
    required String email,
    required String password,
  })
  {
    emit(AppLoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      print(value.toString());
      emit(AppLoginSuccessState(value.user!.uid));
    }).catchError((error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          error = "Email already used. Go to login page.";
          print(error);
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          error = "Wrong email/password combination.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          error = "No user found with this email.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          error = "User disabled.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          error = "Too many requests to log into this account.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          error = "Server error, please try again later.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          error = "Email address is invalid.";
          emit(AppRegisterErrorState(error));
          break;
        default:
          error = "Register failed. Please try again.";
          emit(AppRegisterErrorState(error));
          break;
      }
      print(error.toString());
      emit(AppLoginErrorState(error.toString()));
    });
  }

  UserModel? userData;
  
  Future userInfo(userId)
   async {
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance.collection("users").doc(userId).get().then((value) {
      userData = UserModel.fromMap(value.data()!);
      normalUserSettings = userData!.user_settings!;
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserDataErrorState(error.toString()));
    });
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage(userId) async {

    emit(ProfileImagePickedLoadingState());

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null) {
      profileImage = File(pickedFile.path);
      firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!).then((value) {
          value.ref.getDownloadURL().then((value) {
            FirebaseFirestore.instance.collection("users").doc(userId).update({"image": value}).then((value) {
              userInfo(userId);
              emit(ProfileImagePickedSuccessState());
            }).catchError((error) {
              emit(ProfileImagePickedErrorState());
              print(error.toString());
            });
          });
        });
    } else {
      emit(ProfileImagePickedErrorState());
    }
  }

  Future updateUserInfo(userId, {email, username, password, whoIs})
   async {
    emit(UpdatetUserDataLoadingState());
    FirebaseFirestore.instance.collection("users").doc(userId).update({
      "username": username,
      "email": email,
      "password": password,
      "whoIs": whoIs,
    }).then((value) {
      userInfo(userId);
      emit(UpdatetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UpdatetUserDataErrorState(error.toString()));
    });
  }


// void uploadProfileImage() {
//     emit(SocialUserUpdateLoadingState());
//     firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child('users/${Uri.file(profileImage.path).pathSegments.last}')
//         .putFile(profileImage)
//         .then((value) {
//       value.ref.getDownloadURL()
//           .then((value) {
//         // emit(SocialUploadProfileImageSuccessState());
//         print(value);
//         updateUser(
//             name: name,
//             phone: phone,
//             bio: bio,
//             image: value,
//         );
//       }).catchError((error) {
//         emit(SocialUploadProfileImageErrorState());
//       });
//     }).catchError((error) {
//       emit(SocialUploadProfileImageErrorState());
//     });
//   }

  // SignIn With Google
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    emit(SignInWithGoogleLoading());
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credintial = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credintial).then((value) {
      print(value);
      emit(SignInWithGoogleSuccessful());
    }).catchError((error) {
      emit(SignInWithGoogleFailed(error.toString()));
    });
  }

  Future loginWithFB() async {
    emit(SignInWithFBLoading());
    FacebookAuth.instance.login().then((value) {
        final fbAuthCredential = FacebookAuthProvider.credential(value.accessToken!.token);
        FacebookAuth.instance.getUserData().then((value) async {
          await FirebaseAuth.instance.signInWithCredential(fbAuthCredential).then((value) {
            CacheHelper.saveData(key: "userFBPicture", value: value.user!.photoURL!);
            CacheHelper.saveData(key: "userFBName", value: value.user?.displayName!);
            CacheHelper.saveData(key: "user_id", value: value.user?.uid);
            emit(SignInWithFBSuccessful());
          });
        });
    }).catchError((err) {
      emit(SignInWithFBFailed(err.toString()));
    });
  }

  Future loginWithTwitter() async {
    emit(SignInWithTwitterLoading());
    final twitterLogin = TwitterLogin(apiKey: "8BIjN5wBIWQSoaonfwRG1DSIi", apiSecretKey: "RCS78NFxOPTk915nMzeKZBTJco3f4uDZTETFZwEiUpneMljDby", redirectURI: "twitter-login://");
    await twitterLogin.login().then((value) async {
      final twitterAuthCredential = TwitterAuthProvider.credential(accessToken: value.authToken!, secret: value.authTokenSecret!);

      await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential).then((value) async {
        CacheHelper.saveData(key: "userTwitterPicture", value: value.user!.photoURL!);
        CacheHelper.saveData(key: "userTwitterName", value: value.user?.displayName!);
        CacheHelper.saveData(key: "user_id", value: value.user?.uid);
      });
      emit(SignInWithTwitterSuccessful());
    }).catchError((err) {
      emit(SignInWithTwitterFailed(err.toString()));
    });
  }

  Future resetPassword(email) async {
    emit(ResetPasswordLoading());
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      emit(ResetPasswordSuccessful());
    }).catchError((error) {
      emit(ResetPasswordFailed(error.toString()));
    });
  }

  Future signOut(context) async {
      var isSignWith = CacheHelper.getData(key: "isLoginWith");

      emit(SignoutLoading());
      CacheHelper.removeData(
        key: 'user_id',
      ).then((value) async {
          if (isSignWith == "Google") {
            CacheHelper.removeData(
              key: 'isLoginWith',
            ).then((value) async {
                await googleSignIn.disconnect();
                FirebaseAuth.instance.signOut();
            });
          } else if (isSignWith == "fb") {
            CacheHelper.removeData(
              key: 'isLoginWith',
            ).then((value) async {
                CacheHelper.removeData(key: "userFBName");
                CacheHelper.removeData(key: "userFBPicture");
                FirebaseAuth.instance.signOut();
            });
          } else if (isSignWith == "Twitter") {
            CacheHelper.removeData(
              key: 'isLoginWith',
            ).then((value) async {
                CacheHelper.removeData(key: "userTwitterName");
                CacheHelper.removeData(key: "userTwitterPicture");
                FirebaseAuth.instance.signOut();
            });
          } else if (isSignWith == "Native_email") {
            CacheHelper.removeData(
              key: 'isLoginWith',
            ).then((value) async {
                FirebaseAuth.instance.signOut();
            });
          }

          Helper.showCustomSnackBar(
            context, 
            content: "Signout Successfully", 
            bgColor: Colors.green,
            textColor: Colors.white
          );
          navigateAndFinish(
            context,
            AppLayout(),
          );
      });

      emit(SignoutSuccessful());
  }

  int selectedValueOfWhoIs = 5; // Default
  void getSelectedValueOfWhoIs(val)  {
    selectedValueOfWhoIs = val!;
    print(selectedValueOfWhoIs);
    emit(GetSelectedValueOfWhoIs());
  }

}


