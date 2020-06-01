import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quizflutter/result.dart';

class loadjson extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future:DefaultAssetBundle.of(context).loadString("assets/python.json") ,
          builder: (context, snapshot) {
            List mydata=json.decode(snapshot.data.toString());
            if(mydata==null)
              {
                return Center(
                  child: Text("loading"),
                );
              }
            else
                {
                 return quizpage(mydata:mydata);
                }
          },
      ),
    );
  }
}


class quizpage extends StatefulWidget {
  final mydata;

  quizpage({Key key,@required this.mydata}):super(key: key);
  @override
  _quizpageState createState() => _quizpageState(mydata:mydata);
}

class _quizpageState extends State<quizpage> {
  List mydata;
  _quizpageState({this.mydata});
  int i=1;
  int marks=0;

  Map<String, Color> btncolor = {
    "a": Colors.indigoAccent,
    "b": Colors.indigoAccent,
    "c": Colors.indigoAccent,
    "d": Colors.indigoAccent,
  };
  Color colortoshow = Colors.indigoAccent;
  Color right = Colors.green;
  Color wrong = Colors.red;

  // extra varibale to iterate
  int j = 1;
  int timer = 30;
  String showtimer = "30";
  bool canceltimer=false;
  var random_array;


  void checkanswer(String k)
  {
    // in the previous version this was
    // mydata[2]["1"] == mydata[1]["1"][k]
    // which i forgot to change
    // so nake sure that this is now corrected
    if(mydata[2][i.toString()]==mydata[1][i.toString()][k])
      {

        marks = marks + 5;
        // changing the color variable to be green
        colortoshow = right;
      } else {
      colortoshow = wrong;
    }
    setState(() {
      canceltimer=true;
      // applying the changed color to the particular button that was selected
      btncolor[k] = colortoshow;
      // changed timer duration to 1 second
      Timer(Duration(seconds: 1), nextquestion);
    });
  }

  void nextquestion() {
    canceltimer=false;
    timer=30;
    setState(() {
      if (j < 10) {
//        i = random_array[j];
//        j++;
      i++;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => resultpage(),
        ));
      }
      btncolor["a"] = Colors.indigoAccent;
      btncolor["b"] = Colors.indigoAccent;
      btncolor["c"] = Colors.indigoAccent;
      btncolor["d"] = Colors.indigoAccent;
    });
    starttimer();

  }

  // overriding the initstate function to start timer as this screen is created
  @override
  void initState() {
    starttimer();
//    genrandomarray();
    super.initState();
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextquestion();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });
  }

  Widget choicebutton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: ()=>checkanswer(k),
        child: Text(
           mydata[1][i.toString()][k] == null? '' :mydata[1][i.toString()][k],
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color:btncolor[k],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 200.0,
        height: 45.0,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(//for use that user cant govback backpage "WillPopScope"
      onWillPop: (){
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "Quizstar",
              ),
              content: Text("You Can't Go Back At This Stage."),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ok',
                  ),
                )
              ],
            ));
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                 mydata[0][i.toString()] == null? '' :mydata[0][i.toString()],
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Quando",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    choicebutton('a'),
                    choicebutton('b'),
                    choicebutton('c'),
                    choicebutton('d'),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                    showtimer,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

