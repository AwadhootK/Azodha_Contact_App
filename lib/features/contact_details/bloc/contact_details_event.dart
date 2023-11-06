part of 'contact_details_bloc.dart';

@immutable
sealed class ContactDetailsEvent {}

class ContactDetailsInitialEvent extends ContactDetailsEvent {}

class ContactDetailsLoadEvent extends ContactDetailsEvent {}

class NavigateToContactDetails extends ContactDetailsEvent {
  final Contact contact;

  NavigateToContactDetails(this.contact);
}

class ContactDetailsUpdate extends ContactDetailsEvent {
  final Contact contact;

  ContactDetailsUpdate(this.contact);
}

class ContactDetailsDelete extends ContactDetailsEvent {
  final String documentID;

  ContactDetailsDelete(this.documentID);
}

class SaveIndexToLocalStorage extends ContactDetailsEvent {
  final int index;

  SaveIndexToLocalStorage(this.index);
}