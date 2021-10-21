part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvent {}

class FetchCategories extends CategoriesEvent {
  final List<CategoriesModel> categories;

  FetchCategories(this.categories);
}
