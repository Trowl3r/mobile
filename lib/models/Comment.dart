import 'package:hononym/models/User.dart';

class Comment {
  final String id;
  final User user;
  final String text;
  final String dateCreated;
  final List likes;

  Comment({
    this.id,
    this.user,
    this.text,
    this.dateCreated,
    this.likes
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return new Comment(
      id: json['id'],
      user: User.fromJson(json['user']),
      text: json['text'],
      dateCreated: json['date'],
      likes: json['likes']
    );
  }
}