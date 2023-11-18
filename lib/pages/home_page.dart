import 'package:actnlog_lite/components/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../components/add_new_preset.dart';
import '../views/history.dart';
import '../views/home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: SvgPicture.asset('assets/home-logo.svg'),
        actions: [
          Visibility(
            visible: currentPageIndex == 0,
            child: IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return const AddNewPreset();
                  },
                );
              },
              color: const Color.fromRGBO(21, 55, 122, 1.0),
              icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white70),
              splashColor: const Color.fromRGBO(21, 55, 122, 1.0),
              splashRadius: 20,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(Icons.settings_outlined),
            splashColor: Colors.white,
            splashRadius: 20,
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.black87,
        indicatorColor: const Color.fromRGBO(43,111,243, 1.0),
        surfaceTintColor: Colors.black87,
        shadowColor: Colors.transparent,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: SvgPicture.asset('assets/home.svg'),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Colors.black87,
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: HomeView()),
              TimerWidget()
            ],
          ),
        ),
        Container(
          color: Colors.black87,
          alignment: Alignment.topCenter,
          child: const HistoryView(),
        ),
      ][currentPageIndex],
    );
  }
}
