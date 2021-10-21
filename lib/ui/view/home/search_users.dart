// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:konnect/core/constants/core.dart';
import 'package:konnect/core/model/user_model.dart';
import 'package:konnect/ui/components/auth.dart';
import 'package:konnect/ui/components/users_list.dart';

class SearchUsers extends StatefulWidget {
  final List<String> otherUsersIdList;
  final List<QueryDocumentSnapshot> docList;

  SearchUsers({this.otherUsersIdList, this.docList});

  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  bool isKeyboardVisible = true;
  var _controller = TextEditingController();
  List<UserWidget> userslist = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // User must be online for first chat
  void checkUser() {
    userslist.clear();
    if (widget.docList.isNotEmpty) {
      for (var item in widget.docList) {
        if (!((widget.otherUsersIdList.contains(item.id)) ||
            (uid == item.id))) {
          //Existing users and own remove from search
          if (item
                  .data()['name']
                  .toLowerCase()
                  .toString()
                  .startsWith(_controller.text.toLowerCase()) &&
              _controller.text != '') {
                print(_controller.text);
            setState(
              () {
                userslist.add(
                  UserWidget(
                    userModel: UserModel(
                        name: item.data()['name'],
                        photoURL: item.data()['photoURL'],
                        uid: item.id),
                  ),
                );
              },
            );
          }
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.ADD_USERS),
        centerTitle: true,
        backgroundColor: AppColors.colorPrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: AppStrings.USERNAME, // "Search Users by Name"
                  hintStyle: TextStyle(
                    fontSize: 14, color: AppColors.colorBackButton,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Container(
                    margin: EdgeInsets.only(bottom: 0),
                    child: Icon(
                      Icons.search,
                      color: AppColors.colorBackButton,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 0,
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 0,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                onChanged: (String str) {
                  checkUser();
                },
                keyboardType: TextInputType.name,
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 200,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: userslist.length,
                  itemBuilder: (context, index) {
                    return userslist[index];
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    thickness: 2,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
