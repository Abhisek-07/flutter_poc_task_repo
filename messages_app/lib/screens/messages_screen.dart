import 'package:flutter/material.dart';
import 'package:messages_app/services/message_service.dart';
// import 'package:sms_advanced/sms_advanced.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final MessageService _messageService = MessageService();
  late Stream<Map<String, List<SmsMessage>>> _categorizedMessagesStream;
  // Map<String, List<SmsMessage>> _categorizedMessages = {};

  @override
  void initState() {
    super.initState();
    _categorizedMessagesStream = _messageService.categorizedMessagesStream;
  }

  @override
  void dispose() {
    _messageService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: StreamBuilder<Map<String, List<SmsMessage>>>(
          stream: _categorizedMessagesStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final categorizedMessages = snapshot.data;
              return ListView.builder(
                  itemCount: categorizedMessages!.length,
                  itemBuilder: (context, index) {
                    final category = categorizedMessages.keys.elementAt(index);
                    final messages = categorizedMessages[category];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: messages!.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              return ListTile(
                                title: Text(message.sender!),
                                subtitle: Text(message.body!),
                              );
                            })
                      ],
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
