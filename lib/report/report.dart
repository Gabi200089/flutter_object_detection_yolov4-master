import 'package:object_detection/body_shape/download.dart';
import 'package:object_detection/food_diary/food_record.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:object_detection/login_register/screens/login/components/background.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math';

// import 'chart.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Report());
}

class Report extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neumorphic Design',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white.withOpacity(0.9),
      ),
      home: Reportpage(),
    );
  }
}

final data = [55.0, 90.0, 50.0, 40.0, 35.0, 55.0, 70.0, 100.0];

List<Color> gradientColors = [
  const Color(0xff23b6e6),
  const Color(0xff02d39a),
];

class Reportpage extends StatefulWidget {
  @override
  _ReportpageState createState() => _ReportpageState();
}

class _ReportpageState extends State<Reportpage> {

  int _currentIndex = 0;
  int currentTab = 3;
  var today = DateTime.now();
  var monday = DateTime.now();
  var tuesday;
  var wednesday;
  var thursday;
  var friday;
  var saturday;
  var sunday;
  Map monData = {'calorie': 0, 'carbohydrate': 0, 'fat': 0, 'protein': 0};
  Map tueData = {'calorie': 0, 'carbohydrate': 0, 'fat': 0, 'protein': 0};
  Map wedData = {'calorie': 0, 'carbohydrate': 0, 'fat': 0, 'protein': 0};
  Map thuData = {'calorie': 0, 'carbohydrate': 0, 'fat': 0, 'protein': 0};
  Map friData = {'calorie': 0, 'carbohydrate': 0, 'fat': 0, 'protein': 0};
  Map satData = {'calorie': 0, 'carbohydrate': 0, 'fat': 0, 'protein': 0};
  Map sunData = {'calorie': 0, 'carbohydrate': 0, 'fat': 0, 'protein': 0};

  Map monBody = {'weight': 0, 'height': 0, 'BMI': 0};
  Map tueBody = {'weight': 0, 'height': 0, 'BMI': 0};
  Map wedBody = {'weight': 0, 'height': 0, 'BMI': 0};
  Map thuBody = {'weight': 0, 'height': 0, 'BMI': 0};
  Map friBody = {'weight': 0, 'height': 0, 'BMI': 0};
  Map satBody = {'weight': 0, 'height': 0, 'BMI': 0};
  Map sunBody = {'weight': 0, 'height': 0, 'BMI': 0};

  String BMImessage = '', objectMessage, nutrientsMessage;
  double BMI;
  double aveCarb, aveFat, aveProtein;
  String userPlan = '';
  double changed_tdee;
  double userCarb, userFat, userProtein;

  final ref =
  FirebaseFirestore.instance.collection('report_diary').doc(user_email);
  final bodyref =
  FirebaseFirestore.instance.collection('report_body').doc(user_email);
  final userref =
  FirebaseFirestore.instance.collection('flutter-user').doc(user_email);
  var exist = false;
  bool _loading = true;
  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  setDate() async {
    today = DateTime.now();
    monday = DateTime.now();

    while (monday.weekday != 1) //找星期一
        {
      monday = monday.subtract(new Duration(days: 1));
    }

    setWeek();
  }

  setWeek() {
    tuesday = monday.add(new Duration(days: 1));
    wednesday = monday.add(new Duration(days: 2));
    thursday = monday.add(new Duration(days: 3));
    friday = monday.add(new Duration(days: 4));
    saturday = monday.add(new Duration(days: 5));
    sunday = monday.add(new Duration(days: 6));

    print('當前時間:' + DateFormat('yyyy-MM-dd').format(today));
    print('星期一:' + DateFormat('yyyy-MM-dd').format(monday));
    print('星期二:' + DateFormat('yyyy-MM-dd').format(tuesday));
    print('星期三:' + DateFormat('yyyy-MM-dd').format(wednesday));
    print('星期四:' + DateFormat('yyyy-MM-dd').format(thursday));
    print('星期五:' + DateFormat('yyyy-MM-dd').format(friday));
    print('星期六:' + DateFormat('yyyy-MM-dd').format(saturday));
    print('星期日:' + DateFormat('yyyy-MM-dd').format(sunday));

    setDateData();
  }

