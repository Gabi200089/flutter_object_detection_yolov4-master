import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/login_register/screens/profileScreen/profileScreenEdit.dart';
import 'package:sizer/sizer.dart';


class editPlansScreen extends StatefulWidget {
  //const editPlansScreen({ Key key }) : super(key: key);

  @override
  _editPlansScreenState createState() => _editPlansScreenState();
}

class _editPlansScreenState extends State<editPlansScreen> {
  String selectedWeightPlans = '減重';
  String selectedPlans = '最少減重:0.2公斤';
  double protein = 0,fat = 0,carb = 0,tdee = 0,bmr = 0,changed_tdee = 0;
  String habit = '';
  bool datagot1=false,datagot2=false,datagot3=false,datagot4=false,datagot5=false;
  createtdee(){
    //CollectionReference todocollection = FirebaseFirestore.instance.collection('TODOs');
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('usertdee');
    return documentReference.set({
      //'$_dateTime': input,
      'tdee' : tdee,
    });
  }

  createnutrients(){
    //CollectionReference todocollection = FirebaseFirestore.instance.collection('TODOs');
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc('abc@gmail.com').collection('infos').doc('nutrients');
    return documentReference.set({
      //'$_dateTime': input,
      'protein' : protein,
      'fat' : fat,
      'carb' : carb,
    });
  }
  createPlans(){
    //CollectionReference todocollection = FirebaseFirestore.instance.collection('TODOs');
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc('abc@gmail.com').collection('infos').doc('userPlans');
    return documentReference.set({
      //'$_dateTime': input,
      'selectedPlan' : selectedWeightPlans,
      'decided' : selectedPlans,
      'changed_tdee' : changed_tdee,
    });
  }
  createbmr(){
    //CollectionReference todocollection = FirebaseFirestore.instance.collection('TODOs');
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc('abc@gmail.com').collection('infos').doc('userbmr');
    return documentReference.set({
      //'$_dateTime': input,
      'bmr' : bmr,
    });
  }
  List<String> temp = <String>[
    '最少減重:0.2公斤',
    '正常減重:0.5公斤',
    '重度減重:0.8公斤',
    '瘋狂減重:1公斤',
  ];
  final List<String> WeightPlans = <String>[
    '減重',
    '減脂',
    '增肌',
    '增重',
    '維持',
  ];
  final List<String> gainMustleplans = <String>[
    '最少增肌: 5%',
    '正常增肌: 10%',
    '瘋狂增肌: 15%',
  ];
  final List<String> loseWeightplans = <String>[
    '最少減重:0.2公斤',
    '正常減重:0.5公斤',
    '重度減重:0.8公斤',
    '瘋狂減重:1公斤',
  ];
  final List<String> maintainWeightplans = <String>[
    '維持體重',
  ];
  final List<String> loseFatplans = <String>[
    '最少減脂: 10%',
    '正常減脂: 15%',
    '瘋狂減脂: 20%',
  ];
  final List<String> gainWeightplans = <String>[
    '最少增重:0.2公斤',
    '正常增重:0.5公斤',
    '重度增重:0.8公斤',
    '瘋狂增重:1公斤',
  ];
  Future<String>getnutrients() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('nutrients');
    await documentReference.get().then((DocumentSnapshot doc) async{
      protein = doc['protein'];
      fat = doc['fat'];
      carb = doc['carb'];
    });
    datagot1=true;
  }
  Future<String>getchangedtdee() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('userPlans');
    await documentReference.get().then((DocumentSnapshot doc) async{
      changed_tdee = doc['changed_tdee'];
    });
    datagot2=true;
  }
  Future<String>gethabits() async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('habits');
    await documentReference.get().then((DocumentSnapshot doc) async{
      habit = doc['habit'];
    });
    datagot3=true;
  }
  Future<String>getbmr() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('userbmr');
    await documentReference.get().then((DocumentSnapshot doc) async{
      bmr = doc['bmr'];
    });
    datagot4=true;
  }

  Future<String>gettdee() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('usertdee');
    await documentReference.get().then((DocumentSnapshot doc) async{
      tdee = doc['tdee'];
    });
    datagot5=true;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getnutrients();
    // gettdee();
    // getbmr();
    // gethabits();
    // getchangedtdee();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder<List<String>>(
      future: Future.wait([
        getnutrients(),
        gettdee(),
        getbmr(),
        gethabits(),
        getchangedtdee(),
      ]),// function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {  // AsyncSnapshot<Your object type>
        if( datagot1 == false||datagot2 == false||datagot3 == false||datagot4 == false||datagot5 == false){
          return  Scaffold(
            body:
            Center(
              child:
              Container(
                  height: height,
                  width: width,
                  color: Color(0xFF9575CD),
                  child:
                  Column(
                    children: [
                      SizedBox(height:height * 0.236,),
                      Image.asset(
                        "assets/loading5.gif",
                        width: width,
                        // width: 125.0,
                      ),
                      Text('Loading...',
                        style: TextStyle(
                          color:Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          letterSpacing: 4,
                        ) ,
                      ),
                    ],
                  )
              ),
            ),
          );
        }else{
          return Scaffold(
            body: Container(
              child: Column(
                children: [
                  Container(
                    width:width,
                    height: height*0.1,
                    color: Color.fromRGBO(218, 222, 242, 1),
                    child: Column(
                      children: [
                        SizedBox(height: height*0.025,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [
                            SizedBox(width: width*0.02,),
                            IconButton(
                              onPressed: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileScreenEdit(), maintainState: false));
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_outlined,
                                color: Colors.black,
                                size: 35,
                              ),

                            ),
                            SizedBox(width: width*0.03,),
                            Text('目標',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 30),)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: height*0.01,),
                        Container(
                          //padding: EdgeInsets.only(right: 20,left: 20),
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(7),
                          //   border: Border.all(color: Colors.grey ,width: 2),

                          // ),
                          width: width*0.2,
                          height: height*0.05,
                          child: Center(
                            child: DropdownButton<String>(
                              //hint: Text('選擇方案'),
                              value: selectedWeightPlans,
                              onChanged: (String value){
                                setState(() {
                                  selectedWeightPlans = value;
                                  if(selectedWeightPlans == '維持'){
                                    temp = maintainWeightplans;
                                    selectedPlans="維持體重";
                                    print('temp = '+temp.toString());
                                  }else if(selectedWeightPlans == '減重'){
                                    temp = loseWeightplans;
                                    selectedPlans="最少減重:0.2公斤";
                                    print('temp = '+temp.toString());
                                  }else if(selectedWeightPlans == '減脂'){
                                    temp = loseFatplans;
                                    selectedPlans="最少減脂: 10%";
                                  }else if(selectedWeightPlans == '增肌'){
                                    temp = gainMustleplans;
                                    selectedPlans="最少增肌: 5%";
                                  }else{    //增重
                                    temp = gainWeightplans;
                                    selectedPlans="最少增重:0.2公斤";
                                  }
                                });
                                build(this.context);
                              },
                              items: WeightPlans.map((value){
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 20),),
                                );
                              }).toList(),
                            ),
                          ),


                        ),
                        SizedBox(height: height*0.02,),
                        Container(
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(7),
                          //   border: Border.all(color: Colors.grey ,width: 2),

                          // ),
                          //width: 400,
                          child: Center(
                            child: DropdownButton<String>(
                              //hint: Text('select problem'),
                              value: selectedPlans,
                              onChanged: (String value){
                                setState(() {
                                  selectedPlans = value;
                                  if(habit == '沒有運動習慣'){
                                    tdee = bmr*1.2;
                                    protein = weight * 0.8;
                                    fat = tdee * 0.2 / 9;
                                    carb = (tdee - (protein * 4 + fat * 9)) / 4;
                                    if(selectedPlans == '最少減重:0.2公斤'){
                                      changed_tdee = tdee - 200;
                                    }else if(selectedPlans ==  '正常減重:0.5公斤'){
                                      changed_tdee = tdee - 500;
                                    }else if(selectedPlans ==  '重度減重:0.8公斤'){
                                      changed_tdee = tdee - 800;
                                    }else if(selectedPlans ==  '瘋狂減重:1公斤'){
                                      changed_tdee = tdee - 1000;
                                    }else if(selectedPlans ==  '最少增肌: 5%'){
                                      changed_tdee = tdee * 1.05;
                                    }else if(selectedPlans ==  '正常增肌: 10%'){
                                      changed_tdee = tdee * 1.1;
                                    }else if(selectedPlans ==  '瘋狂增肌: 15%'){
                                      changed_tdee = tdee * 1.15;
                                    }else if(selectedPlans ==  '最少增重:0.2公斤'){
                                      changed_tdee = tdee + 200;
                                    }else if(selectedPlans ==  '正常增重:0.5公斤'){
                                      changed_tdee = tdee + 500;
                                    }else if(selectedPlans ==  '重度增重:0.8公斤'){
                                      changed_tdee = tdee + 800;
                                    }else if(selectedPlans ==  '瘋狂增重:1公斤'){
                                      changed_tdee = tdee + 1000;
                                    }else if(selectedPlans ==  '最少減脂: 10%'){
                                      changed_tdee = tdee * 0.9;
                                    }else if(selectedPlans ==  '正常減脂: 15%'){
                                      changed_tdee = tdee * 0.85;
                                    }else if(selectedPlans ==  '瘋狂減脂: 20%'){
                                      changed_tdee = tdee * 0.8;
                                    }else{
                                      changed_tdee = tdee;
                                    }
                                    setState(() {
                                      Text(bmr.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(tdee.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(protein.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(fat.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(carb.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(changed_tdee.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                    });
                                  }else if(habit == '運動1-2天/週'){
                                    tdee = bmr*1.375;
                                    protein = weight * 1.2;
                                    fat = tdee * 0.2 / 9;
                                    carb = (tdee - (protein * 4 + fat * 9)) / 4;
                                    if(selectedPlans == '最少減重:0.2公斤'){
                                      changed_tdee = tdee - 200;
                                    }else if(selectedPlans ==  '正常減重:0.5公斤'){
                                      changed_tdee = tdee - 500;
                                    }else if(selectedPlans ==  '重度減重:0.8公斤'){
                                      changed_tdee = tdee - 800;
                                    }else if(selectedPlans ==  '瘋狂減重:1公斤'){
                                      changed_tdee = tdee - 1000;
                                    }else if(selectedPlans ==  '最少增肌: 5%'){
                                      changed_tdee = tdee * 1.05;
                                    }else if(selectedPlans ==  '正常增肌: 10%'){
                                      changed_tdee = tdee * 1.1;
                                    }else if(selectedPlans ==  '瘋狂增肌: 15%'){
                                      changed_tdee = tdee * 1.15;
                                    }else if(selectedPlans ==  '最少增重:0.2公斤'){
                                      changed_tdee = tdee + 200;
                                    }else if(selectedPlans ==  '正常增重:0.5公斤'){
                                      changed_tdee = tdee + 500;
                                    }else if(selectedPlans ==  '重度增重:0.8公斤'){
                                      changed_tdee = tdee + 800;
                                    }else if(selectedPlans ==  '瘋狂增重:1公斤'){
                                      changed_tdee = tdee + 1000;
                                    }else if(selectedPlans ==  '最少減脂: 10%'){
                                      changed_tdee = tdee * 0.9;
                                    }else if(selectedPlans ==  '正常減脂: 15%'){
                                      changed_tdee = tdee * 0.85;
                                    }else if(selectedPlans ==  '瘋狂減脂: 20%'){
                                      changed_tdee = tdee * 0.8;
                                    }else{
                                      changed_tdee = tdee;
                                    }
                                    setState(() {
                                      Text('BMR',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20),);
                                      Text('TDEE',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text('蛋白質',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text('脂肪',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text('碳水化合物',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                    });
                                  }else if(habit == '運動3-5天/週'){
                                    tdee = bmr*1.55;
                                    protein = weight * 1.2;
                                    fat = tdee * 0.2 / 9;
                                    carb = (tdee - (protein * 4 + fat * 9)) / 4;
                                    if(selectedPlans == '最少減重:0.2公斤'){
                                      changed_tdee = tdee - 200;
                                    }else if(selectedPlans ==  '正常減重:0.5公斤'){
                                      changed_tdee = tdee - 500;
                                    }else if(selectedPlans ==  '重度減重:0.8公斤'){
                                      changed_tdee = tdee - 800;
                                    }else if(selectedPlans ==  '瘋狂減重:1公斤'){
                                      changed_tdee = tdee - 1000;
                                    }else if(selectedPlans ==  '最少增肌: 5%'){
                                      changed_tdee = tdee * 1.05;
                                    }else if(selectedPlans ==  '正常增肌: 10%'){
                                      changed_tdee = tdee * 1.1;
                                    }else if(selectedPlans ==  '瘋狂增肌: 15%'){
                                      changed_tdee = tdee * 1.15;
                                    }else if(selectedPlans ==  '最少增重:0.2公斤'){
                                      changed_tdee = tdee + 200;
                                    }else if(selectedPlans ==  '正常增重:0.5公斤'){
                                      changed_tdee = tdee + 500;
                                    }else if(selectedPlans ==  '重度增重:0.8公斤'){
                                      changed_tdee = tdee + 800;
                                    }else if(selectedPlans ==  '瘋狂增重:1公斤'){
                                      changed_tdee = tdee + 1000;
                                    }else if(selectedPlans ==  '最少減脂: 10%'){
                                      changed_tdee = tdee * 0.9;
                                    }else if(selectedPlans ==  '正常減脂: 15%'){
                                      changed_tdee = tdee * 0.85;
                                    }else if(selectedPlans ==  '瘋狂減脂: 20%'){
                                      changed_tdee = tdee * 0.8;
                                    }else{
                                      changed_tdee = tdee;
                                    }
                                    setState(() {
                                      Text(bmr.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(tdee.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(protein.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(fat.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(carb.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(changed_tdee.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                    });
                                  }else if(habit == '運動6-7天/週'){
                                    tdee = bmr*1.725;
                                    protein = weight * 2.0;
                                    fat = tdee * 0.2 / 9;
                                    carb = (tdee - (protein * 4 + fat * 9)) / 4;
                                    if(selectedPlans == '最少減重:0.2公斤'){
                                      changed_tdee = tdee - 200;
                                    }else if(selectedPlans ==  '正常減重:0.5公斤'){
                                      changed_tdee = tdee - 500;
                                    }else if(selectedPlans ==  '重度減重:0.8公斤'){
                                      changed_tdee = tdee - 800;
                                    }else if(selectedPlans ==  '瘋狂減重:1公斤'){
                                      changed_tdee = tdee - 1000;
                                    }else if(selectedPlans ==  '最少增肌: 5%'){
                                      changed_tdee = tdee * 1.05;
                                    }else if(selectedPlans ==  '正常增肌: 10%'){
                                      changed_tdee = tdee * 1.1;
                                    }else if(selectedPlans ==  '瘋狂增肌: 15%'){
                                      changed_tdee = tdee * 1.15;
                                    }else if(selectedPlans ==  '最少增重:0.2公斤'){
                                      changed_tdee = tdee + 200;
                                    }else if(selectedPlans ==  '正常增重:0.5公斤'){
                                      changed_tdee = tdee + 500;
                                    }else if(selectedPlans ==  '重度增重:0.8公斤'){
                                      changed_tdee = tdee + 800;
                                    }else if(selectedPlans ==  '瘋狂增重:1公斤'){
                                      changed_tdee = tdee + 1000;
                                    }else if(selectedPlans ==  '最少減脂: 10%'){
                                      changed_tdee = tdee * 0.9;
                                    }else if(selectedPlans ==  '正常減脂: 15%'){
                                      changed_tdee = tdee * 0.85;
                                    }else if(selectedPlans ==  '瘋狂減脂: 20%'){
                                      changed_tdee = tdee * 0.8;
                                    }else{
                                      changed_tdee = tdee;
                                    }
                                    setState(() {
                                      Text(bmr.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(tdee.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(protein.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(fat.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(carb.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(changed_tdee.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                    });
                                  }else if(habit == '每天運動2次'){
                                    tdee = bmr*1.9;
                                    protein = weight * 2.0;
                                    fat = tdee * 0.2 / 9;
                                    carb = (tdee - (protein * 4 + fat * 9)) / 4;
                                    if(selectedPlans == '最少減重:0.2公斤'){
                                      changed_tdee = tdee - 200;
                                    }else if(selectedPlans ==  '正常減重:0.5公斤'){
                                      changed_tdee = tdee - 500;
                                    }else if(selectedPlans ==  '重度減重:0.8公斤'){
                                      changed_tdee = tdee - 800;
                                    }else if(selectedPlans ==  '瘋狂減重:1公斤'){
                                      changed_tdee = tdee - 1000;
                                    }else if(selectedPlans ==  '最少增肌: 5%'){
                                      changed_tdee = tdee * 1.05;
                                    }else if(selectedPlans ==  '正常增肌: 10%'){
                                      changed_tdee = tdee * 1.1;
                                    }else if(selectedPlans ==  '瘋狂增肌: 15%'){
                                      changed_tdee = tdee * 1.15;
                                    }else if(selectedPlans ==  '最少增重:0.2公斤'){
                                      changed_tdee = tdee + 200;
                                    }else if(selectedPlans ==  '正常增重:0.5公斤'){
                                      changed_tdee = tdee + 500;
                                    }else if(selectedPlans ==  '重度增重:0.8公斤'){
                                      changed_tdee = tdee + 800;
                                    }else if(selectedPlans ==  '瘋狂增重:1公斤'){
                                      changed_tdee = tdee + 1000;
                                    }else if(selectedPlans ==  '最少減脂: 10%'){
                                      changed_tdee = tdee * 0.9;
                                    }else if(selectedPlans ==  '正常減脂: 15%'){
                                      changed_tdee = tdee * 0.85;
                                    }else if(selectedPlans ==  '瘋狂減脂: 20%'){
                                      changed_tdee = tdee * 0.8;
                                    }else{
                                      changed_tdee = tdee;
                                    }
                                    setState(() {
                                      Text(bmr.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(tdee.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(protein.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(fat.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(carb.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                      Text(changed_tdee.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20));
                                    });
                                  }
                                });

                              },
                              items: temp.map((value){
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 20),),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: height*0.03,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Color(0XFFD6D6D6) ,width: 2),
                          ),
                          width: width*0.85,
                          height: height *0.34,
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: height*0.02,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: width*0.13,),
                                  Text('BMR',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20),),
                                  SizedBox(width: width*0.29,),
                                  Text(bmr.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                                  SizedBox(width: width*0.04),
                                  Text('kcal',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20))
                                ],
                              ),
                              SizedBox(height: height*0.015,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: width*0.09,),
                                  Text('原本TDEE',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                                  SizedBox(width: width*0.22,),
                                  Text(tdee.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                                  SizedBox(width: width*0.04),
                                  Text('kcal',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20))
                                ],
                              ),
                              SizedBox(height: height*0.015,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: width*0.06,),
                                  Text('建議攝取TDEE',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                                  SizedBox(width: width*0.19,),
                                  Text(changed_tdee.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                                  SizedBox(width: width*0.085),
                                  Text('kcal',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20))
                                ],
                              ),
                              SizedBox(height: height*0.015,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: width*0.13,),
                                  Text('蛋白質',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                                  SizedBox(width: width*0.28,),
                                  Text(protein.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                                  SizedBox(width: width*0.095),
                                  Text('g',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20))
                                ],
                              ),
                              SizedBox(height: height*0.015,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: width*0.15,),
                                  Text('脂肪',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                                  SizedBox(width: width*0.31,),
                                  Text(fat.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                                  SizedBox(width: width*0.095),
                                  Text('g',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20))
                                ],
                              ),
                              SizedBox(height: height*0.015,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: width*0.09,),
                                  Text('碳水化合物',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                                  SizedBox(width: width*0.21,),
                                  Text(carb.toStringAsFixed(1).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                                  SizedBox(width: width*0.073),
                                  Text('g',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20))
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: width*0.05,),
                        Container(
                          height: height*0.2,
                          width: width*0.5,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/img.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: height*0.04,),
                        Container(
                          width: width*0.7,
                          height: height*0.08,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12), // <-- Radius
                                ),
                                elevation: 4,
                                primary: Color.fromRGBO(218, 222, 242, 1),
                                textStyle: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              child: Text('完 成 !',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 26)),
                              onPressed: (){
                                createPlans();
                                createtdee();
                                createnutrients();
                                createbmr();
                              }

                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );

  }
}