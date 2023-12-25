import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/home/pages/profile/tabs/profile_posts.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/widgets/screens/profile/header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/feedback/custom_refresh.dart';

class ProfileLayout extends StatefulWidget {
  final String? UUID;
  final String profilePicture;
  final List<Widget> actions;
  final String fullName;
  final String followers;
  final String following;
  final String listings;
  final String jobsDone;
  final String bio;
  final num employerRating;
  final num employerCancelRate;
  final num employeeRating;
  final num employeeCancelRate;
  final String locationText;
  final bool isMe;

  const ProfileLayout(
      {required this.profilePicture,
      required this.actions,
      required this.fullName,
      required this.followers,
      required this.following,
      required this.listings,
      required this.jobsDone,
      required this.bio,
      required this.employerRating,
      required this.employerCancelRate,
      required this.employeeRating,
      required this.employeeCancelRate,
      required this.locationText,
      this.isMe = false,
      this.UUID,
      Key? key})
      : super(key: key);

  @override
  State<ProfileLayout> createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> {
  final ProfilePostsController _postsController = ProfilePostsController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: CustomRefresh(
        onRefresh: () async {
          var token = await AccountCache.getToken();

          if (token == null) return;

          _postsController.refresh!();

          if (widget.isMe) {
            var data = await Api.v1.accounts.me(token);
            
            log('Refreshed account data');

            if (!data.ok) {
              return;
            }

            Provider.of<AuthModel>(context, listen: false).setAccountResponse(data.data!);
            AccountCache.saveAccountResponse(data.data!);
          }
        },
        child: NestedScrollView(
          body: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)!.listings,
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.reviews,
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ProfilePosts(
                      isMe: widget.isMe,
                      controller: _postsController,
                      UUID: widget.UUID,
                    ),
                    ListView(
                      padding: EdgeInsets.zero,
                      children: Colors.primaries.map((color) {
                        return Container(color: color, height: 150.0);
                      }).toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverList(
                delegate: SliverChildListDelegate([
                  ProfileHeader(
                    profilePicture: widget.profilePicture,
                    actions: widget.actions,
                    fullName: widget.fullName,
                    followers: widget.followers,
                    following: widget.following,
                    listings: widget.listings,
                    jobsDone: widget.jobsDone,
                    employeeCancelRate: widget.employeeCancelRate,
                    employeeRating: widget.employeeRating,
                    employerCancelRate: widget.employerCancelRate,
                    employerRating: widget.employerRating,
                    bio: widget.bio.trim(),
                    locationText: widget.locationText.isEmpty ? null : widget.locationText,
                    isMe: widget.isMe,
                  ),
                ]),
              )
            ];
          },
        ),
      ),
    );
  }
}
