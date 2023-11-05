import 'dart:async';
import 'dart:developer';

import 'package:azodha_task/models/contact_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'contact_details_event.dart';
part 'contact_details_state.dart';

class ContactDetailsBloc
    extends Bloc<ContactDetailsEvent, ContactDetailsState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ContactDetailsBloc() : super(ContactDetailsInitial()) {
    on<ContactDetailsLoadEvent>(loadContactDetails);
    on<ContactDetailsDelete>(deleteContact);
  }

  FutureOr<void> loadContactDetails(
      ContactDetailsLoadEvent event, Emitter<ContactDetailsState> emit) async {
    try {
      emit(ContactDetailsLoadingState());
      List<Contact> contacts = [];
      final data = await firestore.collection('contacts').get();
      for (var element in data.docs) {
        contacts.add(Contact.fromJson(element.data()));
      }
      emit(ContactDetailsLoadState(contacts));
    } catch (e) {
      emit(ContactDetailsErrorState(e.toString()));
    }
  }

  FutureOr<void> deleteContact(
      ContactDetailsDelete event, Emitter<ContactDetailsState> emit) async {
    try {
      emit(ContactDetailsLoadingState());
      await firestore.collection('contacts').doc(event.documentID).delete();
      emit(ContactDeleteSuccessState(event.documentID));
    } catch (e) {
      emit(ContactDetailsErrorState(e.toString()));
    }
  }
}
