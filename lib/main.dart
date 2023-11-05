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
        primarySwatch: Colors.cyan,
      ),
      home: BlocProvider(
        create: (context) => HomeBloc(),
        child: const ContactHomePage(),
      ),
    );
  }
}
