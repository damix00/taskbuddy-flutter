import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChanged;
  final Function()? onSearch;
  final Function()? onTap;
  final Color? fillColor;

  const SearchInput({
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSearch,
    this.onTap,
    this.fillColor,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        onTap?.call();
      },
      child: TextField(
        style: TextStyle(
          fontSize: 14,
        ),
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.streetAddress,
        onSubmitted: (_) => onSearch?.call(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          hintStyle: Theme.of(context).textTheme.labelMedium,
          fillColor: fillColor ?? Theme.of(context).colorScheme.background,
          filled: true,
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}