  setDateData() async {
    setState(() {
      _loading = true;
    });

    await ref
        .collection(DateFormat('yyyy-MM-dd').format(monday))
        .doc('food_diary')
        .get()
        .then((DocumentSnapshot doc) {
      exist = doc.exists;
      print(exist);
      if (exist == true) {
        monData['calorie'] = doc['calorie'];
        monData['carbohydrate'] = doc['carbohydrate'];
        monData['fat'] = doc['fat'];
        monData['protein'] = doc['protein'];
      } else if (exist == false) {
        monData['calorie'] = 0;
        monData['carbohydrate'] = 0;
        monData['fat'] = 0;
        monData['protein'] = 0;
      }
    });

    await ref
        .collection(DateFormat('yyyy-MM-dd').format(tuesday))
        .doc('food_diary')
        .get()
        .then((DocumentSnapshot doc) {
      exist = doc.exists;
      print(exist);
      if (doc.exists == true) {
        tueData['calorie'] = doc['calorie'];
        tueData['carbohydrate'] = doc['carbohydrate'];
        tueData['fat'] = doc['fat'];
        tueData['protein'] = doc['protein'];
      } else if (exist == false) {
        tueData['calorie'] = 0;
        tueData['carbohydrate'] = 0;
        tueData['fat'] = 0;
        tueData['protein'] = 0;
      }
    });

    await ref
        .collection(DateFormat('yyyy-MM-dd').format(wednesday))
        .doc('food_diary')
        .get()
        .then((DocumentSnapshot doc) {
      exist = doc.exists;
      print(exist);
      if (doc.exists == true) {
        wedData['calorie'] = doc['calorie'];
        wedData['carbohydrate'] = doc['carbohydrate'];
        wedData['fat'] = doc['fat'];
        wedData['protein'] = doc['protein'];
      } else if (exist == false) {
        wedData['calorie'] = 0;
        wedData['carbohydrate'] = 0;
        wedData['fat'] = 0;
        wedData['protein'] = 0;
      }
    });

    await ref
        .collection(DateFormat('yyyy-MM-dd').format(thursday))
        .doc('food_diary')
        .get()
        .then((DocumentSnapshot doc) {
      exist = doc.exists;
      print(exist);
      if (doc.exists == true) {
        thuData['calorie'] = doc['calorie'];
        thuData['carbohydrate'] = doc['carbohydrate'];
        thuData['fat'] = doc['fat'];
        thuData['protein'] = doc['protein'];
      } else if (exist == false) {
        thuData['calorie'] = 0;
        thuData['carbohydrate'] = 0;
        thuData['fat'] = 0;
        thuData['protein'] = 0;
      }
    });

    await ref
        .collection(DateFormat('yyyy-MM-dd').format(friday))
        .doc('food_diary')
        .get()
        .then((DocumentSnapshot doc) {
      exist = doc.exists;
      print(exist);
      if (doc.exists == true) {
        friData['calorie'] = doc['calorie'];
        friData['carbohydrate'] = doc['carbohydrate'];
        friData['fat'] = doc['fat'];
        friData['protein'] = doc['protein'];
      } else if (exist == false) {
        friData['calorie'] = 0;
        friData['carbohydrate'] = 0;
        friData['fat'] = 0;
        friData['protein'] = 0;
      }
    });

    await ref
        .collection(DateFormat('yyyy-MM-dd').format(saturday))
        .doc('food_diary')
        .get()
        .then((DocumentSnapshot doc) {
      exist = doc.exists;
      print(exist);
      if (doc.exists == true) {
        satData['calorie'] = doc['calorie'];
        satData['carbohydrate'] = doc['carbohydrate'];
        satData['fat'] = doc['fat'];
        satData['protein'] = doc['protein'];
      } else if (exist == false) {
        satData['calorie'] = 0;
        satData['carbohydrate'] = 0;
        satData['fat'] = 0;
        satData['protein'] = 0;
      }
    });

    await ref
        .collection(DateFormat('yyyy-MM-dd').format(sunday))
        .doc('food_diary')
        .get()
        .then((DocumentSnapshot doc) {
      exist = doc.exists;
      print(exist);
      if (doc.exists == true) {
        sunData['calorie'] = doc['calorie'];
        sunData['carbohydrate'] = doc['carbohydrate'];
        sunData['fat'] = doc['fat'];
        sunData['protein'] = doc['protein'];
      } else if (exist == false) {
        sunData['calorie'] = 0;
        sunData['carbohydrate'] = 0;
        sunData['fat'] = 0;
        sunData['protein'] = 0;
      }
    });
////////// 身體數據 //////////////

    await userref
        .collection('infos')
        .doc('userInfo')
        .get()
        .then((DocumentSnapshot doc) {
      monBody['height'] = doc['height'];
      tueBody['height'] = doc['height'];
      wedBody['height'] = doc['height'];
      thuBody['height'] = doc['height'];
      friBody['height'] = doc['height'];
      satBody['height'] = doc['height'];
      sunBody['height'] = doc['height'];
    });

    await bodyref
        .collection(DateFormat('yyyy-MM-dd').format(monday))
        .doc('body_shape')
        .get()
        .then((DocumentSnapshot doc) {
      exist = doc.exists;
      if (doc.exists == true) {
        monBody['weight'] = double.parse(doc['kg']);
        monBody['BMI'] = double.parse((monBody['weight'] /
            ((monBody['height'] / 100) * (monBody['height'] / 100)))
            .toStringAsFixed(1));
      } else {
        monBody['weight'] = 0;
        monBody['BMI'] = 0;
      }
    });

    await bodyref
        .collection(DateFormat('yyyy-MM-dd').format(tuesday))
        .doc('body_shape')
        .get()
        .then((DocumentSnapshot doc) {
      exist = doc.exists;
      if (doc.exists == true) {
        tueBody['weight'] = double.parse(doc['kg']);
        tueBody['BMI'] = double.parse((tueBody['weight'] /
            ((tueBody['height'] / 100) * (tueBody['height'] / 100)))
            .toStringAsFixed(1));
      } else {
        tueBody['weight'] = 0;
        tueBody['BMI'] = 0;
      }
    });

    await bodyref
        .collection(DateFormat('yyyy-MM-dd').format(wednesday))
        .doc('body_shape')
        .get()
        .then((DocumentSnapshot doc) {
      exist = doc.exists;
      if (doc.exists == true) {
        wedBody['weight'] = double.parse(doc['kg']);
        wedBody['BMI'] = double.parse((wedBody['weight'] /
            ((wedBody['height'] / 100) * (wedBody['height'] / 100)))
            .toStringAsFixed(1));
      } else {
        wedBody['weight'] = 0;
        wedBody['BMI'] = 0;
      }
    });

    await bodyref
        .collection(DateFormat('yyyy-MM-dd').format(thursday))
        .doc('body_shape')
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists == true) {
        thuBody['weight'] = double.parse(doc['kg']);
        thuBody['BMI'] = double.parse((thuBody['weight'] /
            ((thuBody['height'] / 100) * (thuBody['height'] / 100)))
            .toStringAsFixed(1));
      } else {
        thuBody['weight'] = 0;
        thuBody['BMI'] = 0;
      }
    });

    await bodyref
        .collection(DateFormat('yyyy-MM-dd').format(friday))
        .doc('body_shape')
        .get()
        .then((DocumentSnapshot doc) {
      exist = doc.exists;
      if (doc.exists == true) {
        friBody['weight'] = double.parse(doc['kg']);
        friBody['BMI'] = double.parse((friBody['weight'] /
            ((friBody['height'] / 100) * (friBody['height'] / 100)))
            .toStringAsFixed(1));
      } else {
        friBody['weight'] = 0;
        friBody['BMI'] = 0;
      }
    });

    await bodyref
        .collection(DateFormat('yyyy-MM-dd').format(saturday))
        .doc('body_shape')
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists == true) {
        satBody['weight'] = double.parse(doc['kg']);
        satBody['BMI'] = double.parse((satBody['weight'] /
            ((satBody['height'] / 100) * (satBody['height'] / 100)))
            .toStringAsFixed(1));
      } else {
        satBody['weight'] = 0;
        satBody['BMI'] = 0;
      }
    });

    await bodyref
        .collection(DateFormat('yyyy-MM-dd').format(sunday))
        .doc('body_shape')
        .get()
        .then((DocumentSnapshot doc) {
      exist = doc.exists;
      if (doc.exists == true) {
        sunBody['weight'] = double.parse(doc['kg']);
        sunBody['BMI'] = double.parse((sunBody['weight'] /
            ((sunBody['height'] / 100) * (sunBody['height'] / 100)))
            .toStringAsFixed(1));
      } else {
        sunBody['weight'] = 0;
        sunBody['BMI'] = 0;
      }
    });

