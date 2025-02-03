import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  final String userName;
  final String userSurname;
  final String userBirthDay;
  final String userEmail;
  final String userPassword;
  final int userRole;
  final String userPhone;
  final String userPhoto;

  User({
    this.id,
    required this.userName,
    required this.userSurname,
    required this.userBirthDay,
    required this.userEmail,
    required this.userPassword,
    required this.userRole,
    required this.userPhone,
    required this.userPhoto,
  });

  // Конструктор для регистрации, только с полями userName, userEmail и userPassword
  User.registration({
    required this.userName,
    required this.userEmail,
    required this.userPassword,
  })  : id = null,
        userSurname = '',
        userBirthDay = '',
        userRole = 0,
        userPhone = '',
        userPhoto = '';

  // Конструктор для создания объекта User из Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      userName: map['userName'] as String,
      userSurname: map['userSurname'] as String,
      userBirthDay: map['userBirthDay'] as String,
      userEmail: map['userEmail'] as String,
      userPassword: map['userPassword'] as String,
      userRole: map['userRole'] as int,
      userPhone: map['userPhone'] as String,
      userPhoto: map['userPhoto'] as String,
    );
  }

  // Метод для преобразования объекта User в Map (например, для сохранения в базу данных)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
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

  // Фабричный метод для создания объекта из JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  get isSynced => null;

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{id: $id, userName: $userName, userSurname: $userSurname, userEmail: $userEmail}';
  }

  void setId(int? id) {
    this.id = id;
  }
}
