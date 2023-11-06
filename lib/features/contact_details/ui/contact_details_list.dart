import 'dart:developer';

import 'package:azodha_task/animations/pageRouteAnimation.dart';
import 'package:azodha_task/features/contact_details/bloc/contact_details_bloc.dart';
import 'package:azodha_task/features/contact_details/ui/widgets/contact_details_page.dart';
import 'package:azodha_task/features/contact_details/ui/widgets/contact_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../contact_form/bloc/form_bloc.dart';
import '../../contact_form/ui/contact_form.dart';

class ContactDetailsList extends StatelessWidget {
  const ContactDetailsList({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Contact Cards'),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(h * 0.005),
            child: Card(
              elevation: 5,
              shadowColor: Theme.of(context).colorScheme.background,
              shape: const CircleBorder(),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: IconButton(
                onPressed: () async {
                  await Navigator.of(context).push(
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
                  context.read<ContactDetailsBloc>().add(
                        ContactDetailsLoadEvent(),
                      );
                },
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ContactDetailsBloc>().add(
                ContactDetailsLoadEvent(),
              );
        },
        child: Icon(
          Icons.refresh,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
      body: BlocConsumer<ContactDetailsBloc, ContactDetailsState>(
        listener: (context, state) {
          log('in listener state: $state');
          if (state is ContactDetailsInitial) {
            context.read<ContactDetailsBloc>().add(
                  ContactDetailsLoadEvent(),
                );
          } else if (state is NavigateToContactDetailsState) {
            Navigator.of(context)
                .push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ContactDetailsPage(
                      contact: state.contact,
                    ),
                    transitionDuration: const Duration(milliseconds: 250),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            CustomPageRouteAnimation(
                      child: child,
                      animation: animation,
                    ),
                  ),
                )
                .then((value) => context.read<ContactDetailsBloc>().add(
                      ContactDetailsLoadEvent(),
                    ));
          } else if (state is ContactDetailsUpdateState) {
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
                  child: child,
                  animation: animation,
                ),
              ),
            );
          } else if (state is ContactDetailsDeleteState) {
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
                  child: child,
                  animation: animation,
                ),
              ),
            );
          } else if (state is ContactDeleteSuccessState) {
            context.read<ContactDetailsBloc>().add(
                  ContactDetailsLoadEvent(),
                );
            SnackBar snackBar = SnackBar(
              content: Text('Contact ${state.documentID} Deleted Successfully'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is ContactDetailsErrorState) {
            SnackBar snackBar = SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          if (state is ContactDetailsInitial) {
            context.read<ContactDetailsBloc>().add(
                  ContactDetailsLoadEvent(),
                );
            return Container();
          } else if (state is ContactDetailsLoadState) {
            if (state.contacts.isEmpty) {
              return const Center(
                child: Text('No Contacts'),
              );
            }
            return Padding(
              padding: EdgeInsets.only(
                bottom: h * 0.08,
              ),
              child: ContactDetailsListView(
                contacts: state.contacts,
                contactDetailsBloc: context.read<ContactDetailsBloc>(),
              ),
            );
          } else if (state is ContactDetailsErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is ContactDetailsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
    );
  }
}