///////// 建議 //////////

    await userref
        .collection('infos')
        .doc('userPlans')
        .get()
        .then((DocumentSnapshot doc) {
      userPlan = doc['selectedPlan'];
      changed_tdee = doc['changed_tdee'];
      print(userPlan);
    });

    await userref
        .collection('infos')
        .doc('nutrients')
        .get()
        .then((DocumentSnapshot doc) {
      userCarb = doc['carb'];
      userFat = doc['fat'];
      userProtein = doc['protein'];
    });

    int n = 7;
    if (monBody['BMI'] == 0) n -= 1;
    if (tueBody['BMI'] == 0) n -= 1;
    if (wedBody['BMI'] == 0) n -= 1;
    if (thuBody['BMI'] == 0) n -= 1;
    if (friBody['BMI'] == 0) n -= 1;
    if (satBody['BMI'] == 0) n -= 1;
    if (sunBody['BMI'] == 0) n -= 1;

    if (n == 0)
      BMI = 0;
    else
      BMI = double.parse(((monBody['BMI'] +
          tueBody['BMI'] +
          wedBody['BMI'] +
          thuBody['BMI'] +
          friBody['BMI'] +
          satBody['BMI'] +
          sunBody['BMI']) /
          n)
          .toStringAsFixed(1));

    if (BMI == 0)
      BMImessage = '沒有紀錄';
    else if (BMI < 18.5)
      BMImessage = '體重過輕'; //'「體重過輕」，需要多運動，均衡飲食，以增加體能，維持健康！';
    else if (18.5 <= BMI && BMI < 24)
      BMImessage = '健康體重'; //'恭喜！「健康體重」，要繼續保持！';
    else if (24 <= BMI && BMI < 27)
      BMImessage = '體重過重'; //'「體重過重」了，要小心囉，趕快力行「健康體重管理」！';
    else if (BMI <= 27) BMImessage = '肥胖'; //'啊～「肥胖」，需要立刻力行「健康體重管理」囉！';

    if (userPlan == 'gain mustle')
      gain();
    else if (userPlan == 'gain weight')
      gain();
    else if (userPlan == 'lose fat')
      lose();
    else if (userPlan == 'lose weight')
      lose();
    else if (userPlan == 'maintain') maintain();

    int d = 7;
    if (monData['carbohydrate'] + monData['protein'] + monData['fat'] == 0)
      d -= 1;
    if (tueData['carbohydrate'] + tueData['protein'] + tueData['fat'] == 0)
      d -= 1;
    if (wedData['carbohydrate'] + wedData['protein'] + wedData['fat'] == 0)
      d -= 1;
    if (thuData['carbohydrate'] + thuData['protein'] + thuData['fat'] == 0)
      d -= 1;
    if (friData['carbohydrate'] + friData['protein'] + friData['fat'] == 0)
      d -= 1;
    if (satData['carbohydrate'] + satData['protein'] + satData['fat'] == 0)
      d -= 1;
    if (sunData['carbohydrate'] + sunData['protein'] + sunData['fat'] == 0)
      d -= 1;

    print('d=$d');

    String over = '';
    bool _isOver = false;
    if (d == 0)
      nutrientsMessage = '沒有紀錄';
    else {
      aveProtein = double.parse(((monData['protein'] +
          tueData['protein'] +
          wedData['protein'] +
          thuData['protein'] +
          friData['protein'] +
          satData['protein'] +
          sunData['protein']) /
          d)
          .toStringAsFixed(1));
      aveCarb = double.parse(((monData['carbohydrate'] +
          tueData['carbohydrate'] +
          wedData['carbohydrate'] +
          thuData['carbohydrate'] +
          friData['carbohydrate'] +
          satData['carbohydrate'] +
          sunData['carbohydrate']) /
          d)
          .toStringAsFixed(1));
      aveFat = double.parse(((monData['fat'] +
          tueData['fat'] +
          wedData['fat'] +
          thuData['fat'] +
          friData['fat'] +
          satData['fat'] +
          sunData['fat']) /
          d)
          .toStringAsFixed(1));

      if (aveProtein > userProtein) {
        _isOver = true;
        over += '、蛋白質';
      }
      if (aveCarb > userCarb) {
        _isOver = true;
        over += '、碳水化合物';
      }
      if (aveFat > userFat) {
        _isOver = true;
        over += '、脂肪';
      }

      if (_isOver)
        nutrientsMessage =
            '你這週' + over.substring(1) + '的攝取量超過建議值了!接下來的飲食上要再更加注意才行喔~';
      else
        nutrientsMessage = '這週的營養攝取都在正常範圍內，你是均衡飲食的乖寶寶喔!';
    }

