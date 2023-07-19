import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:test_project/userRepo.dart';
import 'package:test_project/userView.dart';

import 'main.dart';
import 'model/user.dart';

class Userlistview extends StatefulWidget {
  const Userlistview({Key? key}) : super(key: key);

  @override
  _UserlistviewState createState() => _UserlistviewState();
}

class _UserlistviewState extends State<Userlistview> {
  UserRepo userRepo = UserRepo();
  @override
  void initState() {
    super.initState();
    init();
  }

  UserResponce? res;
  List<User> data = [];
  ScrollController _scrollController = ScrollController();
  int page = 1;
  init() async {
    await getData();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          page < res!.totalPages) {
        page++;
        await getData();
      }
    });
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void hideLoader() {
    Navigator.pop(context);
  }

  getData() async {
    // showOnlyLoaderDialog();
    res = await userRepo.getUsers(page);
    data.addAll(res?.data ?? []);
    // hideLoader();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.people_alt,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(
              width: 10,
            ),
            Text("User List"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: ListView.builder(
            controller: _scrollController,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserView(
                                  user: data[index],
                                )));
                  },
                  child: Container(
                    height: 120,
                    // width: MediaQuery(data: data, child: child),
                    // color: Colors.orange,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width * 0.80,
                            decoration: const BoxDecoration(
                                color: Color(0xFF7301A8),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 70),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${data[index].firstName} ${data[index].lastName}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data[index].email,
                                    style: TextStyle(
                                        color: Colors.grey[100], fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(data[index].avatar)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(65))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
