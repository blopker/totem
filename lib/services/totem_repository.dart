import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totem/models/index.dart';
import 'package:totem/services/agora/agora_communication_provider.dart';
import 'package:totem/services/circles_provider.dart';
import 'package:totem/services/firebase_providers/firebase_circles_provider.dart';
import 'package:totem/services/firebase_providers/firebase_session_provider.dart';
import 'package:totem/services/firebase_providers/firebase_user_provider.dart';
import 'package:totem/services/topics_provider.dart';
import 'package:totem/services/user_provider.dart';
import 'package:totem/services/index.dart';
import 'firebase_providers/firebase_topics_provider.dart';

class TotemRepository {
  static final userProfileProvider =
      StreamProvider.autoDispose<UserProfile?>((ref) {
    final repo = ref.read(repositoryProvider);
    final authUser = ref.watch(authStateChangesProvider).asData?.value;
    if (authUser == null) {
      final streamController = StreamController<UserProfile?>();
      streamController.add(null);
      return streamController.stream;
    } else {
      return repo.userProfileStream();
    }
  });

  late final TopicsProvider _topicsProvider;
  late final CirclesProvider _circlesProvider;
  late final UserProvider _userProvider;
  late final SessionProvider _sessionProvider;
  AuthUser? user;

  TotemRepository() {
    _topicsProvider = FirebaseTopicsProvider();
    _circlesProvider = FirebaseCirclesProvider();
    _userProvider = FirebaseUserProvider();
    _sessionProvider = FirebaseSessionProvider();
  }

  // Topics
  Stream<List<Topic>> topics({String sort = TopicSort.title}) =>
      _topicsProvider.topics(sort: sort);

  // Circles
  Future<Circle?> createCircle({
    required String name,
    required int numSessions,
    required DateTime startDate,
    required DateTime startTime,
    required List<int> daysOfTheWeek,
    String? description,
    bool addAsMember = true,
  }) =>
      _circlesProvider.createCircle(
        name: name,
        numSessions: numSessions,
        startDate: startDate,
        startTime: startTime,
        daysOfTheWeek: daysOfTheWeek,
        description: description,
        uid: user!.uid,
        addAsMember: addAsMember,
      );
  Stream<List<Circle>> circles({bool allCircles = false}) =>
      _circlesProvider.circles(!allCircles ? user?.uid : null);
  Stream<Circle> circle({required String circleId}) =>
      _circlesProvider.circle(circleId);

  // Sessions
  Future<ActiveSession> activateSession({required Session session}) =>
      _sessionProvider.activateSession(session: session, uid: user!.uid);
  Future<void> joinSession({required Session session}) =>
      _sessionProvider.joinSession(session: session, uid: user!.uid);
  Future<ActiveSession> createActiveSession({required Session session}) =>
      _sessionProvider.createActiveSession(session: session);
  Future<void> startActiveSession() => _sessionProvider.startActiveSession();
  Future<void> endActiveSession() => _sessionProvider.endActiveSession();
  void clearActiveSession() => _sessionProvider.clear();
  ActiveSession? get activeSession => _sessionProvider.activeSession;
  // Communications for Session
  CommunicationProvider createCommunicationProvider() {
    CommunicationProvider provider = AgoraCommunicationProvider(
        sessionProvider: _sessionProvider, userId: user!.uid);
    return provider;
  }

  // Users
  Stream<UserProfile> userProfileStream() =>
      _userProvider.userProfileStream(uid: user!.uid);
  Future<UserProfile?> userProfile() =>
      _userProvider.userProfile(uid: user!.uid);
  Future<void> updateUserProfile(UserProfile userProfile) =>
      _userProvider.updateUserProfile(userProfile: userProfile, uid: user!.uid);
}