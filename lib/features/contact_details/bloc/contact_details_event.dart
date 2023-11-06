part of 'contact_details_bloc.dart';

@immutable
// Class representing different events for ContactDetailsBloc
sealed class ContactDetailsEvent {}

// Event representing initial state for contact details
class ContactDetailsInitialEvent extends ContactDetailsEvent {}

// Event for loading contact details
class ContactDetailsLoadEvent extends ContactDetailsEvent {}

// Event for navigating to contact details
class NavigateToContactDetails extends ContactDetailsEvent {
  final Contact contact;

  NavigateToContactDetails(this.contact);
}

// Event for updating contact details
class ContactDetailsUpdate extends ContactDetailsEvent {
  final Contact contact;

  ContactDetailsUpdate(this.contact);
}

// Event for deleting contact details
class ContactDetailsDelete extends ContactDetailsEvent {
  final String documentID;

  ContactDetailsDelete(this.documentID);
}

// Event for saving index to local storage
class SaveIndexToLocalStorage extends ContactDetailsEvent {
  final int index;

  SaveIndexToLocalStorage(this.index);
}
