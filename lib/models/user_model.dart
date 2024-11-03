class User {
  final int? id;
  final String userName;
  final String userSurname;
  final String userBirthDay;
  final String userEmail;
  final String userPassword;
  final int userRole;
  final String? userPhone;
  final String? userPhoto;

  User({
    this.id,
    required this.userName,
    required this.userSurname,
    required this.userBirthDay,
    required this.userEmail,
    required this.userPassword,
    this.userRole = 1,
    this.userPhone,
    this.userPhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userName': userName,
      'userSurname': userSurname,
      'userBirthDay': userBirthDay,
      'userEmail': userEmail,
      'userPassword': userPassword,
      'userRole': userRole,
      'userPhone': userPhone,
      'userPhoto': userPhoto,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'],
      userName: map['userName'],
      userSurname: map['userSurname'],
      userBirthDay: map['userBirthDay'],
      userEmail: map['userEmail'],
      userPassword: map['userPassword'],
      userRole: map['userRole'],
      userPhone: map['userPhone'],
      userPhoto: map['userPhoto'],
    );
  }
}
