import 'dart:async';

import 'package:eatziffy/models/categories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesState._());

  @override
  Stream<CategoriesState> mapEventToState(
    CategoriesEvent event,
  ) async* {}
}
