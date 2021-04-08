import 'package:flutter/widgets.dart';

import 'appstate.dart';

class MyRouteInformationParser extends RouteInformationParser<MyAppState> {
  @override
  Future<MyAppState> parseRouteInformation(RouteInformation routeInformation) async {
    // TODO: implement parseRouteInformation
    debugPrint('${routeInformation.location}');
    return MyAppState();
  }

  @override
  RouteInformation? restoreRouteInformation(MyAppState configuration) {
    // TODO: implement restoreRouteInformation
    return super.restoreRouteInformation(configuration);
  }
}
