import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/settings/items/item.dart';

class SettingsCheck extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;

  const SettingsCheck({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SettingsCheckState createState() => _SettingsCheckState();
}

class _SettingsCheckState extends State<SettingsCheck> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SettingsItem(
      enableAnimation: false,
      onTap: () {},
      child: Row(
        children: [
          Icon(widget.icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          widget.subtitle == null
            ? Text(widget.title, style: Theme.of(context).textTheme.bodyMedium)
            : Flexible(
              flex: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: Theme.of(context).textTheme.bodyMedium),
                  Text(widget.subtitle!, style: Theme.of(context).textTheme.bodySmall,),
                ],
              ),
            ),
          const Spacer(),
          Switch.adaptive(
            value: _value,
            onChanged: (v) {
              setState(() {
                _value = v;
              });
              widget.onChanged(v);
            },
          )
        ],
      ),
    );
  }
}