import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/account/login_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/utils/dates.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';

class LoginSessionsScreen extends StatelessWidget {
  const LoginSessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          l10n.loginSessions,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      extendBodyBehindAppBar: true,
      body: const _PageContent()
    );
  }
}

class _PageContent extends StatefulWidget {
  const _PageContent({Key? key}) : super(key: key);

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> {
  bool _loading = true;
  List<LoginResponse> _sessions = [];

  void _fetchSessions() async {
    setState(() {
      _loading = true;
    });

    String token = (await AccountCache.getToken())!;

    var sessions = await Api.v1.accounts.meRoute.security.sessions.getSessions(token);

    setState(() {
      _loading = false;
      _sessions = sessions;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
      ? const Center(child: CrossPlatformLoader())
      : ListView.builder(
        itemCount: _sessions.length,
        itemBuilder: (context, index) {
          LoginResponse session = _sessions[index];
          String? os = session.userAgent.split("/").firstOrNull;

          return Padding(
            padding: EdgeInsets.only(
              top: index == 0 ? MediaQuery.of(context).padding.top : 0,
              bottom: index == _sessions.length - 1 ? MediaQuery.of(context).padding.bottom : 0,
            ),
            child: ListTile(
              title: Text(session.ipAddress),
              subtitle: Text("${os ?? session.userAgent} · ${Dates.formatDateCompact(session.createdAt)}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  String token = (await AccountCache.getToken())!;
          
                  await Api.v1.accounts.meRoute.security.sessions.deleteSession(token, session.id);

                  setState(() {
                    _sessions.removeAt(index);
                  });
                },
              ),
            ),
          );
        }
      );
  }
}
