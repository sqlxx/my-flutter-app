import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/navigator2/route_state.dart';
import 'package:my_app/screens/initializing_page.dart';

class MyRouterDelegate extends RouterDelegate<RouteState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteState> {
  final GlobalKey<NavigatorState> navigatorKey;
  final RouteState appState;

  MyRouterDelegate(this.appState) : navigatorKey = GlobalKey<NavigatorState>() {
    this.appState.addListener(() {
      debugPrint("notify router to rebuild");
      this.notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _buildPages(),
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route route, result) {
    debugPrint("In _onPopPage");
    if (!route.didPop(result)) return false;

    //TODO: If in the home page, return to the desktop
    // If logged in and in the stack, return to the previous stack
    // If not logged in, or not initialized, has no effect.
    debugPrint("In _onPopPage2");

    return appState.pop();
  }

  @override
  Future<void> setNewRoutePath(RouteState configuration) async {
    debugPrint("In setNewRoutePath");
    notifyListeners();
    return;
  }

  List<Page> _buildPages() {
    List<Page> pages = <Page>[];
    if (!appState.isLogin) {
      pages.add(_createPage(NavItem.loginPage()));
    } else if (appState.isLoading) {
      pages.add(MaterialPage(child: InitializingPage()));
    } else {
      if (appState.navStack.length == 0) {
        pages.add(_createPage(NavItem.homePage()));
      } else {
        pages = appState.navStack.map<Page>((navItem) => _createPage(navItem)).toList();
      }
    }
    debugPrint("In route delegate _buildPages $pages");
    return pages;
  }

  Page _createPage(NavItem navItem) {
    return MaterialPage(key: ValueKey<String>(navItem.path), name: navItem.path, child: navItem.page);
  }
}
