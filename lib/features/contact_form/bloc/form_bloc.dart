import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:azodha_task/models/contact_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    on<ImageFromURLLoaded>(
      (event, emit) => emit(
        ImageURLLoadedState(event.imageURL),
      ),
    );
    on<EditFormImageFromFileLoaded>((event, emit) => emit(
          GetImageFromFileState(event.base64String),
        ));

    on<EditFormImageFromCameraLoaded>((event, emit) => emit(
          GetImageFromCameraState(event.firebaseURL),
        ));
  }

  String generateRandomId() {
    var random = math.Random();
    var id = random.nextInt(1 << 32).toRadixString(16);
    var timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(16);
    return '$timestamp-$id';
  }

  FutureOr<void> getImageFromFileState(
      ImageFromFile event, Emitter<FormState> emit) async {
    log('getting image from file');
    emit(FormImageUploadLoadingState());
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    String base64String = '';
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      base64String = base64UrlEncode(imageBytes);
    }
    emit(GetImageFromFileState(base64String));
  }

  FutureOr<void> getImageFromCameraState(
      ImageFromCamera event, Emitter<FormState> emit) async {
    log('getting image from camera');
    emit(FormImageUploadLoadingState());
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    String downloadUrl = '';
    if (image != null) {
      File file = File(image.path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('uploads/${DateTime.now().millisecondsSinceEpoch}.png');
      firebase_storage.UploadTask uploadTask = ref.putFile(file);
      try {
        await uploadTask;
        downloadUrl = await ref.getDownloadURL();
        log('Firebase URL: $downloadUrl');
      } on firebase_storage.FirebaseException catch (e) {
        print(e.message);
      }
    } else {
      downloadUrl = '';
      log('No image selected.');
    }
    emit(GetImageFromCameraState(downloadUrl));
  }

  FutureOr<void> getImageFromURLState(
      ImageFromURL event, Emitter<FormState> emit) {
    log('getting image from URL');
    emit(GetImageFromURLState());
  }

  FutureOr<void> submitForm(SubmitForm event, Emitter<FormState> emit) async {
    emit(FormLoadingState());
    log('submitting form');
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
      log('form successfully uploaded');
      emit(FormSubmitSuccess(contactDetails['name']!));
    } catch (e) {
      log(e.toString());
      emit(FormErrorState('Something went wrong...'));
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

    try {
      if (event.name.isEmpty) {
        throw 'Please enter your name';
      }
      DocumentReference contacts =
          firestore.collection('contacts').doc(event.documentID);
      await contacts.update(contactDetails);
      log('form successfully updated');
      emit(FormSubmitSuccess(contactDetails['name']!));
    } catch (e) {
      log(e.toString());
      emit(FormErrorState('Something went wrong...'));
    }
  }
}
