import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
      String result;
      try{
        result =
        await blocState.add().then((value){
          if(value !=null){
            return '';
          }else{
            return 'fail';
          }
        });
      }catch(e){

      }


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


  Future<String> add() async {
    // Use the compute function to run parsePhotos in a separate isolate.
    final int res = stateData + int.parse(await compute(sleeping, '1'));
    // The result variable MUST be final, otherwise the app crashes
    stateData = res;
    return '';
  }

// The computed Function must be 'static' or there will be an exception
  //Also if using 'compute() the Function must look like static String functionName(String argument)(){} '
 static String sleeping(String addNumber) {
    sleep(Duration(seconds: 3));
    return addNumber;
  }
}

enum CounterBlocUIState {  NotDet,Waiting,Fail,Fin, }

abstract class CounterBlocEvent{}
class AddEvent extends CounterBlocEvent{}

