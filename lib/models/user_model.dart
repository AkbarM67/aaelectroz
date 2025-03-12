class UserModel {
  int? id;
  String? name;
  String? email;
  String? username;
  String? profilePhotoUrl;
  String? token;
  String? role;

// Constructor
  UserModel({
    this.id,
    this.name,
    this.email,
    this.username,
    this.profilePhotoUrl,
    this.token,
    this.role,  // Tambahkan 'role' di constructor
  });

// fromJson - untuk parsing data JSON dari API
  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    profilePhotoUrl = json['profile_photo_url'];
    token = json['token'];
    role = json['role'];  // Tambahkan parsing 'role' dari JSON
  }

 // toJson - untuk mengonversi object menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'profile_photo_url': profilePhotoUrl,
      'token': token,
      'role': role,  // Tambahkan 'role' ke dalam JSON
    };
  }
}
