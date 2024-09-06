import 'dart:async';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:sms_receiver/sms_receiver.dart';

// import 'package:sms_advanced/sms_advanced.dart';
//import 'package:sms_advanced/sms_advanced_web.dart';

class MessageService {
  List<SmsMessage> smsList = [];

  SmsQuery smsQuery = SmsQuery();
  // SmsReceiver smsReceiver = SmsReceiver();

  Map<String, List<SmsMessage>> categorizedMessages = {
    '0 hours ago': [],
    '1 hour ago': [],
    '2 hours ago': [],
    '3 hours ago': [],
    '6 hours ago': [],
    '12 hours ago': [],
    '1 day ago': [],
  };

  final StreamController<Map<String, List<SmsMessage>>>
      _categorizedMessagesController =
      StreamController<Map<String, List<SmsMessage>>>.broadcast();

  Stream<Map<String, List<SmsMessage>>> get categorizedMessagesStream =>
      _categorizedMessagesController.stream;

  MessageService() {
    startFetchingMessages();
    // startListeningForNewMessages();
    startPeriodicTimer();
  }

  void startFetchingMessages() {
    fetchAllMessages();
  }

  Future<void> fetchAllMessages() async {
    // smsList = await smsQuery.getAllSms;

    final permission = await Permission.sms.status;

    if (permission.isGranted) {
      smsList = await smsQuery.querySms(
        kinds: [SmsQueryKind.inbox],
      );

      var now = DateTime.now();
      final filteredMessages = smsList.where((sms) {
        var difference = now.difference(sms.date!);
        return difference.inDays <= 1;
      }).toList();

      final categorizedMessages = _categorizeMessages(filteredMessages);
      _categorizedMessagesController.add(categorizedMessages);
    } else {
      await Permission.sms.request();
    }
  }

  // void startListeningForNewMessages() {
  //   // smsReceiver.onSmsReceived!.listen((SmsMessage message) {

  //   //   // final categorizedMessages = _categorizeMessages([message]);
  //   //   // _categorizedMessagesController.add(categorizedMessages);
  //   //   fetchAllMessages(); // Fetch all messages again, including the new one
  //   //   // showNotification('New Message', 'You have received a new SMS.');
  //   // });
  // }

  void startPeriodicTimer() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      fetchAllMessages();
    });
  }

  Map<String, List<SmsMessage>> _categorizeMessages(List<SmsMessage> smsList) {
    final DateTime now = DateTime.now();

    for (SmsMessage message in smsList) {
      final Duration difference = now.difference(message.date!);
      final int hours = difference.inHours;
      final int days = difference.inDays;

      if (hours >= 0 && hours < 1) {
        categorizedMessages['0 hours ago']!.add(message);
      } else if (hours >= 1 && hours < 2) {
        categorizedMessages['1 hour ago']!.add(message);
      } else if (hours >= 2 && hours < 3) {
        categorizedMessages['2 hours ago']!.add(message);
      } else if (hours >= 3 && hours < 6) {
        categorizedMessages['3 hours ago']!.add(message);
      } else if (hours >= 6 && hours < 12) {
        categorizedMessages['6 hours ago']!.add(message);
      } else if (hours >= 12 && hours < 24) {
        categorizedMessages['12 hours ago']!.add(message);
      } else if (days >= 1 && days < 2) {
        categorizedMessages['1 day ago']!.add(message);
      }
    }
    return categorizedMessages;
  }

  void dispose() {
    _categorizedMessagesController.close();
  }
}
