import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app_trail/provider/favourite_provider.dart';
import 'package:recipe_app_trail/provider/quantity_provider.dart';
import 'package:recipe_app_trail/views/app_main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //for favorite providers
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
        // for quantity provider
        ChangeNotifierProvider(create: (_) => QuantityProvider()),
      ],
      child: MaterialApp(
        // theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: AppMainScreen(),
      ),
    );
  }
}
