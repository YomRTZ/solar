import 'package:flutter_bloc/flutter_bloc.dart';

class HomeNavigationState {
  final int selectedTab;

  const HomeNavigationState({this.selectedTab = 0});
}

class HomeNavigationCubit extends Cubit<HomeNavigationState> {
  HomeNavigationCubit({int initialTab = 0})
    : super(HomeNavigationState(selectedTab: initialTab));

  void selectTab(int index) => emit(HomeNavigationState(selectedTab: index));
}
