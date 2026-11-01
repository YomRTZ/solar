import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentUploadState {
  final String? gstCertificate;
  final String? panCard;
  final String? businessRegistration;
  final String? cancelledCheque;
  final bool isLoading;

  const DocumentUploadState({
    this.gstCertificate,
    this.panCard,
    this.businessRegistration,
    this.cancelledCheque,
    this.isLoading = false,
  });

  DocumentUploadState copyWith({
    String? gstCertificate,
    String? panCard,
    String? businessRegistration,
    String? cancelledCheque,
    bool clearGstCertificate = false,
    bool clearPanCard = false,
    bool clearBusinessRegistration = false,
    bool clearCancelledCheque = false,
    bool? isLoading,
  }) => DocumentUploadState(
    gstCertificate:
        clearGstCertificate ? null : gstCertificate ?? this.gstCertificate,
    panCard: clearPanCard ? null : panCard ?? this.panCard,
    businessRegistration: clearBusinessRegistration
        ? null
        : businessRegistration ?? this.businessRegistration,
    cancelledCheque: clearCancelledCheque
        ? null
        : cancelledCheque ?? this.cancelledCheque,
    isLoading: isLoading ?? this.isLoading,
  );
}

class DocumentUploadCubit extends Cubit<DocumentUploadState> {
  DocumentUploadCubit({DocumentUploadState initialState = const DocumentUploadState()})
      : super(initialState);

  void setGstCertificate(String? value) => emit(
    state.copyWith(
      gstCertificate: value,
      clearGstCertificate: value == null,
    ),
  );

  void setPanCard(String? value) => emit(
    state.copyWith(panCard: value, clearPanCard: value == null),
  );

  void setBusinessRegistration(String? value) => emit(
    state.copyWith(
      businessRegistration: value,
      clearBusinessRegistration: value == null,
    ),
  );

  void setCancelledCheque(String? value) => emit(
    state.copyWith(
      cancelledCheque: value,
      clearCancelledCheque: value == null,
    ),
  );

  void setLoading(bool value) => emit(state.copyWith(isLoading: value));
}
