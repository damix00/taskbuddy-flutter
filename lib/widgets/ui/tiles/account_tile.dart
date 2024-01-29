import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/screens/profile/profile_screen.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';

class AccountTile extends StatefulWidget {
  final PublicAccountResponse account;
  final Widget? trailing;
  final bool blocked;

  const AccountTile({Key? key, required this.account, this.trailing, this.blocked = false}) : super(key: key);

  @override
  State<AccountTile> createState() => _SearchResultsAccountState();
}

class _SearchResultsAccountState extends State<AccountTile> {
  late PublicAccountResponse _account;

  @override
  void initState() {
    super.initState();

    _account = widget.account;
  }

  void _openAccount() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ProfileScreen(
          UUID: _account.UUID,
          username: _account.username,
          account: _account,
          blocked: widget.blocked,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Touchable(
          onTap: _openAccount,
          child: SizedBox(
            width: 36,
            height: 36,
            child: ProfilePictureDisplay(size: 36, iconSize: 20, profilePicture: _account.profile.profilePicture)
          ),
        ),
        const SizedBox(width: 12,),
        Expanded(
          child: Touchable(
            onTap: _openAccount,
            child: Text(
              "@${_account.username}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),

        if (_account.verified)
          const SizedBox(width: 4,),
        if (_account.verified)
          const Icon(Icons.verified, size: 16, color: Colors.blue,),

        if (widget.trailing != null)
          widget.trailing!
      ],
    );
  }
}