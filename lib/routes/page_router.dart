import 'package:flutter/material.dart';
import 'package:manage_life_app/layout/notifications/notifications_screen.dart';
import 'package:manage_life_app/layout/layout_of_app.dart';
import 'package:manage_life_app/layout/search/search_screen.dart';
import 'package:manage_life_app/layout/tasks_screens/folder_screen.dart';
import 'package:manage_life_app/layout/tasks_screens/list_of_tasks.dart';
import 'package:manage_life_app/layout/tasks_screens/task_items.dart';
import 'package:manage_life_app/layout/tasks_screens/tasks_screen.dart';
import 'package:manage_life_app/routes/argument_bundle.dart';

import 'page_path.dart';

class PageRouter {
  final RouteObserver<PageRoute> routeObserver;

  PageRouter() : routeObserver = RouteObserver<PageRoute>();

  Route<dynamic> getRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PagePath.splashScreen:
        // return _buildRoute(settings, SplashPage());
      case PagePath.onBoardScreen:
        // return _buildRoute(settings, OnBoardPage())
      case PagePath.summeryScreen:
        return _buildRoute(settings, AppLayout());
      case PagePath.notificationScreen:
        return _buildRoute(settings, NotificationScreen(bundle: args as ArgumentBundle));
      case PagePath.tasksScreen:
        return _buildRoute(settings, TasksScreen());
      case PagePath.tasksOfCategoryScreen:
        return _buildRoute(
          settings,
          TaskItems(
            bundle: args as ArgumentBundle,
          ),
        );
      case PagePath.peojectDetailsScreen:
        return _buildRoute(
          settings,
          TaskItems(
            bundle: args as ArgumentBundle,
          ),
        );
      case PagePath.folderScreen:
        return _buildRoute(
          settings,
          FolderScreen(
            bundle: args as ArgumentBundle,
        ),
      ); 
      case PagePath.searchScreen:
        return _buildRoute(
          settings,
          SearchScreen(
            bundle: args as ArgumentBundle,
          ),
        );      
      default:
        return _errorRoute();
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
