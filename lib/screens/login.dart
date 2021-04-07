import 'package:flutter/material.dart';
import 'package:my_app/bloc/bloc.dart';
import 'package:my_app/screens/initializing_page.dart';

import '../main.dart';

abstract class AuthenticationEvent extends BlocEvent {
  final String name;
  AuthenticationEvent({
    this.name: '',
  });
}

class AuthenticationEventLogin extends AuthenticationEvent {
  AuthenticationEventLogin({
    String name,
  }) : super(name: name);
}

class AuthenticationEventLogout extends AuthenticationEvent {}

class AuthenticationState extends BlocState {
  final bool isAuthenticated;
  final bool isAuthenticating;
  final bool hasFailed;

  final String name;

  AuthenticationState({
    @required this.isAuthenticated,
    this.isAuthenticating: false,
    this.hasFailed: false,
    this.name: '',
  });

  factory AuthenticationState.notAuthenticated() {
    return AuthenticationState(
      isAuthenticated: false,
    );
  }

  factory AuthenticationState.authenticating() {
    return AuthenticationState(isAuthenticated: false, isAuthenticating: true);
  }

  factory AuthenticationState.authenticated(String name) {
    return AuthenticationState(isAuthenticated: true, name: name);
  }
  factory AuthenticationState.failure() {
    return AuthenticationState(isAuthenticated: false, hasFailed: true);
  }
}

class AuthenticationBloc extends BlocEventStateBase<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(initialState: AuthenticationState.notAuthenticated());

  @override
  Stream<AuthenticationState> eventHandler(AuthenticationEvent event, AuthenticationState currentState) async* {
    if (event is AuthenticationEventLogin) {
      yield AuthenticationState.authenticating();

      await Future.delayed(const Duration(seconds: 2));

      if (event.name == "failure") {
        yield AuthenticationState.failure();
      } else {
        yield AuthenticationState.authenticated('sqlxx');
      }
    } else if (event is AuthenticationEventLogout) {
      yield AuthenticationState.notAuthenticated();
    }
  }
}

class DecisionPage extends StatefulWidget {
  @override
  _DecisionPageState createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  AuthenticationState _oldState;
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocEventStateBuilder<AuthenticationEvent, AuthenticationState>(
        bloc: bloc,
        builder: (context, state) {
          debugPrint('$state');
          if (state != _oldState) {
            _oldState = state;
            if (state.isAuthenticated) {
              _redirectToPage(context, InitializingPage());
            } else if (state.isAuthenticating || state.hasFailed) {
              // do nothing
            } else {
              _redirectToPage(context, LoginPage());
            }
          }
          return Container();
        });
  }

  _redirectToPage(BuildContext context, Widget widget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
    });
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthenticationBloc>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Container(
          child: BlocEventStateBuilder<AuthenticationEvent, AuthenticationState>(
              bloc: bloc,
              builder: (context, state) {
                if (state.isAuthenticating || state.isAuthenticated) {
                  return Text('Logging');
                }

                List<Widget> children = <Widget>[];
                children.add(
                  ElevatedButton(
                    child: Text('Login Success'),
                    onPressed: () => bloc.emitEvent(AuthenticationEventLogin(name: 'sqlxx')),
                  ),
                );

                children.add(
                  ElevatedButton(
                    child: Text('Login Failure'),
                    onPressed: () => bloc.emitEvent(AuthenticationEventLogin(name: 'failure')),
                  ),
                );

                if (state.hasFailed) {
                  children.add(Text('Login Failed'));
                }
                return Column(children: children);
              }),
        ),
      ),
    );
  }
}
