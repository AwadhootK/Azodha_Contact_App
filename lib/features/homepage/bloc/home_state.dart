part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

@immutable
sealed class HomeActionState extends HomeState {}

// Simple States
class HomeInitialState extends HomeState {}

// Action States
class HomeNavigateToContactFormState extends HomeActionState {}

class HomeNavigateToContactDetailsState extends HomeActionState {}

