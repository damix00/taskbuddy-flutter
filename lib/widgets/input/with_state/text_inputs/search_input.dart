import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChanged;
  final Function()? onSearch;
  final Function()? onTap;
  final Color? fillColor;
  final bool? enabled;
  final double? borderRadius;
  final bool showIcon;
  final String? initialValue;

  const SearchInput({
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSearch,
    this.onTap,
    this.fillColor,
    this.enabled,
    this.borderRadius,
    this.showIcon = true,
    this.initialValue,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        onTap?.call();
      },
      child: TextFormField(
        enabled: enabled,
        style: TextStyle(
          fontSize: 14,
        ),
        initialValue: initialValue,
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.streetAddress,
        onFieldSubmitted: (_) => onSearch?.call(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(borderRadius ?? 8),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            borderSide: BorderSide.none,
          ),
          hintStyle: Theme.of(context).textTheme.labelMedium,
          fillColor: fillColor ?? Theme.of(context).colorScheme.background,
          filled: true,
          prefixIcon: showIcon ? const Icon(Icons.search) : null,
        ),
      ),
    );
  }
}

class SearchInputButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color? color;

  const SearchInputButton({
    this.onTap,
    required this.text,
    this.color,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant,),
            const SizedBox(width: 12,),
            Text(
              text,
              style: Theme.of(context).textTheme.labelMedium
            ),
          ],
        ),
      ),
    );
  }
}
