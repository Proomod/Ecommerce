part of 'categories_bloc.dart';

@immutable
class CategoriesState extends Equatable {
  const CategoriesState._(
      {this.categories = const [],
      this.hasErrors = false,
      this.isLoading = false});

  const CategoriesState.loadingState() : this._(isLoading: true);
  const CategoriesState.errorState() : this._(hasErrors: true);
  final List<CategoriesModel> categories;
  final bool hasErrors;
  final bool isLoading;

  @override
  List<Object?> get props => [categories, hasErrors, isLoading];
}
