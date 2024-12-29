import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_project/Feature/Auth/Provider/pointDetail_provider.dart';
import 'package:retail_project/Feature/Auth/Provider/pointtrans_provider.dart';
import 'package:retail_project/Feature/Auth/Provider/qr_result_provider.dart';
import 'package:retail_project/Feature/Auth/Provider/redeem_provider.dart';
import 'Feature/Auth/Provider/change_provider.dart';
import 'Feature/Auth/Provider/forgot_provider.dart';
import 'Feature/Auth/Provider/login_provider.dart';
import 'Feature/Auth/Screen/Splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ChangeProvider()),
        ChangeNotifierProvider(create: (_) => ForgotProvider()),
        ChangeNotifierProvider(create: (_) => QrResultProvider()),
        ChangeNotifierProvider(create: (_) => PointtransProvider()),
        ChangeNotifierProvider(create: (_) => PointDetailProvider()),
        // ChangeNotifierProvider(create: (_) => RedeemProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: FToastBuilder(),
        home: SplashScreen(),
      ),
    );
  }
}