//測試
    print(monData);
    print(tueData);
    print(wedData);
    print(thuData);
    print(friData);
    print(satData);
    print(sunData);

    print(monBody);
    print(tueBody);
    print(wedBody);
    print(thuBody);
    print(friBody);
    print(satBody);
    print(sunBody);

    setState(() {
      _loading = false;
    });
  }

  void gain() {
    bool _isless = false;
    String theday = '';
    if (monData['calorie'] != 0 && monData['calorie'] < changed_tdee) {
      _isless = true;
      theday += '、一';
    }
    if (tueData['calorie'] != 0 && tueData['calorie'] < changed_tdee) {
      _isless = true;
      theday += '、二';
    }
    if (wedData['calorie'] != 0 && wedData['calorie'] < changed_tdee) {
      _isless = true;
      theday += '、三';
    }
    if (thuData['calorie'] != 0 && thuData['calorie'] < changed_tdee) {
      _isless = true;
      theday += '、四';
    }
    if (friData['calorie'] != 0 && friData['calorie'] < changed_tdee) {
      _isless = true;
      theday += '、五';
    }
    if (satData['calorie'] != 0 && satData['calorie'] < changed_tdee) {
      _isless = true;
      theday += '、六';
    }
    if (sunData['calorie'] != 0 && sunData['calorie'] < changed_tdee) {
      _isless = true;
      theday += '、日';
    }
    if (monData['calorie'] +
        tueData['calorie'] +
        wedData['calorie'] +
        thuData['calorie'] +
        friData['calorie'] +
        satData['calorie'] +
        sunData['calorie'] ==
        0)
      objectMessage = '沒有紀錄';
    else if (_isless == false)
      objectMessage = '恭喜你達到目標，要繼續保持喔~';
    else
      objectMessage = '星期' + theday.substring(1) + "吃太少囉，要多吃點才能達到你的目標!";
    print(objectMessage);
  }

  void lose() {
    String theday = '';
    bool _ismore = false;
    if (monData['calorie'] != 0 && monData['calorie'] > changed_tdee) {
      _ismore = true;
      theday += '、一';
    }
    if (tueData['calorie'] != 0 && tueData['calorie'] > changed_tdee) {
      _ismore = true;
      theday += '、二';
    }
    if (wedData['calorie'] != 0 && wedData['calorie'] > changed_tdee) {
      _ismore = true;
      theday += '、三';
    }
    if (thuData['calorie'] != 0 && thuData['calorie'] > changed_tdee) {
      _ismore = true;
      theday += '、四';
    }
    if (friData['calorie'] != 0 && friData['calorie'] > changed_tdee) {
      _ismore = true;
      theday += '、五';
    }
    if (satData['calorie'] != 0 && satData['calorie'] > changed_tdee) {
      _ismore = true;
      theday += '、六';
    }
    if (sunData['calorie'] != 0 && sunData['calorie'] > changed_tdee) {
      _ismore = true;
      theday += '、日';
    }
    if (monData['calorie'] +
        tueData['calorie'] +
        wedData['calorie'] +
        thuData['calorie'] +
        friData['calorie'] +
        satData['calorie'] +
        sunData['calorie'] ==
        0)
      objectMessage = '沒有紀錄';
    else if (_ismore == false)
      objectMessage = '恭喜你達到目標，要繼續保持喔~';
    else
      objectMessage = '星期' + theday.substring(1) + "吃太多囉，要少吃點才能達到你的目標!";
    print(objectMessage);
  }

  void maintain() {
    String theday = '', thelessday;
    bool _ismore = false, _isless = false;
    if (monData['calorie'] != 0 && monData['calorie'] > changed_tdee * 1.1) {
      _ismore = true;
      theday += '、一';
    } else if (monData['calorie'] != 0 &&
        monData['calorie'] < changed_tdee * 0.9) {
      _isless = true;
      thelessday += '、一';
    }
    if (tueData['calorie'] != 0 && tueData['calorie'] > changed_tdee * 1.1) {
      _ismore = true;
      theday += '、二';
    } else if (tueData['calorie'] != 0 &&
        tueData['calorie'] < changed_tdee * 0.9) {
      _isless = true;
      thelessday += '、二';
    }
    if (wedData['calorie'] != 0 && wedData['calorie'] > changed_tdee * 1.1) {
      _ismore = true;
      theday += '、三';
    } else if (wedData['calorie'] != 0 &&
        wedData['calorie'] < changed_tdee * 0.9) {
      _isless = true;
      thelessday += '、三';
    }
    if (thuData['calorie'] != 0 && thuData['calorie'] > changed_tdee * 1.1) {
      _ismore = true;
      theday += '、四';
    } else if (thuData['calorie'] != 0 &&
        thuData['calorie'] < changed_tdee * 0.9) {
      _isless = true;
      thelessday += '、四';
    }
    if (friData['calorie'] != 0 && friData['calorie'] > changed_tdee * 1.1) {
      _ismore = true;
      theday += '、五';
    } else if (friData['calorie'] != 0 &&
        friData['calorie'] < changed_tdee * 0.9) {
      _isless = true;
      thelessday += '、五';
    }
    if (satData['calorie'] != 0 && satData['calorie'] > changed_tdee * 1.1) {
      _ismore = true;
      theday += '、六';
    } else if (satData['calorie'] != 0 &&
        satData['calorie'] < changed_tdee * 0.9) {
      _isless = true;
      thelessday += '、六';
    }
    if (sunData['calorie'] != 0 && sunData['calorie'] > changed_tdee * 1.1) {
      _ismore = true;
      theday += '、日';
    } else if (sunData['calorie'] != 0 &&
        sunData['calorie'] < changed_tdee * 0.9) {
      _isless = true;
      thelessday += '、日';
    }
    if (monData['calorie'] +
        tueData['calorie'] +
        wedData['calorie'] +
        thuData['calorie'] +
        friData['calorie'] +
        satData['calorie'] +
        sunData['calorie'] ==
        0)
      objectMessage = '沒有紀錄';
    else if (_ismore == false && _isless == false)
      objectMessage = '恭喜你達到目標，要繼續保持喔~';
    else if (_ismore == true && _isless == false)
      objectMessage = '星期' + theday.substring(1) + "吃太多囉，要少吃點才能維持現在體態!";
    else if (_ismore == false && _isless == true)
      objectMessage =
          '星期' + thelessday.substring(1) + "吃太少囉，至少要吃超過自己的基礎代謝率才能維持現在體態!";
    else
      objectMessage = '你這週的飲食有點不規律喔!星期' +
          thelessday.substring(1) +
          '吃太少，星期' +
          theday.substring(1) +
          '又吃太多!調整一下再繼續加油吧~';
    print(objectMessage);
  }

  void initState() {
    super.initState();
    setDate();
  }

  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final List<int> showIndexes = const [1, 3, 5];
    final List<FlSpot> allSpots = [
      FlSpot(0, 1),
      FlSpot(1, 2),
      FlSpot(2, 1.5),
      FlSpot(3, 3),
      FlSpot(4, 3.5),
      FlSpot(5, 5),
      FlSpot(6, 8),
    ];
    final lineBarsData = [
      LineChartBarData(
          showingIndicators: showIndexes,
          spots: allSpots,
          isCurved: true,
          barWidth: 4,
          shadow: const Shadow(
            blurRadius: 8,
            color: Colors.black,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [
              const Color(0xff12c2e9).withOpacity(0.4),
              const Color(0xffc471ed).withOpacity(0.4),
              const Color(0xfff64f59).withOpacity(0.4),
            ],
          ),
          dotData: FlDotData(show: false),
          colors: [
            const Color(0xff12c2e9),
            const Color(0xffc471ed),
            const Color(0xfff64f59),
          ],
          colorStops: [
            0.1,
            0.4,
            0.9
          ]),
    ];

    final tooltipsOnBar = lineBarsData[0];

