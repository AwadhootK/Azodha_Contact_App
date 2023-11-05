part of 'contact_details_bloc.dart';

@immutable
sealed class ContactDetailsState {}

@immutable
sealed class ContactDetailsActionState extends ContactDetailsState {}

// Simple States
final class ContactDetailsInitial extends ContactDetailsState {}

final class ContactDetailsLoadingState extends ContactDetailsState {}

final class ContactDetailsLoadState extends ContactDetailsState {
  final List<Contact> contacts;

  ContactDetailsLoadState(this.contacts);
}

final class ContactDetailsErrorState extends ContactDetailsState {
  final String message;

  ContactDetailsErrorState(this.message);
}

// Action States
final class NavigateToContactDetailsState extends ContactDetailsActionState {
  final Contact contact;

  NavigateToContactDetailsState(this.contact);
}

final class ContactDetailsUpdateState extends ContactDetailsActionState {
  final Contact contact;

  ContactDetailsUpdateState(this.contact);
}

final class ContactDetailsDeleteState extends ContactDetailsActionState {
  final String documentID;

  ContactDetailsDeleteState(this.documentID);
}

final class ContactDeleteSuccessState extends ContactDetailsActionState {
  final String documentID;

  ContactDeleteSuccessState(this.documentID);
}
