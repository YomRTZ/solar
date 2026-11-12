import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/transporter/data/datasources/transporter_data.dart';
import 'package:flutter_app/features/transporter/domain/entities/transporter_job.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class TransporterState {
  final List<TransporterJob> availableJobs;
  final List<TransporterBid> myBids;
  final List<TransporterTrip> upcomingTrips;
  final List<TransporterTrip> pastTrips;

  /// IDs of trips the transporter has OTP-verified (ready to start).
  final Set<String> verifiedTripIds;

  /// ID of the trip currently being delivered (after Start Trip tapped).
  final String? activeDeliveryTripId;

  /// Metrics shown on the dashboard header cards.
  int get newJobsCount => availableJobs.length;
  int get activeTripsCount =>
      upcomingTrips.where((t) => t.canVerify).length;
  int get completedTripsCount => pastTrips.length;

  const TransporterState({
    required this.availableJobs,
    required this.myBids,
    required this.upcomingTrips,
    required this.pastTrips,
    this.verifiedTripIds = const {},
    this.activeDeliveryTripId,
  });

  TransporterState copyWith({
    List<TransporterJob>? availableJobs,
    List<TransporterBid>? myBids,
    List<TransporterTrip>? upcomingTrips,
    List<TransporterTrip>? pastTrips,
    Set<String>? verifiedTripIds,
    String? activeDeliveryTripId,
    bool clearActiveDelivery = false,
  }) {
    return TransporterState(
      availableJobs: availableJobs ?? this.availableJobs,
      myBids: myBids ?? this.myBids,
      upcomingTrips: upcomingTrips ?? this.upcomingTrips,
      pastTrips: pastTrips ?? this.pastTrips,
      verifiedTripIds: verifiedTripIds ?? this.verifiedTripIds,
      activeDeliveryTripId: clearActiveDelivery
          ? null
          : activeDeliveryTripId ?? this.activeDeliveryTripId,
    );
  }
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class TransporterCubit extends Cubit<TransporterState> {
  TransporterCubit()
      : super(
          TransporterState(
            availableJobs: TransporterData.availableJobs(),
            myBids: TransporterData.myBids(),
            upcomingTrips: TransporterData.upcomingTrips(),
            pastTrips: TransporterData.pastTrips(),
          ),
        );

  // ── Jobs ──────────────────────────────────────────────────────────────────

  /// Refreshes available jobs from the data source.
  void refreshJobs() {
    emit(state.copyWith(availableJobs: TransporterData.availableJobs()));
  }

  // ── Bids ──────────────────────────────────────────────────────────────────

  /// Places a new bid on [job] and adds it to myBids with status = requested.
  void placeBid({
    required TransporterJob job,
    required int baseFare,
    required int loadingCharges,
    required int unloadingCharges,
    required int waitingCharges,
    required int tolls,
  }) {
    final newBid = TransporterBid(
      job: job,
      status: TransporterBidStatus.requested,
      timeSinceRequest: 'Just now',
    );
    emit(state.copyWith(myBids: [newBid, ...state.myBids]));
  }

  /// Updates an existing bid's status (e.g. after backend response).
  void updateBidStatus(TransporterJob job, TransporterBidStatus newStatus) {
    final updated = state.myBids.map((bid) {
      if (bid.job.route == job.route && bid.job.date == job.date) {
        return TransporterBid(
          job: bid.job,
          status: newStatus,
          timeSinceRequest: bid.timeSinceRequest,
        );
      }
      return bid;
    }).toList();
    emit(state.copyWith(myBids: updated));
  }

  // ── Trips ─────────────────────────────────────────────────────────────────

  /// Marks a trip as OTP-verified (ready to start).
  void verifyTrip(String tripId) {
    emit(state.copyWith(
      verifiedTripIds: {...state.verifiedTripIds, tripId},
    ));
  }

  /// Sets the active delivery trip when "Start Trip" is tapped.
  void startDelivery(String tripId) {
    emit(state.copyWith(activeDeliveryTripId: tripId));
  }

  /// Confirms delivery — moves the trip from upcoming to past trips.
  void confirmDelivery(String tripId) {
    final trip = state.upcomingTrips.firstWhere(
      (t) => t.id == tripId,
      orElse: () => state.upcomingTrips.first,
    );

    final completedTrip = TransporterTrip(
      id: trip.id,
      job: trip.job,
      relativeDate: 'Completed',
      pickupAddress: trip.pickupAddress,
      dropoffAddress: trip.dropoffAddress,
      canVerify: false,
    );

    emit(state.copyWith(
      upcomingTrips:
          state.upcomingTrips.where((t) => t.id != tripId).toList(),
      pastTrips: [completedTrip, ...state.pastTrips],
      verifiedTripIds: {...state.verifiedTripIds}..remove(tripId),
      clearActiveDelivery: true,
    ));
  }
}
