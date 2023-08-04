import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/commons/app_colors.dart';

class AppTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final FormFieldSetter<String>? onSaved;
  final bool? isRequire;
  final bool? enable;
  final TextStyle? labelStyle;
  final AutovalidateMode? autoValidateMode;
  final String? initialValue;
  final bool? obscureText;
  final String? suffixText;
  final TextStyle? suffixTextStyle;
  final Widget? suffixWidget;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    Key? key,
    this.initialValue,
    this.labelText = '',
    this.hintText = '',
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.keyboardType = TextInputType.text,
    this.autoValidateMode,
    this.validator,
    this.onSaved,
    this.isRequire,
    this.labelStyle,
    this.enable,
    this.obscureText = false,
    this.suffixText,
    this.suffixTextStyle,
    this.suffixWidget,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText!,
      obscuringCharacter: "*",
      enabled: widget.enable,
      inputFormatters: widget.inputFormatters,
      onEditingComplete: widget.onEditingComplete,
      controller: widget.controller,
      decoration: InputDecoration(
        suffixText: widget.suffixText,
        suffixStyle: widget.suffixTextStyle,
        suffixIcon: widget.suffixWidget,
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 13,
          bottom: 13,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.lineColor),
        ),
        disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.mainColor),
            borderRadius: BorderRadius.circular(10)),
        // focusedBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: AppColors.main),
        // ),
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: AppColors.main),
        // ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.mainColor),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.mainColor),
            borderRadius: BorderRadius.circular(10)),
        // focusedErrorBorder: OutlineInputBorder(
        //   // borderRadius: BorderRadius.circular(10),
        //   borderSide: BorderSide(color: AppColors.lineGray),
        // ),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        isDense: true,
      ),
      initialValue: widget.initialValue,
      autovalidateMode: widget.autoValidateMode,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      onSaved: widget.onSaved,
    );
  }
}

class AppTextFieldUnderLine extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final FormFieldSetter<String>? onSaved;
  final bool? isRequire;
  final TextStyle? labelStyle;
  final AutovalidateMode? autoValidateMode;
  final String? initialValue;
  final bool? enable;

  const AppTextFieldUnderLine({
    Key? key,
    this.initialValue,
    this.labelText = '',
    this.hintText = '',
    this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.number,
    this.autoValidateMode,
    this.validator,
    this.onSaved,
    this.isRequire,
    this.labelStyle,
    this.enable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 25,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            enabled: enable,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding:
                  const EdgeInsets.only(left: 2, right: 2, bottom: 12),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF000000)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF000000)),
              ),
              // hintStyle: AppTextStyle.greyS16,
            ),
            initialValue: initialValue,
            autovalidateMode: autoValidateMode,
            validator: validator,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: const TextStyle(color: Colors.black, fontSize: 14),
            onSaved: onSaved,
          ),
        ),
      ],
    );
  }
}

// class AppPasswordField extends StatelessWidget {
//   final String labelText;
//   final String hintText;
//   final TextEditingController? controller;
//   final ValueChanged<String>? onChanged;
//   final FormFieldValidator<String>? validator;
//   final TextInputType keyboardType;
//   final FormFieldSetter<String>? onSaved;
//   final bool? isRequire;
//   final bool? enable;
//   final TextStyle? labelStyle;
//   final AutovalidateMode? autoValidateMode;
//   final String? initialValue;
//   final bool? obscureText;
//   final Widget? suffixIcon;
//
//   const AppPasswordField({
//     Key? key,
//     this.initialValue,
//     this.labelText = '',
//     this.hintText = '',
//     this.controller,
//     this.onChanged,
//     this.keyboardType = TextInputType.text,
//     this.autoValidateMode,
//     this.validator,
//     this.onSaved,
//     this.isRequire,
//     this.labelStyle,
//     this.enable,
//     this.obscureText = false,
//     this.suffixIcon,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       obscureText: obscureText!,
//       obscuringCharacter: "*",
//       enabled: enable,
//       controller: controller,
//       decoration: InputDecoration(
//         suffixIcon: suffixIcon,
//         hintText: hintText,
//         contentPadding: const EdgeInsets.only(
//           left: 20,
//           right: 20,
//           top: 13,
//           bottom: 13,
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.redTextButton),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.lineGray),
//         ),
//         disabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: AppColors.main),
//             borderRadius: BorderRadius.circular(10)),
//         enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: AppColors.main),
//             borderRadius: BorderRadius.circular(10)),
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: AppColors.main),
//             borderRadius: BorderRadius.circular(10)),
//         // focusedErrorBorder: OutlineInputBorder(
//         //   // borderRadius: BorderRadius.circular(10),
//         //   borderSide: BorderSide(color: AppColors.lineGray),
//         // ),
//         hintStyle: AppTextStyle.greyS16,
//         isDense: true,
//       ),
//       initialValue: initialValue,
//       autovalidateMode: autoValidateMode,
//       validator: validator,
//       keyboardType: keyboardType,
//       onChanged: onChanged,
//       style: AppTextStyle.blackS16,
//       onSaved: onSaved,
//     );
//   }
// }

