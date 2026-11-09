import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_rfq_request.dart';

enum RfqRequestFilter { all, received, pending }

class RfqRequestListCubit extends Cubit<RfqRequestFilter> {
  RfqRequestListCubit() : super(RfqRequestFilter.all);

  void select(RfqRequestFilter filter) => emit(filter);

  List<CatalogRfqRequest> filterRequests(List<CatalogRfqRequest> requests) {
    switch (state) {
      case RfqRequestFilter.all:
        return requests;
      case RfqRequestFilter.received:
        return requests
            .where((request) => request.status == CatalogRfqStatus.received)
            .toList();
      case RfqRequestFilter.pending:
        return requests
            .where((request) => request.status == CatalogRfqStatus.pending)
            .toList();
    }
  }
}
