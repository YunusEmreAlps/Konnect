import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:konnect/components/auth.dart';
import 'package:konnect/components/users_list.dart';
import 'package:konnect/constants.dart';
import 'package:konnect/models/user_model.dart';
import 'package:flutter/material.dart';

class SearchUsers extends StatefulWidget {
  final List<String> otherUsersIdList;
  final List<QueryDocumentSnapshot> docList;

  SearchUsers({this.otherUsersIdList, this.docList});

  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  var _controller = TextEditingController();
  List<UserWidget> userslist = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        title: Text('Add users'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Search Users by Name",
                  labelStyle: TextStyle(color: primaryColor),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                    borderRadius: BorderRadius.circular(10),
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
