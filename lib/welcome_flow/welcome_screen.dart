import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import 'auth_form.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Pubox'),
        actions: [
          PlatformTextButton(
              child: const Text(
                'Skip'),
              onPressed: () => context.go('/home'))
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: const ContentCarousel(),
    );
  }
}

class ContentCarousel extends StatefulWidget {
  const ContentCarousel({super.key});

  static const tabCount = 4;

  @override
  State<ContentCarousel> createState() => _ContentCarouselState();
}

class _ContentCarouselState extends State<ContentCarousel>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController =
        TabController(length: ContentCarousel.tabCount, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        PageView(
          controller: _pageViewController,
          onPageChanged: _handlePageViewChanged,
          children: <Widget>[
            Center(
              child: Text('First Page', style: textTheme.titleLarge),
            ),
            Center(
              child: Text('Second Page', style: textTheme.titleLarge),
            ),
            Center(
              child: Text('Third Page', style: textTheme.titleLarge),
            ),
            Center(child: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: AuthForm.instance,
            )),
          ],
        ),
        PageIndicator(
          tabController: _tabController,
          currentPageIndex: _currentPageIndex,
          onUpdateCurrentPageIndex: _updateCurrentPageIndex,
          isOnDesktopAndWeb: _isOnDesktopAndWeb,
        ),
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    primaryFocus?.unfocus();
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeInOut,
    );
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }
}

// For Desktop & Web, drag is disabled. User need to click the arrow to navigate
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isOnDesktopAndWeb
                ? IconButton(
                    splashRadius: 16.0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (currentPageIndex == 0) {
                        return;
                      }
                      onUpdateCurrentPageIndex(currentPageIndex - 1);
                    },
                    icon: const Icon(
                      Icons.arrow_left_rounded,
                      size: 32.0,
                    ),
                  )
                : const SizedBox.shrink(),
            TabPageSelector(
              controller: tabController,
              color: colorScheme.surface,
              selectedColor: colorScheme.primary,
            ),
            isOnDesktopAndWeb
                ? IconButton(
                    splashRadius: 16.0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (currentPageIndex == ContentCarousel.tabCount - 1) {
                        return;
                      }
                      onUpdateCurrentPageIndex(currentPageIndex + 1);
                    },
                    icon: const Icon(
                      Icons.arrow_right_rounded,
                      size: 32.0,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
