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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Home Page'),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (previous, current) => current is HomeActionState,
        listener: (context, state) {
          if (state is HomeNavigateToContactDetailsState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ContactDetailsBloc(),
                  child: const ContactDetailsList(),
                ),
              ),
            );
          } else if (state is HomeNavigateToContactFormState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => FormBloc(),
                  child: ContactForm(),
                ),
              ),
            );
          }
        },
        buildWhen: (previous, current) => current is! HomeActionState,
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(
                          HomeNavigateToContactDetailsEvent(),
                        );
                  },
                  child: const Text('Contact List'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(
                          HomeNavigateToContactFormEvent(),
                        );
                  },
                  child: const Text('Add Contact'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
