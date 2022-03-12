import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seaoil/core/utils/strings.dart';
import 'package:seaoil/core/widgets/adaptive.dart';
import 'package:seaoil/features/login/controllers/login_controller.dart';
import 'package:seaoil/gen/assets.gen.dart';
import 'package:seaoil/gen/colors.gen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());
  TextEditingController mobileNumberTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.deepPurple,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 64),
                  Text(
                    Strings.loginUsingYourMobileNumberAndPassword,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade900,
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    Strings.mobileNo,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple.withOpacity(0.2),
                    ),
                    child: Obx(
                      () => TextFormField(
                        enabled: !loginController.isLoading.value,
                        controller: mobileNumberTEC,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Strings.mobileNumberHintText,
                          prefixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(width: 16),
                              Assets.images.phFlag.image(height: 32, width: 32),
                              SizedBox(width: 8),
                              Text(
                                Strings.initialMobileNumberHintText,
                                style: GoogleFonts.roboto(color: Colors.black),
                              ),
                              SizedBox(width: 16),
                            ],
                          ),
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    Strings.password,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple.withOpacity(0.2),
                    ),
                    child: Obx(
                      () => TextFormField(
                        enabled: !loginController.isLoading.value,
                        controller: passwordTEC,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Strings.password,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 36),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 5.0)
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: <double>[0.0, 1.0],
                      colors: <Color>[
                        Colors.deepPurple.shade600,
                        Colors.deepPurple.shade300,
                      ],
                    ),
                    color: Colors.deepPurple.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Obx(
                    () => ElevatedButton(
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        shadowColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: loginController.isLoading.value
                          ? () {}
                          : () => loginController.login(
                                mobNumber:
                                    '${Strings.initialMobileNumberHintText}${mobileNumberTEC.text}',
                                pw: passwordTEC.text,
                                type: 'plc',
                              ),
                      child: loginController.isLoading.value
                          ? AdaptiveActivityIndicator()
                          : Text(
                              Strings.login,
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
