import 'package:flutter/cupertino.dart';
import 'package:flutter_template/ui/page/import_questions/import_questions.dart';

import 'page/login/login.dart';
import 'page/main/main.dart';
import 'page/splash/splash.dart';


class AppRoute {
  static String currentPage = splashPage;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String loginPage = "loginPage";

  static const String splashPage = "/";

  static const String mainPage = "mainPage";

  static const String importQuestionsPage = "importQuestionsPage";

  ///路由表配置
  static Map<String, WidgetBuilder> routes = {
    loginPage: (context) {
      final args = ModalRoute.of(context)!.settings.arguments!;
      final popUpAfterSuccess = args as bool;
      return LoginPage(popUpAfterSuccess: popUpAfterSuccess);
    },
    splashPage: (context) => const SplashPage(),
    mainPage: (context) => const MainPage(),
    importQuestionsPage: (context) => ImportQuestionsPage(),
  };
}
