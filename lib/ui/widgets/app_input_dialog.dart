import 'package:flutter/material.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:mobile/ui/widgets/app_button.dart';

class AppInputDialog extends StatefulWidget {
  final VoidCallback? onConfirm;
  final bool? isLoading;
  final String? title;
  List<Widget> actions = const [];

  AppInputDialog({
    Key? key,
    this.onConfirm,
    this.title,
    this.isLoading,
    required this.actions,
  }) : super(key: key);

  @override
  State<AppInputDialog> createState() => _AppInputDialogState();
}

class _AppInputDialogState extends State<AppInputDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: MediaQuery.of(context).viewInsets,
        padding: const EdgeInsets.all(7),
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
        ),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Text(widget.title ?? "Thông báo",
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Helvetica"))),
                    ),
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.actions),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: AppButton(
                              color: Colors.red,
                              title: 'Hủy bỏ',
                              width: 80,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                              child: AppButton(
                                  color: AppColors.mainColor,
                                  title: "Xác nhận",
                                  isLoading: widget.isLoading ?? false,
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  onPressed: widget.onConfirm)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
