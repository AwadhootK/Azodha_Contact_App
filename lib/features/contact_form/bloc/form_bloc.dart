import 'dart:async';
import 'dart:math' as math;
import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:azodha_task/models/contact_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  FormBloc() : super(FormInitial()) {
    on<ImageFromFile>(getImageFromFileState);
    on<ImageFromCamera>(getImageFromCameraState);
    on<ImageFromURL>(getImageFromURLState);
    on<ResetImage>(
      (event, emit) => emit(FormInitial()),
    );
    on<SubmitForm>(submitForm);
    on<FormUpdate>(updateForm);
  }

  String generateRandomId() {
    var random = math.Random();
    var id = random.nextInt(1 << 32).toRadixString(16);
    var timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(16);
    return '$timestamp-$id';
  }

  FutureOr<void> getImageFromFileState(
      ImageFromFile event, Emitter<FormState> emit) {
    log('getting image from file');
    emit(GetImageFromFileState());
  }

  FutureOr<void> getImageFromCameraState(
      ImageFromCamera event, Emitter<FormState> emit) {
    log('getting image from camera');
    emit(GetImageFromCameraState());
  }

  FutureOr<void> getImageFromURLState(
      ImageFromURL event, Emitter<FormState> emit) {
    log('getting image from URL');
    emit(GetImageFromURLState());
  }

  FutureOr<void> submitForm(SubmitForm event, Emitter<FormState> emit) async {
    emit(FormLoadingState());
    Map<String, dynamic> contactDetails = {
      'documentID': generateRandomId(),
      'name': event.name,
      'email': event.email,
      'phone': event.phone,
      'address': event.address,
      'image': event.image,
      'imageType': event.imageType,
    };

    try {
      if (event.name.isEmpty) {
        throw 'Please enter your name';
      }
      DocumentReference contacts =
          firestore.collection('contacts').doc(contactDetails['documentID']);
      await contacts.set(contactDetails);
      emit(FormSubmitSuccess(contactDetails['name']!));
    } catch (e) {
      log(e.toString());
      emit(FormErrorState(e.toString()));
    }
  }

  FutureOr<void> updateForm(FormUpdate event, Emitter<FormState> emit) async {
    emit(FormLoadingState());
    Map<String, dynamic> contactDetails = {
      'documentID': event.documentID,
      'name': event.name,
      'email': event.email,
      'phone': event.phone,
      'address': event.address,
      'image': event.image,
      'imageType': event.imageType,
    };

    log(contactDetails.toString());

    log(contactDetails.toString());

    try {
      if (event.name.isEmpty) {
        throw 'Please enter your name';
      }
      DocumentReference contacts =
          firestore.collection('contacts').doc(event.documentID);
      await contacts.update(contactDetails);
      emit(FormSubmitSuccess(contactDetails['name']!));
    } catch (e) {
      log(e.toString());
      emit(FormErrorState(e.toString()));
    }
  }
}
