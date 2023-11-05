part of 'form_bloc.dart';

@immutable
sealed class FormState {}

@sealed
class FormActionState extends FormState {}

// Simple States
final class FormInitial extends FormState {}

final class FormLoadingState extends FormState {}

final class FormErrorState extends FormState {
  final String message;

  FormErrorState(this.message);
}

final class FormImageUploadLoadingState extends FormState {}

// Action States
final class GetImageFromFileState extends FormActionState {
  final String base64String;

  GetImageFromFileState(this.base64String);
}

final class GetImageFromCameraState extends FormActionState {
  final String firebaseURL;

  GetImageFromCameraState(this.firebaseURL);
}

final class GetImageFromURLState extends FormActionState {}

final class ImageURLLoadedState extends FormActionState {
  final String imageURL;

  ImageURLLoadedState(this.imageURL);
}

final class FormSubmit extends FormActionState {}

final class FormSubmitSuccess extends FormActionState {
  final String documentID;

  FormSubmitSuccess(this.documentID);
}

final class FormUpdateSuccess extends FormActionState {}
