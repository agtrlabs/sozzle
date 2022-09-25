import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'word_list_event.dart';
part 'word_list_state.dart';

class WordListBloc extends Bloc<WordListEvent, WordListState> {
  WordListBloc() : super(WordListInitial()) {
    on<WordListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
