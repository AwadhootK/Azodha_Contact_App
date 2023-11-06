part of 'contact_details_bloc.dart';

@immutable
// Class representing different states for ContactDetailsBloc
sealed class ContactDetailsState {}

@immutable
// Class representing different action states for ContactDetailsBloc
sealed class ContactDetailsActionState extends ContactDetailsState {}

// Simple States
// Initial state for contact details
final class ContactDetailsInitial extends ContactDetailsState {}

// State representing contact details loading
final class ContactDetailsLoadingState extends ContactDetailsState {}

// State representing loaded contact details
final class ContactDetailsLoadState extends ContactDetailsState {
  final List<Contact> contacts;

  ContactDetailsLoadState(this.contacts);
}

// State representing contact details error
final class ContactDetailsErrorState extends ContactDetailsState {
  final String message;

  ContactDetailsErrorState(this.message);
}

// Action States
// State representing navigation to contact details
final class NavigateToContactDetailsState extends ContactDetailsActionState {
  final Contact contact;

  NavigateToContactDetailsState(this.contact);
}

// State representing contact details update
final class ContactDetailsUpdateState extends ContactDetailsActionState {
  final Contact contact;

  ContactDetailsUpdateState(this.contact);
}

// State representing contact details deletion
final class ContactDetailsDeleteState extends ContactDetailsActionState {
  final String documentID;

  ContactDetailsDeleteState(this.documentID);
}

// State representing successful contact deletion
final class ContactDeleteSuccessState extends ContactDetailsActionState {
  final String documentID;

  ContactDeleteSuccessState(this.documentID);
}
