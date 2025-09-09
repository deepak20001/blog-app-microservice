extension DateTimeExtensions on DateTime {
  static String timeAgoFromIso(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return dateTime.timeAgo;
    } catch (e) {
      return 'Invalid date';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      final futureDifference = this.difference(now);
      return _formatFutureDifference(futureDifference);
    }

    return _formatPastDifference(difference);
  }

  String timeAgoFrom(DateTime from) {
    final difference = from.difference(this);

    if (difference.isNegative) {
      final futureDifference = this.difference(from);
      return _formatFutureDifference(futureDifference);
    }

    return _formatPastDifference(difference);
  }

  String _formatPastDifference(Duration difference) {
    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}hr ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    }
  }

  String _formatFutureDifference(Duration difference) {
    if (difference.inSeconds < 60) {
      return 'in a moment';
    } else if (difference.inMinutes < 60) {
      return 'in ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'in ${difference.inHours}hr';
    } else if (difference.inDays < 7) {
      return 'in ${difference.inDays}d';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'in ${weeks}w';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'in ${months}mo';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'in ${years}y';
    }
  }

  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.year == year &&
        yesterday.month == month &&
        yesterday.day == day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return isAfter(weekAgo) && isBefore(now.add(const Duration(days: 1)));
  }
}

extension StringDateTimeExtensions on String {
  String toTimeAgo() {
    return DateTimeExtensions.timeAgoFromIso(this);
  }
}
