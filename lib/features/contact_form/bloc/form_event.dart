part of 'form_bloc.dart';

@immutable
sealed class FormEvent {}

@immutable
sealed class FormGetImageEvent extends FormEvent {}

// Event for resetting the image
class ResetImage extends FormEvent {}

// Event for getting image from file
class ImageFromFile extends FormEvent {}

// Event for getting image from camera
class ImageFromCamera extends FormEvent {}

// Event for getting image from URL
class ImageFromURL extends FormEvent {}

// Event for loaded image from URL
class ImageFromURLLoaded extends FormEvent {
  final String imageURL;

  ImageFromURLLoaded(this.imageURL);
}

// Event for editing form with image loaded from file
class EditFormImageFromFileLoaded extends FormEvent {
  final String base64String;

  EditFormImageFromFileLoaded(this.base64String);
}

// Event for editing form with image loaded from camera
class EditFormImageFromCameraLoaded extends FormEvent {
  final String firebaseURL;

  EditFormImageFromCameraLoaded(this.firebaseURL);
}

// Event for submitting the form
class SubmitForm extends FormEvent {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String image;
  final int imageType;

  SubmitForm({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.image,
    required this.imageType,
  });
}

// Event for updating the form
class FormUpdate extends FormEvent {
  final String documentID;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String image;
  final int imageType;

  FormUpdate({
    required this.documentID,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.image,
    required this.imageType,
  });
}