//setWeek();

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body:_loading==true
          ? Center(
        child:
        Container(
            height: height,
            width: width,
            color: Color(0xFFFFD8AA),
            child:
            Column(
              children: [
                SizedBox(height:60,),
                Image.asset(
                  "assets/loading7.gif",
                  width: width,
                  // width: 125.0,
                ),
                Text('Loading...',
                  style: TextStyle(
                    color:Color(0xff5a0d41),
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                    letterSpacing: 4,
                  ) ,
                ),
              ],
            )
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: width*0.03,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "數據分析",
                  style: TextStyle(
                    color: Color(0xff203864),
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    letterSpacing: 4,
                  ),
                ),
                SizedBox(width: width*0.05,),
                Container(
                  width: width*0.4,
                  child: Image.asset(
                    "assets/Report analysis _Two Color.png",
                    // width: width*0.85,
                  ),
                ),
              ],
            ),
            SizedBox(height: width*0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Image.asset("assets/left-arrow.png"),
                    onPressed: () {
                      monday = monday.subtract(new Duration(days: 7));
                      print('星期一:' +
                          DateFormat('yyyy-MM-dd').format(monday));
                      setState(() {
                        setWeek();
                      });
                    }),
                SizedBox(width: width*0.03,),
                Text(DateFormat('yyyy-MM-dd').format(monday) +
                    '\n~' +
                    DateFormat('yyyy-MM-dd').format(sunday),
                  style: TextStyle(
                    color: Color(0xff647BBA),
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: 6,
                  ),),
                SizedBox(width: width*0.02,),
                IconButton(
                    icon: Image.asset("assets/right-arrow.png"),
                    onPressed: () {
                      monday = monday.add(new Duration(days: 7));
                      print('星期一:' +
                          DateFormat('yyyy-MM-dd').format(monday));
                      setState(() {
                        setWeek();
                      });
                    }),
              ],
            ),
            SizedBox(height: width*0.04,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width*0.04),
              padding: EdgeInsets.only(left: width*0.02,right: width*0.02,bottom: width*0.02,top:width*0.03),
              decoration:  BoxDecoration(
                  color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: width*0.03,),
                      Icon(Icons.circle,color: Color(0xff647BBA),),
                      SizedBox(width: width*0.04,),
                      Text(
                        "熱量攝取",
                        style: TextStyle(
                          color: Color(0xff647BBA),
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                  AspectRatio(
                    aspectRatio: 1.70,
                    child: Padding(
                      padding:  EdgeInsets.only(
                          right: 18.0, left: 12.0, top: width*0.015, bottom: 12),
                      child: LineChart(calorieData(),
                          swapAnimationDuration: Duration(milliseconds: 150),
                          swapAnimationCurve: Curves.linear),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: width*0.04,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width*0.04),
              padding: EdgeInsets.only(left: width*0.02,right: width*0.02,bottom: width*0.02,top:width*0.03),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Colors.white),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: width*0.03,),
                      Icon(Icons.circle,color: Color(0xff647BBA),),
                      SizedBox(width: width*0.04,),
                      Text(
                        "營養攝取",
                        style: TextStyle(
                          color: Color(0xff647BBA),
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(top: width*0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 22,
                          height: 4,
                          margin: EdgeInsets.only(right: 5),
                          color: Color(0xff53fdd7),
                        ),
                        Text(
                          "蛋白質",
                          style: TextStyle(
                            color: Color(0xff68737d),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 4,
                          margin: EdgeInsets.only(left: 10, right: 5),
                          color: Color(0xffffc551),
                        ),
                        Text(
                          "碳水化合物",
                          style: TextStyle(
                            color: Color(0xff68737d),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 4,
                          margin: EdgeInsets.only(left: 10, right: 5),
                          color: Color(0xffff5151),
                        ),
                        Text(
                          "脂肪",
                          style: TextStyle(
                            color: Color(0xff68737d),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1.7,
                    child: Padding(
                      padding:  EdgeInsets.only(
                          right: width*0.02, left: width*0.02, top: width*0.03, bottom: width*0.02),
                      child: BarChart(nutritionData()),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: width*0.04,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width*0.04),
              padding: EdgeInsets.only(left: width*0.02,right: width*0.02,bottom: width*0.02,top:width*0.03),
              decoration:  BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Colors.white),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: width*0.03,),
                      Icon(Icons.circle,color: Color(0xff647BBA),),
                      SizedBox(width: width*0.04,),
                      Text(
                        "體重變化",
                        style: TextStyle(
                          color: Color(0xff647BBA),
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(top: width*0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 22,
                          height: 4,
                          margin: EdgeInsets.only(right: 5),
                          color: Color(0x99aa4cfc),
                        ),
                        Text(
                          "體重",
                          style: TextStyle(
                            color: Color(0xff68737d),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 4,
                          margin: EdgeInsets.only(left: 10, right: 5),
                          color: Color(0x4427b6fc),
                        ),
                        Text(
                          "BMI",
                          style: TextStyle(
                            color: Color(0xff68737d),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1.3,
                    child: Padding(
                      padding:  EdgeInsets.only(
                          right: width*0.04, left: width*0.02, top: width*0.03, bottom: width*0.02),
                      child: LineChart(bodyData(),
                          swapAnimationDuration:
                          Duration(milliseconds: 150),
                          swapAnimationCurve: Curves.linear),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: width*0.04,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width*0.04),
              padding: EdgeInsets.only(top: width*0.02,bottom: width*0.04),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Color(0xffE2E4EB)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top:width*0.03 ),
                    padding: EdgeInsets.symmetric(vertical: width*0.008,horizontal: width*0.06),
                    decoration: BoxDecoration(
                      color: Color(0xff647BBA),
                      borderRadius: const BorderRadius.all(Radius.circular(40),),
                    ),
                    child: Text(
                      BMImessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: width*0.1),
                        width: width*0.1,
                        child: Image.asset(
                          "assets/quotation-marks.png",
                          // width: width*0.85,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "目標達成度",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      letterSpacing: 8,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: width*0.1),
                        width: width*0.1,
                        child: Image.asset(
                          "assets/quotation-marks (1).png",
                          // width: width*0.85,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: width*0.03),
                    padding: EdgeInsets.symmetric(horizontal: width*0.12),
                    child: Text(
                      objectMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: 2
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: width*0.04,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width*0.04),
              padding: EdgeInsets.only(top: width*0.02,bottom: width*0.04),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Color(0xffE2E4EB)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: width*0.1),
                        width: width*0.1,
                        child: Image.asset(
                          "assets/quotation-marks.png",
                          // width: width*0.85,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "營養攝取",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      letterSpacing: 8,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: width*0.1),
                        width: width*0.1,
                        child: Image.asset(
                          "assets/quotation-marks (1).png",
                          // width: width*0.85,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: width*0.03),
                    padding: EdgeInsets.symmetric(horizontal: width*0.12),
                    child: Text(
                      nutrientsMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 2
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: width*0.04,),
          ],
        ),
      ),
      bottomNavigationBar: _loading==false?CustomNavigationBar(
        iconSize: 45,
        selectedColor: Color(0xff040307),
        strokeColor: Color(0x30040307),
        unSelectedColor: Color(0xffacacac),
        backgroundColor: Colors.white,
        scaleFactor: 	0.5,
        items: [
          CustomNavigationBarItem(
            icon: Container(
                margin: EdgeInsets.only(bottom: width*0.012),
                alignment: Alignment.bottomCenter,
                width: width * 0.07,
                child: Image.asset('assets/食材管理.png',)),
          ),
          CustomNavigationBarItem(
            icon: Container(
                margin: EdgeInsets.only(bottom: width*0.012),
                alignment: Alignment.bottomCenter,
                width: width * 0.07,
                child: Image.asset('assets/飲食紀錄.png')),
          ),
          CustomNavigationBarItem(
            icon: Container(
                margin: EdgeInsets.only(bottom: width*0.012),
                alignment: Alignment.bottomCenter,
                width: width * 0.07,
                child: Image.asset('assets/身形管理.png')),
          ),
          CustomNavigationBarItem(
            icon: Container(
                child: Image.asset('assets/數據分析(改).png')),
          ),
          CustomNavigationBarItem(
            icon: Container(
                margin: EdgeInsets.only(bottom: width*0.012),
                alignment: Alignment.bottomCenter,
                width: width * 0.063,
                child: Image.asset('assets/設定.png')),
          ),
        ],
        currentIndex: currentTab,
        onTap: (index) {
          switch(index){
            case 0:
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ingredient_management()),);
              break;
            case 1:
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => food_record(),maintainState: false));
              break;
            case 2:
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => download(),maintainState: false));
              break;
            case 3:
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Report(),maintainState: false));
              break;
            case 4:
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(),maintainState: false));
              break;
          }

          // setState(() {
          //   _currentIndex = index;
          //   print(_currentIndex);
          // });
        },
      ):null,
    );
  }

  // BottomAppBar(
  // shape: CircularNotchedRectangle(),
  // notchMargin: 10,
  // child: Container(
  // height:60,
  // child: Row(
  // mainAxisAlignment: MainAxisAlignment.center,
  // children: <Widget>[
  // Row(
  // crossAxisAlignment: CrossAxisAlignment.start,
  // children: [
  // MaterialButton(      //button1
  // minWidth: 75,
  // onPressed: (){
  // Navigator.pop(context);
  // Navigator.push(context, MaterialPageRoute(builder: (context) => ingredient_management()),);
  // currentTab = 0;
  // },
  // child:  Column(
  // mainAxisAlignment: MainAxisAlignment.center,
  // children: [
  // Icon(
  // Icons.manage_search,   //dining_rounded
  // color: currentTab == 0 ? Colors.blue : Colors.grey,
  // ),
  // ],
  // ),
  // ),
  // MaterialButton(      //button2
  // minWidth: 75,
  // onPressed: (){
  // Navigator.pop(context);
  // Navigator.push(context, MaterialPageRoute(builder: (context) => food_record(),maintainState: false));//change
  // currentTab = 1;
  // },
  // child:  Column(
  // mainAxisAlignment: MainAxisAlignment.center,
  // children: [
  // Icon(
  // Icons.fastfood_rounded,  //emoji_food_beverage_rounded   //add_reaction_rounded,
  // color: currentTab == 1 ? Colors.blue : Colors.grey,
  // ),
  // ],
  // ),
  // ),
  // MaterialButton(      //button3
  // minWidth: 75,
  // onPressed: (){
  // Navigator.pop(context);
  // Navigator.push(context, MaterialPageRoute(builder: (context) => download(),maintainState: false));//ch//change
  // currentTab = 2;
  // },
  // child:  Column(
  // mainAxisAlignment: MainAxisAlignment.center,
  // children: [
  // Icon(
  // Icons.local_fire_department_outlined,   //dining_rounded
  // color: currentTab == 2 ? Colors.blue : Colors.grey,
  // ),
  // ],
  // ),
  // ),
  // MaterialButton(      //button4
  // minWidth: 75,
  // onPressed: (){
  // Navigator.pop(context);
  // Navigator.push(context, MaterialPageRoute(builder: (context) => Report(),maintainState: false)); //change
  // currentTab = 3;
  // },
  // child:  Column(
  // mainAxisAlignment: MainAxisAlignment.center,
  // children: [
  // Icon(
  // Icons.bar_chart_rounded,   //dining_rounded
  // color: currentTab == 3 ? Colors.blue : Colors.grey,
  // ),
  // ],
  // ),
  // ),
  // MaterialButton(      //button5
  // minWidth: 75,
  // onPressed: (){
  // Navigator.pop(context);
  // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(),maintainState: false));//
  // currentTab = 4;
  // },
  // child:  Column(
  // mainAxisAlignment: MainAxisAlignment.center,
  // children: [
  // Icon(
  // Icons.person,   //dining_rounded
  // color: currentTab == 4 ? Colors.blue : Colors.grey,
  // ),
  // ],
  // ),
  // ),
  // ],
  // ),
  // ],
  // ),
  // ),
  // )

  LineChartData calorieData() {
    //熱量報表
    return LineChartData(
        gridData: FlGridData(
          show: true,
//drawVerticalLine: true,
// drawHorizontalLine: true,
// getDrawingHorizontalLine: (value) {   //背景橫線
//   return FlLine(
//     color: const Color(0xff37434d),
//     strokeWidth: 1,
//   );
// },
// getDrawingVerticalLine: (value) {  //背景直線
//   return FlLine(
//     color: const Color(0xff37434d),
//     strokeWidth: 1,
//   );
// },
        ),
        titlesData: FlTitlesData(
          //橫標頭
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 18,
            getTextStyles: (context,value) => const TextStyle(
                color: Color(0xff68737d),
                fontWeight: FontWeight.bold,
                fontSize: 16),
            getTitles: (value) {
              switch (value.toInt()) {
                case 0:
                  return 'Mon';
                case 1:
                  return 'Tue';
                case 2:
                  return 'Wed';
                case 3:
                  return 'Thu';
                case 4:
                  return 'Fri';
                case 5:
                  return 'Sat';
                case 6:
                  return 'Sun';
              }
              return '';
            },
            margin: 8,
          ),
          leftTitles: SideTitles(
            //直標頭
            showTitles: true,
            getTextStyles: (context,value) => const TextStyle(
              color: Color(0xff67727d),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 1000:
                  return '1k';
                case 2000:
                  return '2k';
                case 3000:
                  return '3k';
                case 4000:
                  return '4k';
                // case 5000:
                //   return '50k';
              }
              return '';
            },
            reservedSize: 18,
            margin: 12,
          ),
        ),
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1)),
        //邊框
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 5000,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, monData['calorie'] / 1),
              FlSpot(1, tueData['calorie'] / 1),
              FlSpot(2, wedData['calorie'] / 1),
              FlSpot(3, thuData['calorie'] / 1),
              FlSpot(4, friData['calorie'] / 1),
              FlSpot(5, satData['calorie'] / 1),
              FlSpot(6, sunData['calorie'] / 1),
            ],
            // isCurved: true,
            //波變圓潤
            colors: gradientColors,
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              //座標點
              show: false,
            ),
            belowBarData: BarAreaData(
              //線下方區塊
              show: true,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white.withOpacity(0.8),
              getTooltipItems: defaultLineTooltipItem,
            )));
  }

  BarChartData nutritionData() {
    return BarChartData(
        maxY: 1000,
        minY: 100,
// gridData: FlGridData(
//   show: true,
// ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context,value) => const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14),
//reservedSize: 18,
//margin: 8,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return 'Mon';
                case 1:
                  return 'Tue';
                case 2:
                  return 'Wed';
                case 3:
                  return 'Thu';
                case 4:
                  return 'Fri';
                case 5:
                  return 'Sat';
                case 6:
                  return 'Sun';
                default:
                  return '';
              }
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context,value) => const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14),
            margin: 15,
            reservedSize: 25,
            getTitles: (value) {
              if (value == 200) {
                return '200';
              } else if (value == 600) {
                return '600';
              } else if (value == 1000) {
                return '1000';
              } else {
                return '';
              }
            },
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barTouchData:BarTouchData(
          touchTooltipData:
          BarTouchTooltipData(
            tooltipBgColor: Colors.white.withOpacity(0.8),
          )
        ),
        barGroups: [
          makeGroupData(0, monData['protein'] / 1, monData['carbohydrate'] / 1,
              monData['fat'] / 1),
          makeGroupData(1, tueData['protein'] / 1, tueData['carbohydrate'] / 1,
              tueData['fat'] / 1),
          makeGroupData(2, wedData['protein'] / 1, wedData['carbohydrate'] / 1,
              wedData['fat'] / 1),
          makeGroupData(3, thuData['protein'] / 1, thuData['carbohydrate'] / 1,
              thuData['fat'] / 1),
          makeGroupData(4, friData['protein'] / 1, friData['carbohydrate'] / 1,
              friData['fat'] / 1),
          makeGroupData(5, satData['protein'] / 1, satData['carbohydrate'] / 1,
              satData['fat'] / 1),
          makeGroupData(6, sunData['protein'] / 1, sunData['carbohydrate'] / 1,
              sunData['fat'] / 1),
        ]
