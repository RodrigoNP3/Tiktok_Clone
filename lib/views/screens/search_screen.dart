import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/controllers/search_controller.dart';
import 'package:tiktok_clone/views/screens/profile_screen.dart';

import '../../models/user_model.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController searchController = Get.put(SearchController());

  bool cancelSeach = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          appBar: AppBar(
            title: TextFormField(
              onChanged: (value) {
                if (value == '') {
                  setState(() {
                    cancelSeach = true;
                  });
                } else {
                  setState(() {
                    cancelSeach = false;
                  });
                }
              },
              onFieldSubmitted: (value) => searchController.searchUser(value),
              decoration: const InputDecoration(
                filled: false,
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: (searchController.searchedUsers.isEmpty || cancelSeach)
              ? const Center(
                  child: Text(
                    'Search for user',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: searchController.searchedUsers.length,
                  itemBuilder: (context, index) {
                    User user = searchController.searchedUsers[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: user.uid),
                      )),
                      child: !(user.uid == authController.user.uid)
                          ? ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user.profilePhoto),
                              ),
                              title: Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(),
                    );
                  },
                ));
    });
  }
}
