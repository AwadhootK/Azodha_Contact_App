import 'package:azodha_task/animations/pageRouteAnimation.dart';
import 'package:azodha_task/constants/customDecoration.dart';
import 'package:azodha_task/features/contact_details/bloc/contact_details_bloc.dart';
import 'package:azodha_task/features/contact_form/bloc/form_bloc.dart';
import 'package:azodha_task/features/homepage/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../contact_details/ui/contact_details_list.dart';
import '../../contact_form/ui/contact_form.dart';

class ContactHomePage extends StatelessWidget {
  const ContactHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(h * 0.02),
        child: BlocConsumer<HomeBloc, HomeState>(
          listenWhen: (previous, current) => current is HomeActionState,
          listener: (context, state) {
            if (state is HomeNavigateToContactDetailsState) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      BlocProvider(
                    create: (context) => ContactDetailsBloc(),
                    child: const ContactDetailsList(),
                  ),
                  transitionDuration: const Duration(milliseconds: 250),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          CustomPageRouteAnimation(
                              child: child, animation: animation),
                ),
              );
            } else if (state is HomeNavigateToContactFormState) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      BlocProvider(
                    create: (context) => FormBloc(),
                    child: ContactForm(),
                  ),
                  transitionDuration: const Duration(milliseconds: 250),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          CustomPageRouteAnimation(
                    child: child,
                    animation: animation,
                  ),
                ),
              );
            }
          },
          buildWhen: (previous, current) => current is! HomeActionState,
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Spacer(),
                  InkWell(
                    onTap: () {
                      context.read<HomeBloc>().add(
                            HomeNavigateToContactDetailsEvent(),
                          );
                    },
                    child: Container(
                      height: h * 0.15,
                      decoration: CustomDecorations.customDecoration,
                      child: Center(
                        child: Text(
                          'Contact List',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: h * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.08),
                  InkWell(
                    onTap: () {
                      context.read<HomeBloc>().add(
                            HomeNavigateToContactFormEvent(),
                          );
                    },
                    child: Container(
                      height: h * 0.15,
                      decoration: CustomDecorations.customDecoration,
                      child: Center(
                        child: Text(
                          'Add Contact',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: h * 0.03,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
