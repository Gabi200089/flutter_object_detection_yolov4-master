import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:object_detection/global.dart';

class DatabaseManager{
  final profileList = FirebaseFirestore.instance.collection('flutter-user');
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> updateUserData(String name, String age, String height, String sexual, String weight,String photo) async {
    final user = auth.currentUser;
    String mail = user.email;
    return await profileList.doc(mail).collection('infos').doc('userInfo').update({
      'name':name,
      'weight':weight,
      'height':height,
      'age':age,
      'sexual':sexual,
      'photo':photo,
    });
  }

  void getData() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('userInfo');
    await documentReference.get().then((DocumentSnapshot doc) async{

      name = doc['name'];
      height = doc['height'];
      weight = doc['weight'];
      age = doc['age'];
      sexual = doc['sexual'];
      //print(name+height+weight+age+sexual);
    });
  }

  createPlans(){
    //CollectionReference todocollection = FirebaseFirestore.instance.collection('TODOs');
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('userPlans');
    return documentReference.set({
      //'$_dateTime': input,
      'selectedPlan' : selectedPlan,
      'decided' : decided,
      'changed_tdee' : changed_tdee,
    });
  }
  
  Future<void> createUserData(String name, String weight, int height, String age, String sexual,String photo) async {
    final user = auth.currentUser;
    // String mail = user.email;
    return await profileList.doc(user_email).collection('infos').doc('userInfo').set({
      'name':name,
      'weight':weight,
      'height':height,
      'age':age,
      'sexual':sexual,
      'photo':photo,
    });
  }

}

