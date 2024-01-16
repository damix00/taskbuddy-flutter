import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/state/remote_config.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:taskbuddy/widgets/overlays/loading_overlay.dart';
import 'package:taskbuddy/widgets/screens/chat/menu/sheet_action.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/screens/chat/menu/sheet_divider.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';

class MenuSheet extends StatelessWidget {
  final ChannelResponse channel;
  final Function(MessageResponse) onMessage;

  const MenuSheet({Key? key, required this.channel, required this.onMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    var padding = MediaQuery.of(context).padding;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: BlurParent(
        blurColor: Theme.of(context).colorScheme.background.withOpacity(0.75),
        noBlurColor: Theme.of(context).colorScheme.surface,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: padding.top),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SheetAction(
                onPressed: () {},
                label: l10n.media,
                icon: Icons.image_outlined,
              ),
              SheetAction(
                onPressed: () {},
                label: l10n.files,
                icon: Icons.insert_drive_file_outlined,
              ),
              if (channel.isPostCreator && (channel.status == ChannelStatus.PENDING || channel.status == ChannelStatus.CANCELLED))
                SheetDivider(label: l10n.employerOptions),
              if (channel.isPostCreator && (channel.status == ChannelStatus.PENDING || channel.status == ChannelStatus.CANCELLED))
                SheetAction(
                  onPressed: () async {
                    LoadingOverlay.showLoader(context);

                    String token = (await AccountCache.getToken())!;

                    var res = await Api.v1.channels.actions.manageWorker(
                      token,
                      channel.uuid,
                      true
                    );

                    if (res.ok) {
                      onMessage(res.data!);
                    }

                    LoadingOverlay.hideLoader(context);

                    Navigator.pop(context);
                  },
                  label: l10n.chooseEmployee,
                  icon: Icons.check
                ),
              if (channel.isPostCreator && channel.status != ChannelStatus.REJECTED && channel.status != ChannelStatus.ACCEPTED)
                SheetAction(
                  onPressed: () async {
                    LoadingOverlay.showLoader(context);

                    String token = (await AccountCache.getToken())!;

                    var res = await Api.v1.channels.actions.manageWorker(
                      token,
                      channel.uuid,
                      false
                    );

                    if (res.ok) {
                      SnackbarPresets.show(context, text: l10n.jobSuccessfullyDeclined);
                    }

                    LoadingOverlay.hideLoader(context);

                    Navigator.pop(context);
                  },
                  label: l10n.rejectEmployee,
                  icon: Icons.close
                ),
              SheetDivider(label: l10n.jobOptions),
              SheetAction(
                onPressed: () async {
                  String value = "";

                  // Open a popup to enter the price
                  String? price = await showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog.adaptive(
                      title: Text(
                        l10n.negotiatePrice,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      content: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: l10n.pricePlaceholder,
                        ),
                        onChanged: (v) => value = v,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, value),
                          child: Text(l10n.accept),
                        ),
                      ],
                    ),
                  );

                  if (price == null) return;

                  if (double.tryParse(price) == null) {
                    SnackbarPresets.error(context, l10n.invalidPrice);
                    return;
                  }

                  var priceNum = double.parse(price);

                  if (priceNum < RemoteConfigData.minPrice || priceNum > RemoteConfigData.maxPrice) {
                    SnackbarPresets.error(context, l10n.numRange(RemoteConfigData.minPrice, RemoteConfigData.maxPrice));
                    return;
                  }
                  
                  LoadingOverlay.showLoader(context);

                  String token = (await AccountCache.getToken())!;

                  var res = await Api.v1.channels.actions.negotiatePrice(
                    token,
                    channel.uuid,
                    priceNum
                  );

                  if (res.ok) {
                    onMessage(res.data!);
                  }
                  
                  else {
                    SnackbarPresets.error(context, l10n.somethingWentWrong);
                  }

                  LoadingOverlay.hideLoader(context);
                },
                label: l10n.negotiatePrice,
                icon: Icons.attach_money_outlined,
              ),
              SheetAction(
                onPressed: () async {
                  DateTime? date;

                  // Open a popup to enter the date
                  date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );

                  if (date == null) return;

                  // Choose time
                  var d = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (d == null) return;

                  date = DateTime(date.year, date.month, date.day, d.hour, d.minute);

                  LoadingOverlay.showLoader(context);

                  String token = (await AccountCache.getToken())!;

                  var res = await Api.v1.channels.actions.negotiateDate(
                    token,
                    channel.uuid,
                    date
                  );

                  if (res.ok) {
                    onMessage(res.data!);
                  }
                  
                  else {
                    SnackbarPresets.error(context, l10n.somethingWentWrong);
                  }
                  
                  LoadingOverlay.hideLoader(context);
                },
                label: l10n.changeDate,
                icon: Icons.calendar_today_outlined,
              ),
              if (channel.status == ChannelStatus.ACCEPTED)
                SheetAction(
                  onPressed: () async {
                    LoadingOverlay.showLoader(context);

                    String token = (await AccountCache.getToken())!;

                    var res = await Api.v1.channels.actions.cancelJob(
                      token,
                      channel.uuid,
                    );
                    
                    if (!res) {
                      SnackbarPresets.error(context, l10n.somethingWentWrong);
                    }

                    LoadingOverlay.hideLoader(context);

                    Navigator.pop(context);
                  },
                  label: l10n.cancelJob,
                  icon: Icons.close,
                ),
              if (channel.status == ChannelStatus.ACCEPTED && !channel.isPostCreator)
                SheetAction(
                  onPressed: () {},
                  label: l10n.completeJob,
                  icon: Icons.check,
                ),
        
              SizedBox(height: padding.bottom + 16),
            ],
          ),
        )
      ),
    );
  }
}
