part of 'form_bloc.dart';

@immutable
sealed class FormEvent {}

@immutable
sealed class FormGetImageEvent extends FormEvent {}

class ResetImage extends FormEvent {}

class ImageFromFile extends FormEvent {}

class ImageFromCamera extends FormEvent {}

class ImageFromURL extends FormEvent {}

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
