import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[100],
        body: SafeArea(
          // 아랫부분은 safeArea가 적용되지 않는다.
          bottom: false,
          child: Container(
              // column을 화면 가운데로 옮기는 방법
              // Column을 Container로 감싸고 width를 MediaQuery.of(context).size.width로 만들어주면
              // 된다.
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  _TopPart(
                    selectedDate: selectedDate,
                    onPressed: onHeartPressed,
                  ),
                  _BottomPart()
                ],
              )),
        ));
  }

  onHeartPressed() {
    DateTime now = DateTime.now();
    //dialog
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          // 해당 쿠퍼티노 다이얼로그를 정렬하지 않고 사이즈를 준다고 해도,
          // 플러터에서는 전체 범위의 창을 덮어버리기 때문에, Align같은 요소를 반드시 줘야한다.
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              height: 300.0,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectedDate,
                //최대의 날짜임. 이 날짜를 넘어가면 안됨. 근데 해당 설정을 적용하고 빌드하면 에러
                // 왜냐면 데이트 피커는 디폴트가 지금 시간인데, 지금시간의 00:00까지를 맥시멈으로 넣는다면
                // 날짜가 넘어가버리기 때문.. 그래서 initialDateTime을 넣으면 된다.
                //   (initialDateTime == maximumDate)
                maximumDate: DateTime(now.year, now.month, now.day),
                onDateTimeChanged: (DateTime date) {
                  // stateful widget에서 변수를 변경해서 빌드를 다시 실행할 때에는 setState를 불러줘야한다.
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
            ),
          );
        });
  }
}

class _TopPart extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPressed;

  _TopPart({
    required this.selectedDate,
    required this.onPressed,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final now = DateTime.now();
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'U&I',
            style: textTheme.headline1,
            ),

          Column(
            children: [
              Text(
                '우리 처음 만난날',
                style: textTheme.bodyText1,
              ),
              Text(
                '${selectedDate.year}.${selectedDate.month}.${selectedDate.day}',
                style: textTheme.bodyText2,
              ),
            ],
          ),
          IconButton(
            iconSize: 60.0,
            onPressed: onPressed,
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
          Text(
            'D+${DateTime(
                  now.year,
                  now.month,
                  now.day,
                ).difference(selectedDate).inDays + 1 //오늘부터 1일~
            }',
            style: textTheme.headline2,
          )
        ],
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Image.asset('asset/img/middle_image.png'));
  }
}
