
  import 'package:get_it/get_it.dart';
import 'package:manage_life_app/models/user_model.dart';

GetIt sl = GetIt.instance;

void setUpLocators() {
  sl.registerSingleton<UserModel>(UserModel(),
      signalsReady: true);
}