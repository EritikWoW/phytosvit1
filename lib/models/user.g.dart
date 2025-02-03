// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      userName: json['userName'] as String,
      userSurname: json['userSurname'] as String,
      userBirthDay: json['userBirthDay'] as String,
      userEmail: json['userEmail'] as String,
      userPassword: json['userPassword'] as String,
      userRole: (json['userRole'] as num).toInt(),
      userPhone: json['userPhone'] as String,
      userPhoto: json['userPhoto'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'userSurname': instance.userSurname,
      'userBirthDay': instance.userBirthDay,
      'userEmail': instance.userEmail,
      'userPassword': instance.userPassword,
      'userRole': instance.userRole,
      'userPhone': instance.userPhone,
      'userPhoto': instance.userPhoto,
    };
