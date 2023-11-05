import 'dart:async';
import 'dart:developer';

import 'package:azodha_task/models/contact_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<HomeInitialEvent>(homeInitial);
    on<HomeNavigateToContactDetailsEvent>(homeNavigateToContactDetails);
    on<HomeNavigateToContactFormEvent>(homeNavigateToContactForm);
  }

  FutureOr<void> homeInitial(HomeInitialEvent event, Emitter<HomeState> emit) {
    log('HomeInitialState');
    emit(HomeInitialState());
  }

  FutureOr<void> homeNavigateToContactDetails(
      HomeNavigateToContactDetailsEvent event, Emitter<HomeState> emit) {
    log('HomeNavigateToContactDetailsState');
    emit(HomeNavigateToContactDetailsState());
  }

  FutureOr<void> homeNavigateToContactForm(
      HomeNavigateToContactFormEvent event, Emitter<HomeState> emit) {
    log('HomeNavigateToContactFormState');
    emit(HomeNavigateToContactFormState());
  }
}
