import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/settings/items/item.dart';

class SettingsNavigation extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsNavigation({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.value,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsItem(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          subtitle == null
            ? Text(title, style: Theme.of(context).textTheme.bodyMedium)
            : Flexible(
              flex: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  Text(subtitle!, style: Theme.of(context).textTheme.bodySmall,),
                ],
              ),
            ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (value != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      value!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.end,
                    )
                  ),
                ),
              Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ],
      ),
    );
  }
}