// class AppAutoCompleteTextField extends AutoCompleteTextField<String> {
//   final StringCallback? textChanged, textSubmitted;
//   final int minLength;
//   final ValueSetter<bool>? onFocusChanged;
//   final TextEditingController? controller;
//   final FocusNode? focusNode;
//   final Color? cursorColor;
//   final double? cursorWidth;
//   final Radius? cursorRadius;
//   final bool? showCursor;
//   final bool autofocus;
//
//   AppAutoCompleteTextField(
//       {TextStyle? style,
//       InputDecoration decoration: const InputDecoration(
//           contentPadding: const EdgeInsets.only(
//             left: 20,
//             right: 20,
//             top: 13,
//             bottom: 13,
//           ),
//           hintText: "Nhập vào đơn vị",
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             borderSide: BorderSide(color: AppColors.main, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             borderSide: BorderSide(color: AppColors.main, width: 1),
//           ),
//           disabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             borderSide: BorderSide(color: AppColors.main, width: 1),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             borderSide: BorderSide(color: AppColors.main, width: 1),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             borderSide: BorderSide(color: AppColors.redTextButton, width: 1),
//           )),
//       this.onFocusChanged,
//       this.textChanged,
//       this.textSubmitted,
//       this.minLength = 1,
//       this.controller,
//       this.focusNode,
//       this.autofocus = false,
//       this.cursorColor,
//       this.cursorWidth,
//       this.cursorRadius,
//       this.showCursor,
//       TextInputType keyboardType: TextInputType.text,
//       required GlobalKey<AutoCompleteTextFieldState<String>> key,
//       required List<String> suggestions,
//       int suggestionsAmount: 5,
//       bool submitOnSuggestionTap: true,
//       bool clearOnSubmit: true,
//       TextInputAction textInputAction: TextInputAction.done,
//       TextCapitalization textCapitalization: TextCapitalization.sentences})
//       : super(
//             style: style,
//             decoration: decoration,
//             textChanged: textChanged,
//             textSubmitted: textSubmitted,
//             itemSubmitted: textSubmitted,
//             keyboardType: keyboardType,
//             key: key,
//             suggestions: suggestions,
//             itemBuilder: null,
//             itemSorter: null,
//             itemFilter: null,
//             cursorColor: cursorColor,
//             cursorWidth: cursorWidth,
//             cursorRadius: cursorRadius,
//             showCursor: showCursor,
//             suggestionsAmount: suggestionsAmount,
//             submitOnSuggestionTap: submitOnSuggestionTap,
//             clearOnSubmit: clearOnSubmit,
//             textInputAction: textInputAction,
//             textCapitalization: textCapitalization);
//   @override
//   void updateDecoration(
//       {InputDecoration? decoration,
//       List<TextInputFormatter>? inputFormatters,
//       TextCapitalization? textCapitalization,
//       TextStyle? style,
//       TextInputType? keyboardType,
//       TextInputAction? textInputAction}) {
//     // TODO: implement updateDecoration
//     decoration = InputDecoration(
//         contentPadding: const EdgeInsets.only(
//           left: 20,
//           right: 20,
//           top: 13,
//           bottom: 13,
//         ),
//         errorText: "Chưa nhập đơn vị",
//         hintText: "Nhập vào đơn vị",
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide(color: AppColors.main, width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide(color: AppColors.main, width: 1),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide(color: AppColors.main, width: 1),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide(color: AppColors.main, width: 1),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide(color: AppColors.redTextButton, width: 1),
//         ));
//
//     super.updateDecoration(
//         decoration: decoration,
//         inputFormatters: inputFormatters,
//         textCapitalization: textCapitalization,
//         style: style,
//         keyboardType: keyboardType,
//         textInputAction: textInputAction);
//   }
//
//   @override
//   State<StatefulWidget> createState() => new AutoCompleteTextFieldState<String>(
//           suggestions,
//           textChanged,
//           textSubmitted,
//           onFocusChanged,
//           itemSubmitted, (context, item) {
//         return new Padding(padding: EdgeInsets.all(8.0), child: new Text(item));
//       }, (a, b) {
//         return a.compareTo(b);
//       }, (item, query) {
//         final regex = RegExp(query, caseSensitive: false);
//         return regex.hasMatch(item.toLowerCase());
//       },
//           suggestionsAmount,
//           submitOnSuggestionTap,
//           clearOnSubmit,
//           minLength,
//           [],
//           textCapitalization,
//           decoration,
//           style,
//           keyboardType,
//           textInputAction,
//           controller,
//           cursorColor,
//           cursorRadius,
//           cursorWidth,
//           showCursor,
//           focusNode,
//           autofocus,
//           unFocusOnItemSubmitted,
//           autocorrect);
// }
