import 'package:flutter_bloc/flutter_bloc.dart';

class MarketplaceNavigationState {
  final int selectedTab;

  const MarketplaceNavigationState({this.selectedTab = 0});
}

class MarketplaceNavigationCubit extends Cubit<MarketplaceNavigationState> {
  MarketplaceNavigationCubit({int initialTab = 0})
    : super(MarketplaceNavigationState(selectedTab: initialTab));

  void selectTab(int index) =>
      emit(MarketplaceNavigationState(selectedTab: index));
}
