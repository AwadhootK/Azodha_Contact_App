import 'dart:async';
import 'dart:developer'; 

import 'package:azodha_task/models/contact_model.dart'; 
import 'package:bloc/bloc.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'contact_details_event.dart'; 
part 'contact_details_state.dart'; 

class ContactDetailsBloc extends Bloc<ContactDetailsEvent, ContactDetailsState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance; // Instance of Firebase Cloud Firestore

  // Constructor for the ContactDetailsBloc class
  ContactDetailsBloc() : super(ContactDetailsInitial()) {
    // Defining event handlers for different events
    on<ContactDetailsLoadEvent>(loadContactDetails); // Handler for loading contact details
    on<ContactDetailsDelete>(deleteContact); // Handler for deleting a contact
    on<NavigateToContactDetails>(
      (event, emit) => emit(
        NavigateToContactDetailsState(event.contact),
      ),
    );
    on<SaveIndexToLocalStorage>(saveIndexToLocalStorage); // Handler for saving index to local storage
  }

  // Method for loading contact details
  FutureOr<void> loadContactDetails(
      ContactDetailsLoadEvent event, Emitter<ContactDetailsState> emit) async {
    try {
      emit(ContactDetailsLoadingState()); // Emitting loading state
      List<Contact> contacts = [];
      final data = await firestore.collection('contacts').get();
      for (var element in data.docs) {
        contacts.add(Contact.fromJson(element.data()));
      }
      log('documents successfully loaded'); // Logging successful loading
      emit(ContactDetailsLoadState(contacts)); // Emitting loaded contacts
    } catch (e) {
      emit(ContactDetailsErrorState('Something went wrong...')); // Emitting error state
    }
  }

  // Method for deleting a contact
  FutureOr<void> deleteContact(
      ContactDetailsDelete event, Emitter<ContactDetailsState> emit) async {
    try {
      emit(ContactDetailsLoadingState()); // Emitting loading state
      await firestore.collection('contacts').doc(event.documentID).delete();
      log('document successfully deleted'); // Logging successful deletion
      emit(ContactDeleteSuccessState(event.documentID)); // Emitting success state for deletion
    } catch (e) {
      emit(ContactDetailsErrorState('Something went wrong...')); // Emitting error state
    }
  }

  // Method for saving index to local storage
  FutureOr<void> saveIndexToLocalStorage(
      SaveIndexToLocalStorage event, Emitter<ContactDetailsState> emit) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('index', event.index); // Saving index to shared preferences
  }
}
