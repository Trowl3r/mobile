//TDOO: Make the Post class, and then make a post widget with all functions (like delete comment etc). then make a special widget folder where the style is created.
// When I need those widgets, I will then get them in the screen where they are needed, and then give them to the widgets folder widget.
import 'package:hononym/models/Comment.dart';
import 'package:hononym/models/User.dart';

class Post {
  final String id;
  final User user;
  final String postImage;
  final String text;
  final List likes;
  final List comments;
  final bool isGroupPost;
  final String group;
  final String date;

  Post(
      {this.id,
      this.user,
      this.postImage,
      this.text,
      this.likes,
      this.comments,
      this.isGroupPost,
      this.group,
      this.date});

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
        id: json['id'],
        user: User.fromJson(json['user']),
        postImage: json['postImage'],
        text: json['text'],
        likes: json['likes'],
        comments: json['comments'],
        isGroupPost: json['isGroupPost'],
        group: json['group'],
        date: json['date']);
  }
}
