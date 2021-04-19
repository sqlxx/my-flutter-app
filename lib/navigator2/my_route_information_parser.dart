import 'package:flutter/widgets.dart';

import 'route_state.dart';

class MyRouteInformationParser extends RouteInformationParser<RouteState> {
  @override
  Future<RouteState> parseRouteInformation(RouteInformation routeInformation) async {
    // TODO: implement parseRouteInformation
    debugPrint('${routeInformation.location}');
    return RouteState();
  }

  @override
  RouteInformation? restoreRouteInformation(RouteState configuration) {
    // TODO: implement restoreRouteInformation
    return super.restoreRouteInformation(configuration);
  }
}
