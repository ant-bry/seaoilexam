import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seaoil/app.dart';
import 'package:seaoil/config/env.dart';

import 'flutterfire/firebase_options_prod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'flutterboilerplate-prod',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlavorConfig(
      flavor: Flavor.PRODUCTION,
      color: Colors.deepPurpleAccent,
      values:
          FlavorValues(baseUrl: 'https://staging.api.locq.com/ms-profile/'));
  runApp(MyApp());
}
