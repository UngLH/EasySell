import 'package:flutter/material.dart';

class AppBarWidget extends AppBar {
  AppBarWidget({
    Key? key,
    bool showBackButton = true,
    required BuildContext context,
    VoidCallback? onBackPressed,
    String title = "",
    Color? backgroundColor,
    Color? iconColor,
    Color? textColor,
    List<Widget> rightActions = const [],
  }) : super(
          key: key,
          title: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: textColor ?? Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          elevation: 0,
          backgroundColor: backgroundColor ?? Colors.white,
          leading: showBackButton
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: backgroundColor ?? Colors.white,
                    child: IconButton(
                        onPressed: onBackPressed ??
                            () {
                              Navigator.of(context).pop(true);
                            },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: iconColor ?? Colors.black,
                          size: 18,
                        )),
                  ),
                )
              : null,
          actions: rightActions,
        );
}
