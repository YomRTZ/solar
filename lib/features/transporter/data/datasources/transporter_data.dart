import 'package:flutter_app/features/transporter/domain/entities/transporter_job.dart';

/// Static mock data for the transporter feature.
///
/// Replace method bodies with real API/database calls when a backend is ready.
abstract final class TransporterData {
  /// Available jobs the transporter can bid on.
  static List<TransporterJob> availableJobs() => List.unmodifiable(
        TransporterJob.sampleJobs,
      );

  /// Bids the transporter has already placed.
  static List<TransporterBid> myBids() => List.unmodifiable(
        TransporterBid.sampleBids,
      );

  /// Upcoming and in-progress trips.
  static List<TransporterTrip> upcomingTrips() => List.unmodifiable(
        TransporterTrip.upcomingTrips,
      );

  /// Completed past trips.
  static List<TransporterTrip> pastTrips() => List.unmodifiable(
        TransporterTrip.pastTrips,
      );
}
