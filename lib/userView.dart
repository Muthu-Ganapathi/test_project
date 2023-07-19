import 'package:flutter/material.dart';
import 'package:test_project/model/user.dart';
import 'package:test_project/userRepo.dart';

import 'model/userDetails.dart';

class UserView extends StatefulWidget {
  final User user;
  const UserView({Key? key, required this.user}) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  UserRepo userRepo = UserRepo();
  @override
  void initState() {
    super.initState();
    getData();
  }

  UserDetails? res;
  getData() async {
    // showOnlyLoaderDialog();
    res = await userRepo.getUser(widget.user);

    // hideLoader();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: res != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(res!.data.avatar ?? "")),
                            borderRadius:
                                BorderRadius.all(Radius.circular(75))),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "${res!.data.firstName} ${res!.data.lastName}",
                    style: TextStyle(color: Colors.black, fontSize: 21),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    res!.data.email,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
