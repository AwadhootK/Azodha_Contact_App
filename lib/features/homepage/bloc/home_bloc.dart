import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart'; 
import 'package:meta/meta.dart';

part 'home_event.dart'; 
part 'home_state.dart';

// Class definition for the HomeBloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // Constructor for the HomeBloc class
  HomeBloc() : super(HomeInitialState()) {
    // Defining event handlers for different events
    on<HomeInitialEvent>(homeInitial); // Handler for HomeInitialEvent
    on<HomeNavigateToContactDetailsEvent>(
        homeNavigateToContactDetails); // Handler for HomeNavigateToContactDetailsEvent
    on<HomeNavigateToContactFormEvent>(
        homeNavigateToContactForm); // Handler for HomeNavigateToContactFormEvent
  }

  // Event handler for the HomeInitialEvent
  FutureOr<void> homeInitial(HomeInitialEvent event, Emitter<HomeState> emit) {
    log('HomeInitialState'); // Logging the state transition
    emit(HomeInitialState()); // Emitting the HomeInitialState
  }

  // Event handler for the HomeNavigateToContactDetailsEvent
  FutureOr<void> homeNavigateToContactDetails(
      HomeNavigateToContactDetailsEvent event, Emitter<HomeState> emit) {
    log('HomeNavigateToContactDetailsState'); // Logging the state transition
    emit(
        HomeNavigateToContactDetailsState()); // Emitting the HomeNavigateToContactDetailsState
  }

  // Event handler for the HomeNavigateToContactFormEvent
  FutureOr<void> homeNavigateToContactForm(
      HomeNavigateToContactFormEvent event, Emitter<HomeState> emit) {
    log('HomeNavigateToContactFormState'); // Logging the state transition
    emit(
        HomeNavigateToContactFormState()); // Emitting the HomeNavigateToContactFormState
  }
}
