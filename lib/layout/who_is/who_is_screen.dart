import 'package:flutter/material.dart';
import 'package:manage_life_app/modules/widgets/state_widgets.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/gradiant_button.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/extensions.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';

class WhoIs extends StatelessWidget {
  const WhoIs({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ThinkingWidget(),
              Text(
                "Who are You?",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20,),
              whoAreYouBuilder(context, "Default"),
              SizedBox(height: 15,),
              Container(
                height: 50,
                width: 150,
                child: RaisedGradientButton(
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                    ),
                  ),
                  gradient: LinearGradient(
                    colors: <Color>[mainColor, Colors.deepPurpleAccent],
                  ),
                  onPressed: (){
                    
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}