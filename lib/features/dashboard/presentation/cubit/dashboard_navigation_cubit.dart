import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardNavigationState {
  final int selectedTab;
  const DashboardNavigationState({this.selectedTab = 0});
}

class DashboardNavigationCubit extends Cubit<DashboardNavigationState> {
  DashboardNavigationCubit({int initialTab = 0})
    : super(DashboardNavigationState(selectedTab: initialTab));

  void selectTab(int index) =>
      emit(DashboardNavigationState(selectedTab: index));
}
