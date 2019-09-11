import 'dart:async';
import 'package:rxdart/rxdart.dart';

class CounterBloc {
  CounterBlocState blocState = CounterBlocState();

  final _StateController = BehaviorSubject<CounterBlocState>();

  StreamSink<CounterBlocState> get _stateSink => _StateController.sink;
  Stream<CounterBlocState> get StateStream => _StateController.stream;

  final _EventController = StreamController<CounterBlocEvent>();
  Sink<CounterBlocEvent> get EventSink => _EventController.sink;

  CounterBloc() {
    _stateSink.add(blocState);
    _EventController.stream.listen(_mapEventToState);
  }


  void refresh(CounterBlocUIState state) async {
    blocState.state = state;
    _stateSink.add(blocState);
  }

  void _mapEventToState(CounterBlocEvent event) async {
    if (event is AddEvent) {
      refresh(CounterBlocUIState.Waiting);
      String result = await blocState.Add();
      if (result == '') {
        refresh(CounterBlocUIState.Fin);
      } else {
        refresh(CounterBlocUIState.Fail);
      }
    }

  }
  void dispose() {
    _StateController.close();
    _EventController.close();
  }
}

class CounterBlocState {
  CounterBlocUIState state = CounterBlocUIState.NotDet;

  int stateData = 0;

  Future<String> Add() async {
    String returnValue = '';
    try {
      stateData ++;
      await Future.delayed(Duration(seconds: 3));
    } catch (e) {
      returnValue = e.toString();
    }
    return returnValue;
  }
}

enum CounterBlocUIState {  NotDet,Waiting,Fail,Fin, }

abstract class CounterBlocEvent{}
class AddEvent extends CounterBlocEvent{}
