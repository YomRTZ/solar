import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Logs every BLoC/Cubit transition and error to the debug console.
/// Registered in [main] via [Bloc.observer = AppBlocObserver()].
/// Only active in debug builds.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      debugPrint('[BLoC] CREATE  ${bloc.runtimeType}');
    }
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      debugPrint('[BLoC] CLOSE   ${bloc.runtimeType}');
    }
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      debugPrint(
        '[BLoC] CHANGE  ${bloc.runtimeType}\n'
        '       current : ${change.currentState}\n'
        '       next    : ${change.nextState}',
      );
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('[BLoC] ERROR   ${bloc.runtimeType} → $error');
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      debugPrint(
        '[BLoC] EVENT   ${bloc.runtimeType} ← ${transition.event}',
      );
    }
  }
}
