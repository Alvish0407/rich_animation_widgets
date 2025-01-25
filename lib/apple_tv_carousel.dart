import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppleTvCarousel extends StatefulWidget {
  const AppleTvCarousel({super.key});

  @override
  State<AppleTvCarousel> createState() => _AppleTvCarouselState();
}

class _AppleTvCarouselState extends State<AppleTvCarousel> {
  late final CarouselController controller;

  @override
  void initState() {
    super.initState();
    controller = CarouselController();
    controller.addListener(() {
      setState(() {});
      log("scrollPosition: ${controller.position.pixels}");
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // [controller] gets binded to the widget after the frame is rendered
      // so update the state to update the indicators
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final posters = [
      "https://www.apple.com/newsroom/images/product/apple-fitness-plus/Apple-Today-at-Apple-session-Ted-Lasso-hero.jpg.news_app_ed.jpg",
      "https://m.media-amazon.com/images/M/MV5BNjQzNGQ3MGYtM2EyZS00ZWIxLWFkOWMtNWM5Y2UxNzQwNmFiXkEyXkFqcGc@._V1_.jpg",
      "https://i.pinimg.com/originals/f8/9e/6c/f89e6c4c4c6b9b1e7d60af56e197efd7.jpg",
      "https://wallpapercat.com/w/full/6/a/f/1743991-1530x2175-phone-hd-see-tv-series-wallpaper.jpg",
      "https://m.media-amazon.com/images/M/MV5BNDAwNWMzNDYtNGM1ZS00NTQzLWExNjMtYjRjZWQ5ZWYwNzdkXkEyXkFqcGc@._V1_.jpg",
      "https://pbs.twimg.com/media/GNFC5wRW4AA4V0o?format=jpg&name=4096x4096",
      "https://m.media-amazon.com/images/M/MV5BZmQ4ZjhiMjctMmJlMi00NzE1LWI0ZmEtNTgwYTk1OGU2MDEyXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg",
    ];

    return Scaffold(
      body: SizedBox(
        height: 650,
        child: Stack(
          children: [
            CarouselView(
              itemExtent: width,
              itemSnapping: true,
              enableSplash: false,
              controller: controller,
              padding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              children: List.generate(
                posters.length,
                (index) {
                  return Image.network(
                    posters[index],
                    height: 200,
                    fit: BoxFit.cover, // Change to fill, contain to see different effects
                  );
                },
              ).toList(),
            ),
            if (controller.hasClients)
              () {
                // set the index as current, only if the whole image is visible
                final currentIndex = (controller.position.pixels / width).round();

                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 15,
                  child: _CarouselIndicators(
                    length: posters.length,
                    currentIndex: currentIndex,
                  ),
                );
              }(),
          ],
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        iconSize: 24,
        activeColor: CupertinoColors.activeBlue,
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.house_fill), label: "Home"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.tv_fill), label: "Apple TV+"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.bag_fill), label: "Store"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.square_stack_fill), label: "Library"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: "Search"),
        ],
      ),
    );
  }
}

class _CarouselIndicators extends StatefulWidget {
  const _CarouselIndicators({
    required this.length,
    required this.currentIndex,
  });

  final int length;
  final int currentIndex;

  @override
  State<_CarouselIndicators> createState() => _CarouselIndicatorsState();
}

class _CarouselIndicatorsState extends State<_CarouselIndicators> {
  final indicatorRadius = 7.0;

  final _animationDuration = const Duration(milliseconds: 250);
  final _animationCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.length,
        (index) {
          final isIndicatorActive = index == widget.currentIndex;

          return _backgroundIndicator(isIndicatorActive, index);
        },
      ),
    );
  }

  AnimatedContainer _backgroundIndicator(bool isActive, int index) {
    return AnimatedContainer(
      key: ValueKey(index),
      curve: _animationCurve,
      height: indicatorRadius,
      duration: _animationDuration,
      alignment: Alignment.centerLeft,
      width: isActive ? 23 : indicatorRadius,
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.circular(99),
      ),
      child: _forgroundIndicator(isActive),
    );
  }

  AnimatedContainer _forgroundIndicator(bool isActive) {
    return AnimatedContainer(
      curve: _animationCurve,
      duration: _animationDuration,
      width: isActive ? indicatorRadius : 0,
      height: isActive ? indicatorRadius : 0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
