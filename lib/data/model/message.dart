import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? senderId, recieverId, text,photoUrl;
  Timestamp? sentTime;
  MessageType? type;
  Message({
    this.senderId,
    this.recieverId,
    this.text,
    this.sentTime,
    this.type,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'recieverId': recieverId,
        'text': text,
        'photoUrl':photoUrl,
        'sentTime': sentTime,
        'type': type?.toJson(),
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        senderId: json['senderId'],
        recieverId: json['recieverId'],
        text: json['text'],
        sentTime: json['sentTime'] != null
            ? Timestamp.fromMillisecondsSinceEpoch(json['sentTime'])
            : null,
        type: json['type'] ,
      );
}

enum MessageType {
  image,
  text;

  String toJson() => name;
}
