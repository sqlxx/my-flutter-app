import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/animation.dart';
import 'package:my_app/appbar.dart';
import 'package:my_app/layout.dart';
import 'package:my_app/main.dart';
import 'package:my_app/screens/bloc_counter.dart';
import 'package:my_app/screens/catalog.dart';
import 'package:my_app/screens/initializing_page.dart';
import 'package:my_app/screens/login.dart';
import 'package:my_app/shopping.dart';
import 'package:my_app/snakebar.dart';

class RouteState extends ChangeNotifier {
  static const String PATH_HOME = '/';
  static const String PATH_LAYOUT = '/layout';
  static const String PATH_SHOPPING = '/shopping';
  static const String PATH_RANDOM_WORDS = '/random-words';
  static const String PATH_MY_APP_BAR = '/my-app-bar';
  static const String PATH_ANIMATION = '/animation';
  static const String PATH_CATALOG = '/catalog';
  static const String PATH_SNACK_BAR = '/snack-bar';
  static const String PATH_BLOC_COUNTER = '/bloc-counter';

  static final Set<NavItem> navPaths = {
    NavItem(path: PATH_HOME, page: SwitchPanel()),
    NavItem(path: PATH_LAYOUT, page: LayoutApp()),
    NavItem(path: PATH_SHOPPING, page: ShoppingApp()),
    NavItem(path: PATH_RANDOM_WORDS, page: RandomWords()),
    NavItem(path: PATH_MY_APP_BAR, page: TutorialHome()),
    NavItem(path: PATH_ANIMATION, page: LogoApp()),
    NavItem(path: PATH_CATALOG, page: MyCatalog()),
    NavItem(path: PATH_SNACK_BAR, page: SnakeBarPage()),
    NavItem(path: PATH_BLOC_COUNTER, page: BlocCounterScreen()),
  };

  RouteState()
      : navMap = {for (var item in navPaths) item.path: item},
        _isLogin = false,
        isLoading = false {
    this.navStack.add(NavItem.homePage());
  }

  final Map<String, NavItem> navMap;
  bool _isLogin;
  bool isLoading;
  List<NavItem> navStack = <NavItem>[];

  set isLogin(bool isLogin) {
    if (this._isLogin != isLogin) {
      debugPrint('MyAppState isLogin: from ${this._isLogin} to $isLogin, ${this.hasListeners}');
      this._isLogin = isLogin;
      notifyListeners();
    }
  }

  bool get isLogin => this._isLogin;

  bool pop() {
    if (navStack.length > 1) {
      navStack.removeLast();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void push(String path) {
    if (navStack.last.path != path) {
      navStack.add(navMap[path]!);
      notifyListeners();
    }
  }
}

class NavItem {
  final String path;
  final Widget page;

  NavItem({required this.path, required this.page});

  factory NavItem.loginPage() => NavItem(path: '/login', page: LoginPage());
  factory NavItem.loadingPage() => NavItem(path: '/loading', page: InitializingPage());
  factory NavItem.homePage() => NavItem(path: RouteState.PATH_HOME, page: SwitchPanel());
}
