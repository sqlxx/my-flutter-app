import 'package:flutter/material.dart';
import 'package:my_app/bloc/bloc.dart';
import 'package:my_app/main.dart';

class ApplicationInitializeEvent implements BlocEvent {
  final ApplicationInitializeEventType type;

  ApplicationInitializeEvent({this.type: ApplicationInitializeEventType.start});
}

enum ApplicationInitializeEventType { start, stop }

class ApplicationInitializeState implements BlocState {
  final bool isInitialized;
  final bool isInitialing;
  final int progress;

  ApplicationInitializeState({required this.isInitialized, this.isInitialing: false, this.progress: 0});

  factory ApplicationInitializeState.notInitialized() {
    return ApplicationInitializeState(isInitialized: false);
  }

  factory ApplicationInitializeState.initializing(int progress) {
    return ApplicationInitializeState(isInitialized: false, isInitialing: true, progress: progress);
  }

  factory ApplicationInitializeState.initialized() {
    return ApplicationInitializeState(isInitialized: true);
  }
}

class ApplicationInitializeBloc extends BlocEventStateBase<ApplicationInitializeEvent, ApplicationInitializeState> {
  ApplicationInitializeBloc() : super(initialState: ApplicationInitializeState.notInitialized());

  @override
  Stream<ApplicationInitializeState> eventHandler(
      ApplicationInitializeEvent event, ApplicationInitializeState currentState) async* {
    if (!currentState.isInitialized) {
      yield ApplicationInitializeState.notInitialized();
    }

    if (event.type == ApplicationInitializeEventType.start) {
      yield ApplicationInitializeState.initializing(0);

      for (int i = 1; i <= 10; i++) {
        await Future.delayed(Duration(milliseconds: 100));
        debugPrint("delay 1 sec");
        yield ApplicationInitializeState.initializing(i * 10);
      }

      yield ApplicationInitializeState.initialized();
    }
  }
}

class InitializingPage extends StatefulWidget {
  @override
  _InitializingPageState createState() => _InitializingPageState();
}

class _InitializingPageState extends State<InitializingPage> {
  ApplicationInitializeBloc _bloc = ApplicationInitializeBloc();
  @override
  void initState() {
    super.initState();
    _bloc.emitEvent(ApplicationInitializeEvent());
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocEventStateBuilder<ApplicationInitializeEvent, ApplicationInitializeState>(
        bloc: _bloc,
        builder: (context, data) {
          Widget widget = Text('开始初始化');
          if (data.isInitialing) {
            widget = Text('${data.progress}');
          }

          if (data.isInitialized) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              // Navigator.pushAndRemoveUntil(
              //     context, MaterialPageRoute(builder: (_) => SwitchPanel()), ModalRoute.withName("/"));
            });
            widget = Text('初始化完成');
          }

          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [widget],
            ),
          );
        });
  }
}
