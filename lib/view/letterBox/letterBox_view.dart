import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makefuture/view/letterBox/letterActivity_view.dart';
import 'package:table_calendar/table_calendar.dart';

class LetterBoxView extends StatefulWidget {
  const LetterBoxView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LetterBoxViewState createState() => _LetterBoxViewState();
}

class _LetterBoxViewState extends State<LetterBoxView> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String myuid = FirebaseAuth.instance.currentUser!.uid;
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  List<String> specialDayStrings =[];
  List<DateTime> specialDays = [];
  // Map<String, Map<String, dynamic>> specialDayData = {};
  List<Map<String, dynamic>> specialDayData = [];
  String? letterBox_documentId;
  List<String> events = [];

  @override
  void initState() {
    super.initState();
    specialDays = specialDayStrings.map((day) => DateFormat("yyy-MM-dd").parse(day)).toList();
    _getDatabaseDate();
  }
  Future<void> _getDatabaseDate() async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("couple").get();
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['couple1'] == myuid || data['couple2'] == myuid) {
        letterBox_documentId = doc.id;
      }
    }
    try{
      CollectionReference dataCollection = db.collection('couple').doc(letterBox_documentId).collection('LetterBoxDate');
      QuerySnapshot querySnapshot = await dataCollection.get();
      final docId = querySnapshot.docs.map((doc) => doc.id).toList();
      setState(() {
        specialDayStrings = docId;
      });
    } catch (e) {
      print("ERROR : $e");
    }
  }
  Future<void> _getLetterBoxDateData(String date) async {
    // final docSnapshot = await db.collection('couple').doc(letterBox_documentId).collection('LetterBoxDate').doc(date).collection(myUid).doc(myUid).get();
    final docSnapshot = await db.collection('couple/$letterBox_documentId/LetterBoxDate').doc(date).collection(myUid).doc(myUid).get();
    if(docSnapshot.exists) {
      final data = docSnapshot.data();
      print(data);
      if(data != null) {
        setState(() {
         specialDayData = [data];
         events = data.values.map((value) => value.toString()).toList();
        });
        final imgUrl = data['imgUrl'] ?? '';
        final letterText = data['letterText'] ?? '';
        final timeStamp = data['Time'] ?? '';
        final title = data['letterTitle'] ?? '';
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LetterActivityView(
                    imgUrl: imgUrl,
                    letterText: letterText,
                    timeStamp: timeStamp,
                    title: title
                )
            )
        );
      } else {
        setState(() {
          events = [];
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('ERROR! :: Connot find LetterBox, errorCode : 5144745.null'),
      ));
      setState(() {
        events = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('받은 편지'),
          actions: const [
            IconButton(onPressed: null, icon: Icon(Icons.notifications))
          ],
        ),
        body: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2024, 6, 29),
              lastDay: DateTime.utc(2999, 12, 31),
              focusedDay: _focusedDay,
              daysOfWeekHeight: 30,
              calendarFormat: _calendarFormat,
              // locale: 'ko-KR',
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronVisible: false,
                rightChevronVisible: false
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: const TextStyle(color: Colors.grey),
                weekendTextStyle: const TextStyle(color: Colors.red),
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 1.5)
                ),
                todayTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
                )
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                // 선택된 날짜가 specialDayStrings에 있는지 확인하고, 있다면 해당 값 출력
                String selectedDateString = DateFormat("yyyy-MM-dd").format(selectedDay);

                if (specialDayStrings.contains(selectedDateString)) {
                  _getLetterBoxDateData(selectedDateString).then((_) {
                    // final data = specialDayData[selectedDateString];
                  });
                  print('Selected date: $selectedDateString');
                  // 필요한 다른 작업 수행
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                // defaultBuilder: (context, day, focusedDay) {
                //   String dayString = DateFormat("yyyy-MM-dd").format(day);
                //   if (specialDayStrings.contains(dayString)) {
                //     return Container(
                //       decoration: BoxDecoration(
                //         color: Colors.green.withOpacity(0.3),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: Center(
                //         child: Text(
                //           '${day.day}',
                //           style: const TextStyle(color: Colors.green),
                //         ),
                //       ),
                //     );
                //   }
                //   return null;
                // },
                dowBuilder: (context, day) {
                    switch(day.weekday) {
                      case 1:
                        return const Center(child: Text("월"));
                      case 2:
                        return const Center(child: Text("화"));
                      case 3:
                        return const Center(child: Text("수"));
                      case 4:
                        return const Center(child: Text("목"));
                      case 5:
                        return const Center(child: Text("금"));
                      case 6:
                        return const Center(child: Text("토", style: TextStyle(color: Colors.blue)));
                      case 7:
                        return const Center(child: Text("일", style: TextStyle(color: Colors.red)));
                    }
                    return null;
                  },
                markerBuilder: (context, date, events) {
                  String dayString = DateFormat("yyyy-MM-dd").format(date);
                  if(specialDayStrings.contains(dayString)) {
                    print("STRING : ${specialDayStrings.isNotEmpty}");
                    return const Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(
                          Icons.event,
                          color: Colors.blue,
                          size: 16.0,
                        )
                    );
                  }
                  return const SizedBox.shrink();
                }
              ),
            ),
            // TableCalendar(
            //   focusedDay: _focusedDay,
            //   firstDay: DateTime.utc(2024, 6, 29),
            //   lastDay: DateTime.utc(2999, 12, 31),
            //   // locale: 'ko-KR',
            //   daysOfWeekHeight: 30,
            //   // calendarFormat: _calendarFormat,
            //   headerStyle: const  HeaderStyle(
            //       formatButtonVisible: false,
            //       titleCentered: true,
            //       leftChevronVisible: false,
            //       rightChevronVisible: false
            //   ),
            //   calendarStyle: CalendarStyle(
            //       defaultTextStyle: const TextStyle(color: Colors.grey),
            //       weekendTextStyle: const TextStyle(color: Colors.blue),
            //       outsideDaysVisible: false,
            //       todayDecoration: BoxDecoration(
            //           color: Colors.transparent,
            //           shape: BoxShape.circle,
            //           border: Border.all(color: Colors.green, width: 1.5)
            //       ),
            //       todayTextStyle: const TextStyle(
            //           fontWeight: FontWeight.bold,
            //           color: Colors.grey
            //       )
            //   ),
            //   // eventLoader: _getEventsForDay,
            //   selectedDayPredicate: (day) {
            //     return isSameDay(_selectedDay, day);
            //   },
            //   onDaySelected: (selectedDay, focusedDay) {
            //     setState(() {
            //       _selectedDay = selectedDay;
            //       _focusedDay = focusedDay; // update `_focusedDay` here as well
            //     });
            //     if(_specialDays.any((day) => isSameDay(day, selectedDay))) {
            //       int index = _specialDays.indexWhere((day) => isSameDay(day,selectedDay));
            //       String selecteDateString = documents[index];
            //       print('Selected date: $selecteDateString');
            //     }
            //     final formattedDate = DateFormat('yyy-MM-dd').format(selectedDay);
            //   },
            //   onFormatChanged: (format) {
            //     setState(() {
            //       _calendarFormat = format;
            //     });
            //     // if (_calendarFormat != format) {
            //     //   setState(() {
            //     //     _calendarFormat = format;
            //     //   });
            //     // }
            //   },
            //   onPageChanged: (focusedDay) {
            //     _focusedDay = focusedDay;
            //   },
            //   calendarBuilders: CalendarBuilders(
            //       defaultBuilder: (context, day, focusedDay) {
            //         if(_specialDays.any((specialDay) => isSameDay(day, specialDay))) {
            //           return Center(
            //             child: Text(
            //               '${day.day}',
            //               style: const TextStyle(color: Colors.red),
            //             ),
            //           );
            //         }
            //         return null;
            //       },
            //       dowBuilder: (context, day) {
            //         switch(day.weekday) {
            //           case 1:
            //             return const Center(child: Text("월"));
            //           case 2:
            //             return const Center(child: Text("화"));
            //           case 3:
            //             return const Center(child: Text("수"));
            //           case 4:
            //             return const Center(child: Text("목"));
            //           case 5:
            //             return const Center(child: Text("금"));
            //           case 6:
            //             return const Center(child: Text("토", style: TextStyle(color: Colors.blue)));
            //           case 7:
            //             return const Center(child: Text("일", style: TextStyle(color: Colors.red)));
            //         }
            //         return null;
            //       }
            //   ),
            // ),
            SizedBox(height: 8,),
            if(events.isNotEmpty)
              Expanded(
                  child: ListView.builder(
                    itemCount: events.length,
                      itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(events[index]),
                      );
                    }
                  )
              )
            else
              const Expanded(
                  child: Center(
                    child: Text('No events for this day.'),
                  )
              )
          ],
        )
    );
  }
}