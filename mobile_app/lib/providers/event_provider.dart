/// Event Provider
/// Manages event-related state
import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../models/registration.dart';
import '../services/student_service.dart';
import '../services/organizer_service.dart';

class EventProvider with ChangeNotifier {
  final StudentService _studentService = StudentService();
  final OrganizerService _organizerService = OrganizerService();

  List<Event> _events = [];
  List<Registration> _registrations = [];
  Event? _selectedEvent;
  bool _isLoading = false;
  String? _error;

  List<Event> get events => _events;
  List<Registration> get registrations => _registrations;
  Event? get selectedEvent => _selectedEvent;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load student events
  Future<void> loadStudentEvents({String? organizer, String? mode}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _studentService.getEvents(
        organizer: organizer,
        mode: mode,
      );

      if (response.success && response.data != null) {
        _events = response.data!;
      } else {
        _error = response.message ?? 'Failed to load events';
      }
    } catch (e) {
      _error = 'Error loading events: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Register for an event
  Future<bool> registerForEvent(int eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _studentService.registerForEvent(eventId);

      if (response.success && response.data != null) {
        _registrations.add(response.data!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Failed to register';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error registering: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Load student registrations
  Future<void> loadMyRegistrations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _studentService.getMyRegistrations();

      if (response.success && response.data != null) {
        _registrations = response.data!;
      } else {
        _error = response.message ?? 'Failed to load registrations';
      }
    } catch (e) {
      _error = 'Error loading registrations: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Create event (organizer)
  Future<bool> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int deptId,
    required String mode,
    int? venueId,
    String? meetingUrl,
    String? posterUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _organizerService.createEvent(
        title: title,
        description: description,
        date: date,
        startTime: startTime,
        endTime: endTime,
        deptId: deptId,
        mode: mode,
        venueId: venueId,
        meetingUrl: meetingUrl,
        posterUrl: posterUrl,
      );

      if (response.success && response.data != null) {
        _events.insert(0, response.data!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Failed to create event';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error creating event: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Submit feedback
  Future<bool> submitFeedback({
    required int eventId,
    required int rating,
    String? comments,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _studentService.submitFeedback(
        eventId: eventId,
        rating: rating,
        comments: comments,
      );

      _isLoading = false;
      if (response.success) {
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Failed to submit feedback';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error submitting feedback: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Set selected event
  void setSelectedEvent(Event? event) {
    _selectedEvent = event;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear data
  void clear() {
    _events = [];
    _registrations = [];
    _selectedEvent = null;
    _error = null;
    notifyListeners();
  }
}
