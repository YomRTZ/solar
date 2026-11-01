import 'package:flutter_bloc/flutter_bloc.dart';

enum PlanType { trial, yearly }

class PlanSelectionCubit extends Cubit<PlanType> {
  PlanSelectionCubit() : super(PlanType.trial);

  void select(PlanType plan) => emit(plan);
}
