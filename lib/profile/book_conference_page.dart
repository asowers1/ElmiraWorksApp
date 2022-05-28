import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class BookConferencePage extends StatefulWidget {
  final User user;

  const BookConferencePage({required this.user});

  @override
  _BookConferencePageState createState() => _BookConferencePageState();
}

class _BookConferencePageState extends State<BookConferencePage> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2022, 1, 1),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
    );
  }
}
