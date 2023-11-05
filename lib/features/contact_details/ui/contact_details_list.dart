import 'dart:developer';

import 'package:azodha_task/features/contact_details/bloc/contact_details_bloc.dart';
import 'package:azodha_task/features/contact_details/ui/widgets/contact_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../contact_form/bloc/form_bloc.dart';
import '../../contact_form/ui/contact_form.dart';

class ContactDetailsList extends StatelessWidget {
  const ContactDetailsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => FormBloc(),
                    child: ContactForm(),
                  ),
                ),
              );
              context.read<ContactDetailsBloc>().add(
                    ContactDetailsLoadEvent(),
                  );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ContactDetailsBloc>().add(
                ContactDetailsLoadEvent(),
              );
        },
        child: const Icon(Icons.refresh),
      ),
      body: BlocConsumer<ContactDetailsBloc, ContactDetailsState>(
        // listenWhen: (previous, current) => current is ContactDetailsActionState,
        listener: (context, state) {
          log('in listener state: $state');
          if (state is ContactDetailsInitial) {
            context.read<ContactDetailsBloc>().add(
                  ContactDetailsLoadEvent(),
                );
          } else if (state is NavigateToContactDetailsState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ContactDetailsBloc(),
                  child: const ContactDetailsList(),
                ),
              ),
            );
          } else if (state is ContactDetailsUpdateState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ContactDetailsBloc(),
                  child: const ContactDetailsList(),
                ),
              ),
            );
          } else if (state is ContactDetailsDeleteState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ContactDetailsBloc(),
                  child: const ContactDetailsList(),
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
          }
        },
        // buildWhen: (previous, current) => current is! ContactDetailsActionState,
        builder: (context, state) {
          log('in builder state: $state');
          //! figure out why this isn't working in listener
          if (state is ContactDetailsInitial) {
            context.read<ContactDetailsBloc>().add(
                  ContactDetailsLoadEvent(),
                );
          }
          if (state is ContactDetailsLoadState) {
            if (state.contacts.isEmpty) {
              return const Center(
                child: Text('No Contacts'),
              );
            }
            return ContactDetailsListTile(
              contacts: state.contacts,
              contactDetailsBloc: context.read<ContactDetailsBloc>(),
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
