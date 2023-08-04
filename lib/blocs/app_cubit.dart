import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState());

  final showDialogController = PublishSubject<String>();

  @override
  Future<void> close() {
    showDialogController.close();
    return super.close();
  }
}
