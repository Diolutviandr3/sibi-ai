enum SessionStatus {
  success,
  aborted,
  review,
  completed,
}

class Session {
  final String id;
  final String title;
  final String duration;
  final double load; // e.g. 14.5
  final SessionStatus status;
  final String date;
  final double accuracy; // e.g. 98.2
  final int conceptCount;

  Session({
    required this.id,
    required this.title,
    required this.duration,
    required this.load,
    required this.status,
    required this.date,
    required this.accuracy,
    required this.conceptCount,
  });

  String get statusText {
    switch (status) {
      case SessionStatus.success:
        return 'SUCCESS';
      case SessionStatus.aborted:
        return 'ABORTED';
      case SessionStatus.review:
        return 'TINJAUAN';
      case SessionStatus.completed:
        return 'Selesai';
    }
  }
}
