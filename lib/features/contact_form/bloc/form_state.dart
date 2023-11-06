part of 'form_bloc.dart';

@immutable
sealed class FormState {}

@sealed
class FormActionState extends FormState {}

// Simple States
// Initial state for the form
final class FormInitial extends FormState {}

// State representing form loading
final class FormLoadingState extends FormState {}

// State representing form error
final class FormErrorState extends FormState {
  final String message;

  FormErrorState(this.message);
}

// State representing image upload loading
final class FormImageUploadLoadingState extends FormState {}

// Action States
// State representing getting image from file
final class GetImageFromFileState extends FormActionState {
  final String base64String;

  GetImageFromFileState(this.base64String);
}

// State representing getting image from camera
final class GetImageFromCameraState extends FormActionState {
  final String firebaseURL;

  GetImageFromCameraState(this.firebaseURL);
}

// State representing getting image from URL
final class GetImageFromURLState extends FormActionState {}

// State representing loaded image URL
final class ImageURLLoadedState extends FormActionState {
  final String imageURL;

  ImageURLLoadedState(this.imageURL);
}

// State representing form submission
final class FormSubmit extends FormActionState {}

// State representing successful form submission
final class FormSubmitSuccess extends FormActionState {
  final String documentID;

  FormSubmitSuccess(this.documentID);
}

// State representing successful form update
final class FormUpdateSuccess extends FormActionState {}
