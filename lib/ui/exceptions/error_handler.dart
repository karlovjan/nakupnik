import 'package:flutter/material.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error == null) {
      return '';
    }
//    if (error is ValidationException) {
//      return error.message;
//    }

    return Error.safeToString(error);
  }

  static Widget getErrorDialog(dynamic error) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            color: Colors.yellow,
          ),
          Text(ErrorHandler.getErrorMessage(error)),
        ],
      ),
    );
  }

  static Widget getErrorDialogWithBackButton(
      BuildContext context, dynamic error) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            color: Colors.yellow,
          ),
          Text(ErrorHandler.getErrorMessage(error)),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
