import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:manage_life_app/models/notification_model.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/routes/argument_bundle.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatelessWidget {
  
  final ArgumentBundle bundle;

  const NotificationScreen({ Key? key, required this.bundle }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? payload = bundle.extras;
    print(payload);

    var notifications;


    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var appCubit = AppCubit.get(context);
        if(payload != null) {
          appCubit.makeNotificationOpend(context, payload);
          payload = null; // to prevent run makeNotificationOpend every time (Just once)
        }
        
        notifications = appCubit.notifications;
        
        // if(payload != null) appCubit.makeNotificationOpend(payload);

        return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.grey,
          elevation: .3,
          leading: TextButton(
            child: Icon(
              Icons.done,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(AppLocalizations.of(context)!.notifications),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ConditionalBuilder(
                      condition: state is! GettingNotificationsLoading || state is! NotificationsOpendIsLoading,
                      builder: (context) => Container(
                        child: ConditionalBuilder(
                          condition: notifications.length != 0,
                          builder: (context) => Column(
                            children: List.generate(
                              notifications.length,
                                  (index) {
                                return _notificationBuilder(context, notifications[index]);
                              },
                            ),
                          ),
                          fallback: (context) => Center(
                            child: SvgPicture.asset(Resources.empty, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .75,),),
                        ),
                      ),
                      fallback: (context) => Center(child: CircularProgressIndicator(color: mainColor,), heightFactor: 15,),
                    ),
            ),
          ),
        ),
      );
      }
    );
  }

  Widget _notificationBuilder(context, NotificationModel model) { 
    DateTime today = new DateTime.now();
    late String? currentDay = new DateFormat('dd, MMMM yyyy').format(today).toString();
    String dateContent;
    print(currentDay);
    print(model.start_date);

    if(model.start_date != currentDay) {
      dateContent = AppLocalizations.of(context)!.daysAgo;
    } else {
      dateContent = AppLocalizations.of(context)!.today;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.alarm,
              color: Colors.green,
            ),
            SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title!,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5,),
                Text(
                  dateContent,
                  // dateContent + " . " + model.tag_notification,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      size: 16,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8,),
                    Container(
                      // width: MediaQuery.of(context).size.width * .70,
                      child: Text(
                        model.start_date + " -> " + model.end_date,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            IconButton(onPressed: () {
              DatabaseHelper.instance.deleteFromTable(
                  "notifications", model.id
              ).then((value) {
                AppCubit.get(context).getNotifications(context);
                Helper.showCustomSnackBar(context, content: AppLocalizations.of(context)!.noficicationDeleted, bgColor: Colors.red, textColor: Colors.white);
              });
            }, icon: Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            )),
          ],
        ),
        SizedBox(height: 20,),
        Divider(),
      ],
    );
  }
}