//showingBarGroups,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    final Color leftBarColor = const Color(0xff53fdd7);
    final Color midleBarColor = const Color(0xffffc551);
    final Color rightBarColor = const Color(0xffff5182);
    final double width = 7;

    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [midleBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y3,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }

  LineChartData bodyData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white.withOpacity(0.8),
            getTooltipItems: defaultLineTooltipItem,
          )
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context,value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'Mon';
              case 1:
                return 'Tue';
              case 2:
                return 'Wed';
              case 3:
                return 'Thu';
              case 4:
                return 'Fri';
              case 5:
                return 'Sat';
              case 6:
                return 'Sun';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context,value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            if (value == 20) {
              return '20';
            } else if (value == 30) {
              return '30';
            } else if (value == 40) {
              return '40';
            } else if (value == 50) {
              return '50';
            } else if (value == 60) {
              return '60';
            } else if (value == 70) {
              return '70';
            } else if (value == 80) {
              return '80';
            } else if (value == 90) {
              return '90';
            } else {
              return '';
            }
          },
          margin: 12,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      maxY: 100,
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(0, monBody['weight'] / 1),
          FlSpot(1, tueBody['weight'] / 1),
          FlSpot(2, wedBody['weight'] / 1),
          FlSpot(3, thuBody['weight'] / 1),
          FlSpot(4, friBody['weight'] / 1),
          FlSpot(5, satBody['weight'] / 1),
          FlSpot(6, sunBody['weight'] / 1),
        ],
        isCurved: true,
        curveSmoothness: 0.1,
        colors: const [
          Color(0x99aa4cfc),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          const Color(0x33aa4cfc),
        ]),
      ),
      LineChartBarData(
        spots: [
          FlSpot(0, monBody['BMI'] / 1),
          FlSpot(1, tueBody['BMI'] / 1),
          FlSpot(2, wedBody['BMI'] / 1),
          FlSpot(3, thuBody['BMI'] / 1),
          FlSpot(4, friBody['BMI'] / 1),
          FlSpot(5, satBody['BMI'] / 1),
          FlSpot(6, sunBody['BMI'] / 1),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0x4427b6fc),
        ],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
// showingIndicators: [0,1,2,3,4,5,6],
// isStepLineChart:true,
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }
}
