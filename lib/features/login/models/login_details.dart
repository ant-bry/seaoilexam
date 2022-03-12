// To parse this JSON data, do
//
//     final loginDetails = loginDetailsFromJson(jsonString);

import 'dart:convert';

LoginDetails loginDetailsFromJson(String str) =>
    LoginDetails.fromJson(json.decode(str));

String loginDetailsToJson(LoginDetails data) => json.encode(data.toJson());

class LoginDetails {
  LoginDetails({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory LoginDetails.fromJson(Map<String, dynamic> json) => LoginDetails(
        message: json['message'] == null ? null : json['message'],
        data: json['data'] == null ? null : Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': message == null ? null : message,
        'data': data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.accessToken,
    this.expiresIn,
    this.tokenType,
    this.refreshToken,
  });

  String? accessToken;
  int? expiresIn;
  String? tokenType;
  String? refreshToken;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json['AccessToken'] == null ? null : json['AccessToken'],
        expiresIn: json['ExpiresIn'] == null ? null : json['ExpiresIn'],
        tokenType: json['TokenType'] == null ? null : json['TokenType'],
        refreshToken:
            json['RefreshToken'] == null ? null : json['RefreshToken'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'AccessToken': accessToken == null ? null : accessToken,
        'ExpiresIn': expiresIn == null ? null : expiresIn,
        'TokenType': tokenType == null ? null : tokenType,
        'RefreshToken': refreshToken == null ? null : refreshToken,
      };
}
