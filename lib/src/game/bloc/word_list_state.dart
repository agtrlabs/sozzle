part of 'word_list_bloc.dart';

@immutable
abstract class WordListState {}

class WordListInitial extends WordListState {}

class WordListFetching extends WordListState {}

class WordListLoaded extends WordListState {}
