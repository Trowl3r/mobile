class User {
  final String id;
  final String username;
  final String email;
  final List follower;
  final List following;
  final bool isAdmin;
  final String fullName;
  final String dateCreated;
  final String profileImage;
  final List likedTags;
  final List posts;
  final List groups;
  final String bio;

  User(
      {this.id,
      this.username,
      this.email,
      this.likedTags,
      this.follower,
      this.following,
      this.fullName,
      this.isAdmin,
      this.dateCreated,
      this.profileImage,
      this.posts,
      this.groups,
      this.bio
    }
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
        id: json['_id'],
        username: json['username'],
        email: json['email'],
        follower: json['follower'],
        following: json['following'],
        fullName: json['fullName'],
        isAdmin: json['isAdmin'],
        dateCreated: json['dateCreated'],
        profileImage: json['profileImage'],
        likedTags: json['likedTags'],
        groups: json['groups'],
        posts: json['posts'],
        bio: json['bio']
      );
  }
}
