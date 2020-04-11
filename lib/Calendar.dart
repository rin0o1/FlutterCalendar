import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';


class Calendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalendarState();
  }
}

class CalendarState extends State<Calendar> {

  DateTime _dateTime;
  int MonthDaysOffset = 0;
  int numWeekDays = 7;


  @protected
  void initState() {

    _dateTime = DateTime.now();
    setDaysOffset();

  }

  @override
  Widget build(BuildContext context) {

    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                child: new Text(
                    getMonthNameItalian(_dateTime.month) + " " + _dateTime.year.toString(),
                    style: Theme.of(context).textTheme.display1),
              )
            ]),
            GetCalendar(context),
          ],
        ),
        Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 6),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(13.0))),
                      backgroundColor: Colors.green,
                      child: new Icon(Icons.chevron_left),
                      onPressed: scrolMonthLeft,
                    ),
                    FloatingActionButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(13.0))),
                      backgroundColor: Colors.deepOrange,
                      child: new Icon(Icons.calendar_today),
                      tooltip: "Today",
                      onPressed: setToday,
                    ),
                    FloatingActionButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(13.0))),
                      backgroundColor: Colors.green,
                      child: new Icon(Icons.chevron_right),
                      onPressed: scrollMonthRight,
                    ),
                  ],
                )),
          ],
        )
      ],
    );
  }

  FutureBuilder GetCalendar(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemWidth= 58;
    final double itemHeight=65;

    return new FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return new Padding(
              padding: EdgeInsets.fromLTRB(2, 10, 2, 0),
              child: Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Text('L',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline)),
                      new Expanded(
                          child: new Text('M',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline)),
                      new Expanded(
                          child: new Text('M',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline)),
                      new Expanded(
                          child: new Text('G',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline)),
                      new Expanded(
                          child: new Text('V',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline)),
                      new Expanded(
                          child: new Text('S',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline)),
                      new Expanded(
                          child: new Text('D',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline)),
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                  new GridView.count(
                      key: UniqueKey(),
                      crossAxisCount: numWeekDays,
                      childAspectRatio: (itemWidth / itemHeight),
                      shrinkWrap: true,
                      children: new  List.generate(getNumberOfDaysInMonth(_dateTime.month),
                            (index) {

                          int Day= (index<MonthDaysOffset) ? -1: (index -MonthDaysOffset)+1;

                          //Empty day to set offset
                          if (Day<=-1) { return  new CellNumber(Day, index, false, null);}

                          DateTime SingleCellNumberDateTime =  new DateTime(_dateTime.year, _dateTime.month, Day);

                          bool IsTheDay =  Day == DateTime.now().day &&
                                _dateTime.month == DateTime.now().month &&
                                _dateTime.year == DateTime.now().year;
                          return new CellNumber(Day, index, IsTheDay, SingleCellNumberDateTime);

                        },
                      ))
                ],
              ));
        });
  }


  void setDaysOffset() {
    MonthDaysOffset = new DateTime(_dateTime.year, _dateTime.month, 0).weekday;

  }

  void setToday() {
    setState(() {
      _dateTime = DateTime.now();
      setDaysOffset();
    });
  }

  void scrolMonthLeft() {
    setState(() {
      _dateTime= (_dateTime.month == DateTime.january) ?
      _dateTime = new DateTime(_dateTime.year - 1, DateTime.december):
      _dateTime = new DateTime(_dateTime.year, _dateTime.month - 1);

      setDaysOffset();
    });


  }

  void scrollMonthRight() {
    setState(() {
      _dateTime= (_dateTime.month == DateTime.december) ?
      _dateTime = new DateTime(_dateTime.year + 1, DateTime.january) :
      _dateTime = new DateTime(_dateTime.year, _dateTime.month + 1);

      setDaysOffset();
    });
  }


  int getNumberOfDaysInMonth(final int month) {

    DateTime date= new DateTime(DateTime.now().year, month);
    DateTime lastDayInDate= Utils.lastDayOfMonth(date);
    int  lastDayInInt= int.parse(lastDayInDate.day.toString());

    return lastDayInInt+  MonthDaysOffset;

  }

  String getMonthNameItalian(final int month) {

    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "Dicembre";
      default:
        return "December";
    }
  }

  Widget buildDayEventInfoWidget(int dayNumber) {
    int eventCount = 0;
    DateTime eventDate;
    if (eventCount > 0) {
      return new Expanded(
        child: FittedBox(
          alignment: Alignment.topLeft,
          fit: BoxFit.contain,
          child: new Text(
            "Events:$eventCount",
            maxLines: 1,
            style: new TextStyle(
                fontWeight: FontWeight.normal,
                background: Paint()..color = Colors.amberAccent),
          ),
        ),
      );
    } else {
      return new Container();
    }
  }
}



class CellNumber extends StatefulWidget{


  CellNumberState _CellNUmberState;

  CellNumber(int dayNumber, int gridViewIndex , bool IsTheDay,  DateTime myDateTime ){
    _CellNUmberState= new CellNumberState(dayNumber, gridViewIndex,IsTheDay, myDateTime);
  }

  @override
  State<StatefulWidget> createState(){ return _CellNUmberState;}
}

class CellNumberState extends State<CellNumber>
{
  int DayNumber;
  int GridViewIndex;
  bool IsTheDay;
  Color CellColor;

  DateTime MyDateTime;

  CellNumberState(int dayNumber,int gridViewIndex ,bool isTheDay, DateTime myDateTime)
  {
    DayNumber=dayNumber;
    GridViewIndex=gridViewIndex;
    IsTheDay=isTheDay;
    CellColor= Colors.orange;
    MyDateTime=myDateTime;
  }

  @override
  Container build(BuildContext context) {

    return new Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(1.0),
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color:CellColor),
      child: GestureDetector(
        onTap: (MyDateTime==null) ? ()=>{} : onClik,
        child: new Column(
          children: <Widget>[
            buildDayNumberWidget(),
            //buildDayEventInfoWidget(dayNumber)
          ],
        ),
      ),
    );
  }

  void onClik()
  {
    print('Clicked');

  }

  Align buildDayNumberWidget( ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 37.0,
        height: 53.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (this.IsTheDay) ? Colors.yellowAccent : null),
        padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
        child: new Text(
          (DayNumber==-1) ? ' ' : DayNumber.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline,
        ),
      ),
    );
  }


}


