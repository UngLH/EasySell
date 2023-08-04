import 'package:flutter/material.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:mobile/models/entities/shop/bank_entity.dart';

class AppAutoComplete extends StatefulWidget {
  final List<BankEntity> suggestions;
  final String? hintText;
  final TextEditingController textFieldController;
  final void Function(BankEntity?) onBankSelected;

  AppAutoComplete({
    Key? key,
    required this.suggestions,
    this.hintText,
    required this.textFieldController,
    required this.onBankSelected,
  }) : super(key: key);

  @override
  _AppAutoCompleteState createState() => _AppAutoCompleteState();
}

class _AppAutoCompleteState extends State<AppAutoComplete> {
  BankEntity? selectedBank;

  BankEntity? findSelectedBank(String bankBin) {
    try {
      return widget.suggestions.firstWhere((bank) => bank.bin == bankBin);
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    final bankBin = widget.textFieldController.text;
    selectedBank = bankBin.isNotEmpty ? findSelectedBank(bankBin) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<BankEntity>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            return widget.suggestions
                .where((bank) => (bank.shortName ?? '')
                    .toLowerCase()
                    .startsWith(textEditingValue.text.toLowerCase()))
                .toList();
          },
          onSelected: (BankEntity selection) {
            widget.textFieldController.text = selection.bin!;
            selectedBank = selection;
            widget.onBankSelected(selectedBank);
          },
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<BankEntity> onSelected,
            Iterable<BankEntity> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 35,
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final BankEntity option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          leading: option.logo != null
                              ? Image.network(
                                  option.logo ??
                                      'https://storage.googleapis.com/social-network-9b13f.appspot.com/bank.png',
                                  height: 30,
                                )
                              : null,
                          title: Text(
                            option.shortName.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          displayStringForOption: (BankEntity option) =>
              option.shortName.toString(),
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextFormField(
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 250),
              focusNode: focusNode,
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'hintText',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.lineColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.mainColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
            );
          },
        ),
      ],
    );
  }
}
