import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_db_api/constants/auth_style.dart';
import 'package:movie_db_api/pages/intro_slider.dart';
import 'package:movie_db_api/provider/google_sign_in.dart';
import 'package:movie_db_api/translation/ceviri.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static late FirebaseAuth auth;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    MyApp.auth = FirebaseAuth.instance;
    MyApp.auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        debugPrint('User oturumu kapalı');
      } else {
        debugPrint(
            'User oturumu açık ${user.email} ve email durumu ${user.emailVerified}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: GetMaterialApp(
        translations: Messages(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'UK'),
        title: 'Movie App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blueGrey,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          scaffoldBackgroundColor: kBackgroundColor,
          //visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreenView(
          navigateRoute: const IntroScreen(),
          duration: 5000,
          imageSize: 200,
          imageSrc: "assets/images/drawer_icon.png",
          text: "MovieDb App",
          textType: TextType.ColorizeAnimationText,
          textStyle: const TextStyle(
            fontSize: 40.0,
          ),
          colors: const [
            Colors.purple,
            Colors.blue,
            Colors.yellow,
            Colors.red,
          ],
          backgroundColor: const Color.fromARGB(255, 50, 50, 93),
        ),
      ),
    );

  }

}
