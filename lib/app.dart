import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seaoil/core/services/state_controller.dart';
import 'package:seaoil/core/themes/custom_theme_data.dart';
import 'package:seaoil/core/widgets/adaptive.dart';
import 'package:seaoil/features/home/home.dart';
import 'package:seaoil/features/login/login.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData? themeData;

  void _setup() {
    themeData = CustomThemeData.build();
  }

  @override
  void initState() {
    _setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Seaoil Exam',
      theme: themeData,
      home: GetBuilder<StateController>(
        init: StateController(),
        initState: (GetBuilderState<StateController> state) =>
            AdaptiveActivityIndicator(),
        builder: (StateController controller) {
          return Obx(
            () => controller.isLoggedIn.value ? HomePage() : LoginPage(),
          );
        },
      ),
    );
  }
}
