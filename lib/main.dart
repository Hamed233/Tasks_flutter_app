import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:manage_life_app/api/notification_api.dart';
import 'package:manage_life_app/l10n/l10n.dart';
import 'package:manage_life_app/layout/account_screen/account_screen.dart';
import 'package:manage_life_app/layout/login/login_screen.dart';
import 'package:manage_life_app/layout/notifications/notifications_screen.dart';
import 'package:manage_life_app/layout/layout_of_app.dart';
import 'package:manage_life_app/layout/onboard_screen/onboard_screen.dart';
import 'package:manage_life_app/layout/register/register_screen.dart';
import 'package:manage_life_app/layout/tasks_screens/tasks_screen.dart';
import 'package:manage_life_app/layout/who_is/who_is_screen.dart';
import 'package:manage_life_app/providers/helpers/service_locator.dart';
import 'package:manage_life_app/providers/locale_provider.dart';
import 'package:manage_life_app/providers/pomodoro_bloc/pomodoro_cubit.dart';
import 'package:manage_life_app/providers/project_bloc/project_cubit.dart';
import 'package:manage_life_app/routes/argument_bundle.dart';
import 'package:manage_life_app/providers/bloc_observer.dart';
import 'package:manage_life_app/providers/event_provider.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/note_bloc/note_bloc.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/routes/page_path.dart';
import 'package:manage_life_app/routes/page_router.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/exceptions/api_exception.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'providers/general_app_cubit/app_general_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  // await AndroidAlarmManager.initialize();
  await CacheHelper.init();
  NotificationAPI.init();
  tz.initializeTimeZones();
  listenNotification();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  ); 
  
  bool? isDark = CacheHelper.getData(key: 'isDark');
  var onBoarding = CacheHelper.getData(key: 'onBoarding');

  Widget widget = AppLayout();
  // widget = onBoarding != null ? AppLayout() : OnBoardingScreen();
  
  setUpLocators();

  runApp(MyApp(
      startWidget: widget,
      isDark: isDark
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void listenNotification() =>
          NotificationAPI.onNotifications.stream.listen(onClickedNotification);

void onClickedNotification(String? payload) => navigatorKey.currentState?.pushNamed(PagePath.notificationScreen, arguments: ArgumentBundle(extras: payload));

const myTask = "TestTask";
 
void callbackDispatcher() {
  Workmanager().executeTask((task, inputdata) async {
    switch (task) {
      case myTask:
          NotificationAPI.showNotification(
            title: "test",
            body: "Hello Noor",
            payload: 'sarah.abs', // user identifir
         );
        print("Task now!" + myTask);
        break;
 
      case Workmanager.iOSBackgroundTask:
        print("iOS background fetch delegate ran");
        break;
    }
 
    //Return true when the task executed successfully or not
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  
  late final PageRouter _router;

  MyApp({this.isDark, this.startWidget}) : _router = PageRouter() {
    initLogger();
  }
  final Widget? startWidget;
  final bool? isDark;

  // MyApp({
  //   this.startWidget,
  //   this.isDark
  // });
            
            
  @override
  Widget build(BuildContext context) {
        var userId = CacheHelper.getData(key: "user_id");
        return ChangeNotifierProvider(
          create: (context) => LocaleProvider(),
          builder: (context, child) {
            final provider = Provider.of<LocaleProvider>(context);
            return MultiBlocProvider(
            providers: [
              BlocProvider<AppCubit>(
                create: (BuildContext context) => AppCubit()..changeAppMode(
                  fromShared: isDark,
                )..getNotifications(context)..userInfo(userId),
              ),
              
              BlocProvider<TaskCubit>(
                create: (context) => TaskCubit()..getTaskList(sortBy: CacheHelper.getData(key: "sortType"))..getFoldersList(),
              ),
              BlocProvider<NoteBloc>(
                create: (context) => NoteBloc()..getNotesList()..getArchivedNotesList(),
              ),
              BlocProvider<ProjectCubit>(
                create: (context) => ProjectCubit()..getProjectsList()..getArchivedProjectsList(),
              ),
              BlocProvider<PomodoroCubit>(
                create: (context) => PomodoroCubit()..userPomodoroSettings(CacheHelper.getData(key: "user_id") != null ? CacheHelper.getData(key: "user_id") : "guest"),
              ),
               
            ],
            child: BlocConsumer<AppCubit, AppStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: MaterialApp(
                    // title: "Tasks",
                    debugShowCheckedModeBanner: false,
                    locale: CacheHelper.getData(key: "current_lang") != null ? Locale(CacheHelper.getData(key: "current_lang")) : provider.locale,
                    supportedLocales: L10n.all,
                    onGenerateTitle: (context) { 
                      return AppLocalizations.of(context)!.appName;
                    },
                    localizationsDelegates: [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: AppCubit
                        .get(context)
                        .isDark ? ThemeMode.dark : ThemeMode.light,
                    onGenerateRoute: _router.getRoute,
                    navigatorObservers: [_router.routeObserver],
                    navigatorKey: navigatorKey,
                  ),
                );
              },
            ),
          
          );
          }
        );
  }

  void initLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      dynamic e = record.error;
      String m = e is APIException ? e.message : e.toString();
      print(
          '${record.loggerName}: ${record.level.name}: ${record.message} ${m != 'null' ? m : ''}');
    });
    Logger.root.info("Logger initialized.");
  }
}
