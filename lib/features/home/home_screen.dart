import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wearable_app/features/home/home_viewmodel.dart';
import 'package:wearable_app/services/notification_service.dart';
import 'package:wearable_app/services/watch_connectivity_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(homeViewModel).messageStream();
  }

  @override
  Widget build(BuildContext context) {
    var watchViewModel = ref.watch(homeViewModel);
    var readViewModel = ref.read(homeViewModel.notifier);

    String hours = ref.read(homeViewModel).formatTime(watchViewModel.hours);
    String minutes = ref.read(homeViewModel).formatTime(watchViewModel.minutes);
    String seconds = ref.read(homeViewModel).formatTime(watchViewModel.seconds);
    bool isPaused = ref.watch(homeViewModel).isPaused;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            SvgPicture.asset(
              'assets/svg/time-03-stroke-rounded.svg',
              height: 60.0,
            ),
            SizedBox(
              height: 100.0,
            ),
            Center(
              child: Text(
                '$hours $minutes $seconds',
                style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.0,
                  width: 70.0,
                  child: CupertinoPicker(
                    backgroundColor: CupertinoColors.white,
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        watchViewModel.hours = index;
                        log('hours: ${watchViewModel.hours}');
                      });
                    },
                    children: List.generate(
                      60,
                      (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Center(
                              child: Text(index.toString().padLeft(2, '0'))),
                        );
                      },
                    ),
                  ),
                ),
                Text('Hours', style: TextStyle(fontSize: 11.0)),
                SizedBox(
                  width: 10.0,
                ),
                SizedBox(
                  height: 50.0,
                  width: 70.0,
                  child: CupertinoPicker(
                    backgroundColor: CupertinoColors.white,
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        watchViewModel.minutes = index;
                        log('minutes: ${watchViewModel.minutes}');
                      });
                    },
                    children: List.generate(
                      60,
                      (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Center(
                              child: Text(index.toString().padLeft(2, '0'))),
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  'Minutes',
                  style: TextStyle(fontSize: 11.0),
                ),
                SizedBox(
                  height: 50.0,
                  width: 70.0,
                  child: CupertinoPicker(
                    backgroundColor: CupertinoColors.white,
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        watchViewModel.seconds = index;
                        log('seconds: ${watchViewModel.seconds}');
                      });
                    },
                    children: List.generate(
                      60,
                      (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Center(
                              child: Text(index.toString().padLeft(2, '0'))),
                        );
                      },
                    ),
                  ),
                ),
                Text('Seconds', style: TextStyle(fontSize: 11.0)),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      isPaused
                          ? readViewModel.startTimer()
                          : readViewModel.pauseTimer();
                    },
                    icon: Row(
                      children: [
                        SvgPicture.asset(
                          isPaused
                              ? 'assets/svg/play-stroke-rounded.svg'
                              : 'assets/svg/pause-stroke-rounded.svg',
                          height: 30.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          isPaused ? 'Start' : 'Pause',
                          style: TextStyle(fontSize: 12.0),
                        )
                      ],
                    )),
                IconButton(
                    onPressed: () {
                      readViewModel.stopTimer();
                    },
                    icon: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/stop-stroke-rounded.svg',
                          height: 30.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Stop',
                          style: TextStyle(fontSize: 12.0),
                        )
                      ],
                    )),
                IconButton(
                    onPressed: () {
                      readViewModel.resetTimer();
                    },
                    icon: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/refresh-stroke-rounded.svg',
                          height: 25.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Reset',
                          style: TextStyle(fontSize: 12.0),
                        )
                      ],
                    )),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
