// Inspired by https://github.com/RedBrogdon/building_for_ios_IO19/blob/master/lib/adaptive_widgets.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seaoil/core/utils/strings.dart';

class AdaptiveActivityIndicator extends StatelessWidget {
  const AdaptiveActivityIndicator({
    Key? key,
    this.size = 20, // See CupertinoActivityIndicator._kDefaultIndicatorRadius
    this.color = Colors.white,
  }) : super(key: key);

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.platform == TargetPlatform.iOS
        ? CupertinoActivityIndicator(
            radius: size / 2,
          )
        : Center(
            child: SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          );
  }
}

class AdaptiveAlertDialog extends StatelessWidget {
  const AdaptiveAlertDialog({
    Key? key,
    this.title,
    this.content,
    this.actions,
  }) : super(key: key);

  final List<Widget>? actions;
  final Widget? content;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoAlertDialog(
              title: title,
              content: content,
              actions: actions!,
            )
          : AlertDialog(
              title: title,
              content: content,
              actions: actions!.reversed.toList(),
              shape: theme.cardTheme.shape,
            ),
    );
  }
}

class AdaptiveDialogAction extends StatelessWidget {
  const AdaptiveDialogAction({
    required this.child,
    required this.onPressed,
    Key? key,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
  }) : super(key: key);

  final Widget child;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return theme.platform == TargetPlatform.iOS
        ? CupertinoDialogAction(
            onPressed: onPressed,
            isDestructiveAction: isDestructiveAction,
            isDefaultAction: isDefaultAction,
            child: child,
          )
        : TextButton(
            // textColor: isDestructiveAction
            //     ? theme.colorScheme.error
            //     : theme.buttonColor,∏
            // shape: theme.buttonTheme.shape,
            onPressed: onPressed,
            // textColor: isDestructiveAction
            //     ? theme.colorScheme.error
            //     : theme.buttonColor,∏
            // shape: theme.buttonTheme.shape,
            child: child,
          );
  }
}

Future<T?> showAdaptiveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return Theme.of(context).platform == TargetPlatform.iOS
      ? showCupertinoDialog<T>(
          context: context,
          builder: builder,
        )
      : showDialog<T>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: builder,
        );
}

Future<T?> showAdaptiveSimpleDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return Theme.of(context).platform == TargetPlatform.iOS
      ? showCupertinoModalPopup<T>(
          context: context,
          builder: builder,
        )
      : showDialog<T>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: builder,
        );
}

class AdaptiveSimpleDialog extends StatelessWidget {
  const AdaptiveSimpleDialog({
    required this.title,
    required this.children,
    Key? key,
    this.content,
    this.cancelButton,
  }) : super(key: key);

  final Widget? cancelButton;
  final List<Widget> children;
  final Widget? content;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return theme.platform == TargetPlatform.iOS
        ? CupertinoActionSheet(
            title: title,
            message: content,
            actions: children,
            cancelButton: cancelButton,
          )
        : SimpleDialog(
            title: title,
            children: <Widget>[
              if (content != null) ...<Padding>{
                Padding(
                  padding: const EdgeInsets.only(
                    right: 24,
                    bottom: 8,
                    left: 24,
                  ),
                  child: content,
                ),
              },
              ...children,
            ],
          );
  }
}

class AdaptiveSimpleDialogOption extends StatelessWidget {
  const AdaptiveSimpleDialogOption({
    required this.child,
    required this.onPressed,
    Key? key,
    this.isDefault = false,
  }) : super(key: key);

  final Widget child;
  final bool isDefault;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoActionSheetAction(
            onPressed: onPressed,
            isDefaultAction: isDefault,
            child: child,
          )
        : SimpleDialogOption(
            onPressed: onPressed,
            child: child,
          );
  }
}

Future<DateTime?> showAdaptiveDatePicker({
  required BuildContext context,
  required DateTime firstDateTime,
  required DateTime initialDateTime,
  required DateTime lastDateTime,
  Brightness? brightness,
}) {
  final ThemeData theme = Theme.of(context);
  return theme.platform == TargetPlatform.iOS
      ? showCupertinoModalPopup<DateTime>(
          context: context,
          builder: (BuildContext context) {
            return _CupertinoDatePicker(
              firstDateTime: firstDateTime,
              initialDateTime: initialDateTime,
              lastDateTime: lastDateTime,
            );
          },
        )
      : showDatePicker(
          context: context,
          firstDate: firstDateTime,
          initialDate: initialDateTime,
          lastDate: lastDateTime,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: theme.brightness == Brightness.dark
                  ? ThemeData.dark()
                  : ThemeData.fallback(),
              child: child!,
            );
          },
        );
}

class _CupertinoDatePicker extends StatefulWidget {
  const _CupertinoDatePicker({
    required this.firstDateTime,
    required this.initialDateTime,
    required this.lastDateTime,
    Key? key,
  }) : super(key: key);

  final DateTime firstDateTime;
  final DateTime initialDateTime;
  final DateTime lastDateTime;

  @override
  __CupertinoDatePickerState createState() => __CupertinoDatePickerState();
}

class __CupertinoDatePickerState extends State<_CupertinoDatePicker> {
  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    // https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/cupertino/cupertino_picker_demo.dart#L58
    return Container(
      height: 216,
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              // Based on iOS's Address Book behavior
              CupertinoTheme(
                data: CupertinoThemeData(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(Strings.cancel),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(selectedDateTime ?? widget.initialDateTime);
                      },
                      child: Text(Strings.done),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: widget.firstDateTime,
                  minimumYear: widget.firstDateTime.year,
                  initialDateTime: widget.initialDateTime,
                  maximumDate: widget.lastDateTime,
                  maximumYear: widget.lastDateTime.year,
                  onDateTimeChanged: (DateTime value) {
                    selectedDateTime = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showGenericNormalAlertDialog(String title, String message,
    {bool barrierDismissible = true,
    Function? onOk,
    String? buttonTitle}) async {
  try {
    await showAdaptiveDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AdaptiveAlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            AdaptiveDialogAction(
              onPressed: onOk == null
                  ? () => Navigator.of(context).pop()
                  : onOk as void Function(),
              child: Text(buttonTitle ?? 'Close'),
            )
          ],
        );
      },
    );
  } on FlutterError catch (error) {
    print(error);
  }
}
