import 'package:flutter/material.dart';
import 'package:mobile/commons/app_colors.dart';

class SnackBarMessage {
  final String? message;
  final SnackBarType type;

  SnackBarMessage({
    this.message,
    this.type = SnackBarType.SUCCESS,
  });
}

enum SnackBarType {
  SUCCESS,
  ERROR,
  INFO,
}

extension SnackBarTypeExtension on SnackBarType {
  Color get backgroundColor {
    switch (this) {
      case SnackBarType.SUCCESS:
        return AppColors.greenSuccessColor;
      case SnackBarType.ERROR:
        return Color(0xFFFFEDED);
      default:
        return Color(0xFF9FC2FF);
    }
  }

  Color get messageColor {
    switch (this) {
      case SnackBarType.SUCCESS:
        return Colors.white;
      case SnackBarType.ERROR:
        return Color(0xFFFF0000);
      default:
        return AppColors.mainColor;
    }
  }

  Widget get prefixIcon {
    switch (this) {
      case SnackBarType.SUCCESS:
        return Icon(Icons.check_circle_outline,
            color: AppColors.greenSuccessColor, size: 16);
      case SnackBarType.ERROR:
        return Icon(Icons.warning_amber,
            size: 16, color: AppColors.yellowMainColor);
      default:
        return Icon(Icons.info_outline, color: AppColors.mainColor, size: 16);
    }
  }
}

class AppSnackBar extends SnackBar {
  final SnackBarMessage message;

  AppSnackBar({
    required this.message,
  }) : super(
          elevation: 0,
          content: Container(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: message.type.backgroundColor,
              ),
              child: Row(
                children: [
                  Container(child: message.type.prefixIcon),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      child: Text(message.message ?? "Có lỗi xảy ra",
                          style: TextStyle(
                            fontSize: 16,
                            color: message.type.messageColor,
                            fontWeight: FontWeight.w300,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          padding: EdgeInsets.all(28),
          backgroundColor: Colors.transparent,
        );
}
