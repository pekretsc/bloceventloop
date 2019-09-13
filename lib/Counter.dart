import 'package:flutter/material.dart';
import 'package:bloceventloop/CounterBloc.dart';
class Counter  extends StatelessWidget {
  final CounterBloc counterBloc= CounterBloc();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Counter'
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            counterBloc.EventSink.add(AddEvent());
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Center(
          child: StreamBuilder(
            stream: counterBloc.StateStream,
            initialData: counterBloc.blocState,
            // ignore: missing_return
            builder: (context, AsyncSnapshot<CounterBlocState> snap){
              print(snap.data.state);
               switch(snap.data.state) {
                         case CounterBlocUIState.NotDet: {
                           return Center(
                             child: Text(
                                 snap.data.stateData.toString()
                             ),
                           );
                         }
                         break;

                         case CounterBlocUIState.Waiting: {
                           return Center(
                             child: CircularProgressIndicator()
                           );
                         }
                         break;
                         case CounterBlocUIState.Fail: {
                           return Center(
                             child: Text(
                                 'Fail'
                             ),
                           );
                           //statements;
                         }
                         break;
                         case CounterBlocUIState.Fin: {
                           return Center(
                             child: Text(
                                 snap.data.stateData.toString()
                             ),
                           );
                         }
                         break;
                         /*default: {
                           //statements;
                         }
                         break;*/
                       }
            },
          ),
        ),
      )
    );
  }
}
