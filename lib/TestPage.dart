import 'package:flutter/material.dart';
import 'package:bloceventloop/TestBloc.dart';
class TestPage extends StatelessWidget {
  final Bloc testBloc = Bloc();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.amber,
          child: StreamBuilder(
            stream: testBloc.StateStream,
            initialData: testBloc.blocState,
            builder: (context,AsyncSnapshot<BlocState> snap){
              print(snap.data.state);
              return
                Center(
                  child: Column(
                    children: <Widget>[
                      Text('${snap.data.state}'),
                      RaisedButton(
                        child: Text('Init Event in State'),
                        onPressed: (){
                          testBloc.EventSink.add(ExpensiveEventInState());
                        },
                      ),
                      RaisedButton(
                        child: Text('Init Event in Bloc'),
                        onPressed: (){
                          testBloc.EventSink.add(ExpensiveEventInBloc());
                        },
                      ),
                      RaisedButton(
                        child: Text('Init Event in Bloc Funk'),
                        onPressed: (){
                          testBloc.EventSink.add(ExpensiveEventInBlocFunk());
                        },
                      ),
                      RaisedButton(
                        child: Text('Init Event in Bloc Why does This Work????'),
                        onPressed: (){
                          testBloc.EventSink.add(ExpensiveEventWhyDoesThisWork());
                        },
                      )
                    ],
                  ),
                );
            },

          ),
          ),
        ),
      );
  }
}
