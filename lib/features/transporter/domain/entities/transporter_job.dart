class TransporterJob {
  final String from;
  final String to;
  final String date;
  final String vehicle;
  final String weight;
  final String price;

  const TransporterJob({
    required this.from,
    required this.to,
    required this.date,
    required this.vehicle,
    required this.weight,
    required this.price,
  });

  String get route => '$from → $to';

  static const sampleJobs = [
    TransporterJob(
      from: 'Delhi',
      to: 'Mumbai',
      date: '10 Nov 2026',
      vehicle: 'Container',
      weight: '1 Ton',
      price: '28,000',
    ),
    TransporterJob(
      from: 'Delhi',
      to: 'Mumbai',
      date: '10 Nov 2026',
      vehicle: 'Container',
      weight: '1 Ton',
      price: '28,000',
    ),
    TransporterJob(
      from: 'Delhi',
      to: 'Mumbai',
      date: '10 Nov 2026',
      vehicle: 'Container',
      weight: '1 Ton',
      price: '28,000',
    ),
  ];
}

enum TransporterBidStatus { requested, rejected, approved }

class TransporterBid {
  final TransporterJob job;
  final TransporterBidStatus status;
  final String timeSinceRequest;

  const TransporterBid({
    required this.job,
    required this.status,
    required this.timeSinceRequest,
  });

  static const sampleBids = [
    TransporterBid(
      job: TransporterJob(
        from: 'Delhi',
        to: 'Mumbai',
        date: '10 Nov 2026',
        vehicle: 'Container',
        weight: '1 Ton',
        price: '28,000',
      ),
      status: TransporterBidStatus.requested,
      timeSinceRequest: '2 min ago',
    ),
    TransporterBid(
      job: TransporterJob(
        from: 'Delhi',
        to: 'Mumbai',
        date: '10 Nov 2026',
        vehicle: 'Container',
        weight: '1 Ton',
        price: '28,000',
      ),
      status: TransporterBidStatus.rejected,
      timeSinceRequest: '2 min ago',
    ),
    TransporterBid(
      job: TransporterJob(
        from: 'Delhi',
        to: 'Mumbai',
        date: '10 Nov 2026',
        vehicle: 'Container',
        weight: '1 Ton',
        price: '28,000',
      ),
      status: TransporterBidStatus.approved,
      timeSinceRequest: '2 min ago',
    ),
  ];
}

class TransporterTrip {
  final String id;
  final TransporterJob job;
  final String relativeDate;
  final String? pickupAddress;
  final String? dropoffAddress;
  final bool canVerify;

  const TransporterTrip({
    required this.id,
    required this.job,
    required this.relativeDate,
    this.pickupAddress,
    this.dropoffAddress,
    this.canVerify = false,
  });

  static const upcomingTrips = [
    TransporterTrip(
      id: 'trip-today',
      job: TransporterJob(
        from: 'Delhi',
        to: 'Mumbai',
        date: '10 Nov 2026',
        vehicle: 'Container',
        weight: '1 Ton',
        price: '28,000',
      ),
      relativeDate: 'Today',
      pickupAddress: '12-333 Saket, Delhi',
      dropoffAddress: '12 Bawali, Mumbai-12302',
      canVerify: true,
    ),
    TransporterTrip(
      id: 'trip-upcoming',
      job: TransporterJob(
        from: 'Delhi',
        to: 'Mumbai',
        date: '10 Nov 2026',
        vehicle: 'Container',
        weight: '1 Ton',
        price: '28,000',
      ),
      relativeDate: 'In 2 Days',
    ),
  ];

  static const pastTrips = [
    TransporterTrip(
      id: 'trip-past',
      job: TransporterJob(
        from: 'Delhi',
        to: 'Mumbai',
        date: '08 Nov 2026',
        vehicle: 'Container',
        weight: '1 Ton',
        price: '28,000',
      ),
      relativeDate: 'Completed',
    ),
  ];
}
