import 'package:azodha_task/features/homepage/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/homepage/ui/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azodha Contact App',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.cyan.shade700,
          primaryContainer: Colors.cyan.shade800,
          secondary: Colors.deepOrange.shade400,
          secondaryContainer: Colors.deepOrange.shade600,
          surface: Colors.grey.shade50,
          background: Colors.cyan.shade50,
          error: Colors.red.shade800,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.grey.shade800,
          onBackground: Colors.grey.shade800,
          onError: Colors.white,
        ),
      ),
      home: BlocProvider(
        create: (context) => HomeBloc(),
        child: const ContactHomePage(),
      ),
    );
  }
}
