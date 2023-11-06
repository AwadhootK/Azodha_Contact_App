import 'dart:async';
import 'dart:developer';

import 'package:azodha_task/models/contact_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'contact_details_event.dart';
part 'contact_details_state.dart';

class ContactDetailsBloc
    extends Bloc<ContactDetailsEvent, ContactDetailsState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ContactDetailsBloc() : super(ContactDetailsInitial()) {
    on<ContactDetailsLoadEvent>(loadContactDetails);
    on<ContactDetailsDelete>(deleteContact);
    on<NavigateToContactDetails>(
      (event, emit) => emit(
        NavigateToContactDetailsState(event.contact),
      ),
    );
    on<SaveIndexToLocalStorage>(saveIndexToLocalStorage);
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
      log('documents successfully loaded');
      emit(ContactDetailsLoadState(contacts));
    } catch (e) {
      emit(ContactDetailsErrorState('Something went wrong...'));
    }
  }

  FutureOr<void> deleteContact(
      ContactDetailsDelete event, Emitter<ContactDetailsState> emit) async {
    try {
      emit(ContactDetailsLoadingState());
      await firestore.collection('contacts').doc(event.documentID).delete();
      log('document successfully deleted');
      emit(ContactDeleteSuccessState(event.documentID));
    } catch (e) {
      emit(ContactDetailsErrorState('Something went wrong...'));
    }
  }

  FutureOr<void> saveIndexToLocalStorage(
      SaveIndexToLocalStorage event, Emitter<ContactDetailsState> emit) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('index', event.index);
  }
}
