import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'dart:io';


class Bloc {
  BlocState blocState = BlocState();

  final _StateController = BehaviorSubject<BlocState>();

  StreamSink<BlocState> get _stateSink => _StateController.sink;
  Stream<BlocState> get StateStream => _StateController.stream;

  final _EventController = StreamController<BlocEvent>();
  Sink<BlocEvent> get EventSink => _EventController.sink;

  Bloc() {
    _StateController.listen(_stateUpdateted);
    _stateSink.add(blocState);
    _EventController.stream.listen(_mapEventToState);
  }

  void _stateUpdateted(BlocState state){
   // print('BlocState update: ${blocState.state}');
  }
  void refresh(BlocUIState state) async {
    blocState.state = state;
    _stateSink.add(blocState);
  }

  void _mapEventToState(BlocEvent event) async {
    if (event is ExpensiveEventInState) {
      refresh(BlocUIState.Waiting);
      String result = await blocState.doSomeThing();
      if (result == '') {
        refresh(BlocUIState.Fin);
      } else {
        refresh(BlocUIState.Fail);
      }
    }
    if (event is ExpensiveEventInBloc) {
      refresh(BlocUIState.Waiting);
      String result = await doSomeThing();
      if (result == '') {
        refresh(BlocUIState.Fin);
      } else {
        refresh(BlocUIState.Fail);
      }
    }
    if (event is ExpensiveEventInBlocFunk) {
      refresh(BlocUIState.Waiting);
      String result =  doSomeThingFunk();
      if (result == '') {
        refresh(BlocUIState.Fin);
      } else {
        refresh(BlocUIState.Fail);
      }
    }

    if (event is ExpensiveEventInBlocFunk) {
      refresh(BlocUIState.Waiting);
      String result =  doSomeThingFunk();
      if (result == '') {
        refresh(BlocUIState.Fin);
      } else {
        refresh(BlocUIState.Fail);
      }
    }
    if (event is ExpensiveEventWhyDoesThisWork) {
      refresh(BlocUIState.Waiting);
      await Future.delayed(Duration(seconds: 3));
      refresh(BlocUIState.Fin);
    }
  }
  Future<String> doSomeThing() async {
    String returnValue = '';
    try {
      sleep(Duration(seconds: 3));
    } catch (e) {
      returnValue = e.toString();
    }
    return returnValue;
  }

  String doSomeThingFunk()  {
    String returnValue = '';
    try {
      sleep(Duration(seconds: 3));
    } catch (e) {
      returnValue = e.toString();
    }
    return returnValue;
  }
  void dispose() {
    _StateController.close();
    _EventController.close();
  }
}

class BlocState {
  BlocUIState state = BlocUIState.NotDet;

  int stateData = 0;

  Future<String> doSomeThing() async {
    String returnValue = '';
    try {
      stateData ++;
      sleep(Duration(seconds: 3));
    } catch (e) {
      returnValue = e.toString();
    }
    return returnValue;
  }
}

enum BlocUIState {  NotDet,Waiting,Fail,Fin, }

abstract class BlocEvent{}
class ExpensiveEventInState extends BlocEvent{}
class ExpensiveEventInBloc extends BlocEvent{}
class ExpensiveEventInBlocFunk extends BlocEvent{}
class ExpensiveEventWhyDoesThisWork extends BlocEvent{}