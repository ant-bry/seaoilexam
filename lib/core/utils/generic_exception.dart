import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart';
import 'package:seaoil/core/utils/strings.dart';
import 'package:seaoil/core/widgets/adaptive.dart';

class GenericException implements Exception {
  GenericException.clientException(ClientException exception) {
    this.type = GenericExceptionType.client;

    this.code = 0;
    this.content = Text(exception.message);
    this.message = exception.message;
  }

  GenericException.formatException(FormatException exception) {
    this.type = GenericExceptionType.format;

    this.code = 0;
    this.content = Text(exception.message);
    this.message = exception.message;
  }

  GenericException.httpResponse(Response response) {
    this.type = GenericExceptionType.http;
    this.code = response.statusCode;

    if (response.headers['content-type'] != null &&
        response.headers['content-type']!.startsWith('text/html')) {
      this.content = Html(data: response.body);

      return;
    }

    final String bodyString = (response.body).toString();
    final String? defaultMessage =
        bodyString.isEmpty ? response.reasonPhrase : bodyString;
    String message = '';

    try {
      final dynamic body = jsonDecode(response.body);

      if (body is Map<String, dynamic>) {
        if (body['message'] is String) {
          message = body['message'].toString();
        }

        switch (code) {
          case 404:
            message = (message.isEmpty ? response.reasonPhrase : message)!;
            break;

          case 422:
            if (body['errors'] is Map<String, dynamic>) {
              final Map<String, dynamic> errors =
                  body['errors'] as Map<String, dynamic>;
              for (final dynamic errorMessages in errors.values) {
                if (errorMessages is List<dynamic>) {
                  for (final dynamic errorMessage in errorMessages) {
                    if (message.isNotEmpty) {
                      message += '\n';
                    }

                    message += '\n• $errorMessage';
                  }
                }
              }
            }
            break;
        }
      }

      if (message.isEmpty) {
        message = defaultMessage!;
      }
    } on FormatException {
      message = defaultMessage!;
    }

    this.content = Text(message);
    this.message = message;
  }

  GenericException.platformException(PlatformException exception) {
    this.type = GenericExceptionType.platform;

    this.code = exception.code;
    this.content = Text(exception.message ?? '?');
    this.message = exception.message ?? '?';
  }

  GenericException.socketException(SocketException exception) {
    this.type = GenericExceptionType.socket;

    this.code = exception.osError!.errorCode;

    switch (this.code) {
      case 7:
        // No address associated with hostname
        this.content = Text(Strings.genericExceptionSocket7851);
        this.message = Strings.genericExceptionSocket7851;
        break;

      case 8:
        // nodename nor servname provided, or not known
        this.content = Text(Strings.genericExceptionSocket7851);
        this.message = Strings.genericExceptionSocket7851;
        break;

      case 51:
        // Network is unreachable
        this.content = Text(Strings.genericExceptionSocket7851);
        this.message = Strings.genericExceptionSocket7851;
        break;

      default:
        this.content = Text(exception.osError!.message);
        this.message = exception.osError!.message;
    }
  }

  dynamic code;
  Widget? content;
  String? message;
  String? title;
  GenericExceptionType? type;

  @override
  String toString() {
    return '$type ($code): $message';
  }
}

Future<void> showGenericAlertDialog(
    {required BuildContext context, required GenericException error}) async {
  try {
    await showAdaptiveDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        String type = '';

        switch (error.type) {
          case null:
            type = '';
            break;
          case GenericExceptionType.client:
            type = 'Client';
            break;

          case GenericExceptionType.format:
            type = 'Format';
            break;

          case GenericExceptionType.http:
            type = 'Http';
            break;

          case GenericExceptionType.platform:
            type = 'Platform';
            break;

          case GenericExceptionType.socket:
            type = 'Socket';
            break;
        }

        return AdaptiveAlertDialog(
          title: Text(error.title ?? '$type ${Strings.error}: ${error.code}'),
          content: SingleChildScrollView(child: error.content),
          actions: <Widget>[
            AdaptiveDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(Strings.ok),
            )
          ],
        );
      },
    );
  } on FlutterError catch (error) {
    print(error);
  }
}

enum GenericExceptionType {
  client,
  format,
  http,
  platform,
  socket,
}
