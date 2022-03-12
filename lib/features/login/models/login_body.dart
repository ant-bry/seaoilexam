// To parse this JSON data, do
//
//     final loginBody = loginBodyFromJson(jsonString);

import 'dart:convert';

LoginBody loginBodyFromJson(String str) => LoginBody.fromJson(json.decode(str));

String loginBodyToJson(LoginBody data) => json.encode(data.toJson());

class LoginBody {
  LoginBody({
    this.mobileNumber,
    this.password,
    this.profileType,
  });

  String? mobileNumber;
  String? password;
  String? profileType;

  factory LoginBody.fromJson(Map<String, dynamic> json) => LoginBody(
        mobileNumber:
            json['mobileNumber'] == null ? null : json['mobileNumber'],
        password: json['password'] == null ? null : json['password'],
        profileType: json['profileType'] == null ? null : json['profileType'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'mobileNumber': mobileNumber == null ? null : mobileNumber,
        'password': password == null ? null : password,
        'profileType': profileType == null ? null : profileType,
      };
}
