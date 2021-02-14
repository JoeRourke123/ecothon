import 'package:ecothon/pages/main_screen.dart';
import 'package:ecothon/stores/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	final storage = new FlutterSecureStorage();
	await storage.write(key: "userID", value: "60272635d291d62ede060f8e");
	await storage.write(key: "token", value: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6IjYwMjcyNjM1ZDI5MWQ2MmVkZTA2MGY4ZSIsImV4cCI6MTYyMDQ4MjEyOH0.X8yZ0QjU8s4aoLN38pfMidCm6-FV1Qpht3F9SXhPKmE");

	AuthStore authStore = AuthStore(
		await storage.read(key: "userID"),
		await storage.read(key: "token")
	);
	await authStore.getUserDetails();

	runApp(MultiProvider(
		providers: [
			ChangeNotifierProvider(create: (context) => authStore),
		],
		child: EcothonApp(loggedIn: authStore.isLoggedIn,),
	));
}

class EcothonApp extends StatelessWidget {
	final bool loggedIn;

  const EcothonApp({Key key, this.loggedIn}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ecothon",
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
				textTheme: GoogleFonts.poppinsTextTheme()
      ),
      home: MainScreen()
    );
  }
}
