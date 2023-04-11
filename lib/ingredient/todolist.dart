import 'package:flutter/services.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/global.dart';



class todolist extends StatefulWidget {
  @override
  _todolistState createState() => _todolistState();
}

class _todolistState extends State<todolist> {
  List todos = [];
  String input = '';
  bool datagot=false;

  @override
  Future<String>gettodos() async {
    if(datagot==false)
    {
      String value = '';
      final user = auth.currentUser;
      String mail = user.email;
      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('TODOs')
          .doc(mail)
          .collection('todolist');
      await collectionReference.get().then((QuerySnapshot snapshot) async {
        snapshot.docs.forEach((DocumentSnapshot doc) {
          value = doc['title'];
          todos.add(value);
          print(doc.data());
        });
      });
    }
    else
      return "";
    datagot=true;
  }

  createtodos() {
    //CollectionReference todocollection = FirebaseFirestore.instance.collection('TODOs');
    DateTime _dateTime;
    _dateTime = DateTime.now();
    final user = auth.currentUser;
    String mail = user.email;
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('TODOs')
        .doc(mail)
        .collection('todolist')
        .doc(input);
    return documentReference.set({
      //'$_dateTime': input,
      'title': input,
    });
  }

  deletetodos(item) {
    DateTime _dateTime;
    _dateTime = DateTime.now();
    final user = auth.currentUser;
    String mail = user.email;
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('TODOs')
        .doc(mail)
        .collection('todolist')
        .doc(item);
    return documentReference.delete();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    datagot=false;
    // gettodos();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder<String>(
      future: gettodos(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        if( datagot == false){
          return  Scaffold(
            body:
            Center(
              child:
              Container(
                  height: height,
                  width: width,
                  color: Color(0xFF0382AF),
                  child:
                  Column(
                    children: [
                      SizedBox(height:150,),
                      Image.asset(
                        "assets/loading8.gif",
                        width: width,
                        // width: 125.0,
                      ),
                      SizedBox(height:30,),
                      Text('Loading...',
                        style: TextStyle(
                          color:Color(0xffffffff),
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
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
              backgroundColor: Color(0xffFAEDCB),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          padding: const EdgeInsets.all(4),
                          icon: Icon(Icons.arrow_back_ios_outlined),
                          color: Colors.black,
                          iconSize: 40,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ingredient_management(), maintainState: false));
                          },
                        ),
                        SizedBox(width: 10,),
                        Center(
                          child: Text(
                            '購物清單',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: height*0.58,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(left: width*0.06,right:width*0.06,top: width*0.06),
                          padding: EdgeInsets.only(left: 2,right: 2,top:width*0.06,bottom: width*0.03),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('TODOs')
                                  .doc(mail)
                                  .collection('todolist')
                                  .snapshots(),
                              builder: (context, snapshots) {
                                return Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: todos.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Dismissible(
                                        key: Key(todos[index].toString()),
                                        background: Container(
                                          padding: EdgeInsets.only(right: 20),
                                          alignment: Alignment.centerRight,
                                          child: Icon(Icons.delete,color: Colors.white,),
                                          color: Colors.red,
                                        ),
                                        direction: DismissDirection.endToStart,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: width*0.06),
                                          decoration: BoxDecoration(
                                            border: Border(bottom: BorderSide( color: Colors.black),
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Text(todos[index],style: TextStyle(fontSize: 19,letterSpacing: 1),),
                                          ),
                                        ),
                                        // ignore: missing_return
                                        confirmDismiss: (DismissDirection direction) async{
                                          return await showDialog(
                                              context: context,
                                              builder: (BuildContext context){
                                                return AlertDialog(
                                                  title: const  Text("刪除警告"),
                                                  content: Text('你確定要刪除'+todos[index]+'嗎?'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child: const Text("否" ),
                                                    ),
                                                    FlatButton(
                                                        onPressed: () => Navigator.of(context).pop(true),
                                                        child: const Text("刪除",style: TextStyle(color: Colors.redAccent))
                                                    ),
                                                  ],
                                                );
                                              }
                                          );
                                        },
                                        onDismissed: (DismissDirection direction) async {
                                          if(direction == DismissDirection.endToStart){
                                            deletetodos(todos[index]);
                                            setState(() async {
                                              await todos.removeAt(index);
                                            });
                                          }
                                        },
                                      );
                                    },
                                  ),
                                );
                              }),
                        ),
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Color(0xffFBD580),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              iconSize: 35,
                              icon: Icon(Icons.add,color: Colors.white,),
                              onPressed: () {
                                showDialog(
                                  //error:物件比讀取早出來
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('新增品項'),
                                        content: TextField(
                                          onChanged: (String value) {
                                            input = value;
                                          },
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  todos.add(input);
                                                });
                                                createtodos();
                                                Navigator.pop(context);
                                              },
                                              child: Text('新增')),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: width*0.08),
                              child: Text(
                                '左滑以刪除',
                                style: TextStyle(
                                  color: Color(0xffefa51e),
                                  fontSize: 18,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: width*0.18),
                          margin: EdgeInsets.only(top: 15),
                          child: Image.asset(
                            "assets/Shopping cart_Two Color.png",
                            // width: width*0.85,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        }
      },
    );

  }
}