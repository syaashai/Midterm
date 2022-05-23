import 'package:flutter/material.dart';
import '/models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MYtutor'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text(widget.user.name.toString()),
                accountEmail: Text(widget.user.email.toString()),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://yt3.ggpht.com/a/AATXAJyAi_BhKSr-j8Od_1jghYmAERow_f3lBy-gMA=s900-c-k-c0xffffffff-no-rj-mo"),
                )),
            _createDrawerItem(
              icon: Icons.book,
              text: 'My subjects',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.schedule,
              text: 'Schedule',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () {},
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('MYtutor'),
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
