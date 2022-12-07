
import '../models/events.dart';

class Places {
  final String id;
  final String title;
  final String image;
  final String description;
  final String location;
  final String pictures;
  final List<Event> events;

  const Places({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.location,
    required this.pictures,
    required this.events
  });
}

