import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:recyclean/display_camera.dart';
import 'package:recyclean/pages/activities_page.dart';
import 'package:recyclean/pages/authPages/login_page.dart';
import 'package:recyclean/pages/authPages/register_page.dart';
import 'package:recyclean/pages/home_page.dart';
import 'package:recyclean/pages/new_signal_page.dart';
import 'package:recyclean/widgets/loading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'RECYCLEAN',
    theme: ThemeData(
      colorScheme: ColorScheme.dark(),
      useMaterial3: true,
    ),
    locale: Locale('en'),
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate
    ],
    supportedLocales: [
      Locale('en'),
      Locale('fr'),
    ],
    routes: {
      '/photo': (context) => TakePictureScreen(
            camera: firstCamera,
          ),
    },
    home: FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('une erreur est survenue'),
          );
        } else if (snapshot.hasData) {
          final token = snapshot.data!.getString('token');
          if (token != null) {
            return HomePage();
          } else {
            LoginPage();
          }
        } else {
          return LoginPage();
        }
        return Center(
          child: Text("ERREUR"),
        );
      },
    ),
  ));
}
