library my_prj.globals;
import 'dart:async';

import 'package:image/image.dart' as imageLib;

import 'package:object_detection/model/firebase_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';

// String user_email="zzz@gmail.com";
String user_email;
String photo;
bool mainpage=true;//確認是否主畫面
String food_url = "";//飲食紀錄照片
String ingredient_url = "";//食材管理照片
List food_name=[] ;
List food_time=[];
List food_img=[];
List food_pro=[] ;
List food_kcal=[];
List food_car=[];
List food_fat=[];
List food_num=[];
List food_type=[];


List food_breakfast=[];
List food_lunch=[];
List food_dinner=[];
List food_other=[];

String nameee;

int food_diary_index;
int fd_index;

int dailyKcal=3000;
int kcal_minus=0;


//ingredient
List ingredient_name=[];
List ingredient_exp=[];
List ingredient_time=[];
List ingredient_num=[];
List ingredient_image=[];
List ingredient_class=[];
List ingredient_id=[];
int ingredient_index;

List ingredient_name_1=[];
List ingredient_exp_1=[];
List ingredient_time_1=[];
List ingredient_num_1=[];
List ingredient_image_1=[];
List ingredient_class_1=[];
List ingredient_id_1=[];
int ingredient1_index;

List ingredient_name_2=[];
List ingredient_exp_2=[];
List ingredient_time_2=[];
List ingredient_num_2=[];
List ingredient_image_2=[];
List ingredient_class_2=[];
List ingredient_id_2=[];
int ingredient2_index;

List ingredient_name_3=[];
List ingredient_exp_3=[];
List ingredient_time_3=[];
List ingredient_num_3=[];
List ingredient_image_3=[];
List ingredient_class_3=[];
List ingredient_id_3=[];
int ingredient3_index;

List ingredient_name_4=[];
List ingredient_exp_4=[];
List ingredient_time_4=[];
List ingredient_num_4=[];
List ingredient_image_4=[];
List ingredient_class_4=[];
List ingredient_id_4=[];
int ingredient4_index;

//login & register
String name = 'user';
int weight = 50;
int height = 160;
int age = 20;
String sexual = '女';
String title = '';
FirebaseAuth auth = FirebaseAuth.instance;
final user = auth.currentUser;
String mail = user.email;
double bmr = 0;
double tdee = 0;
String selectedPlan = ''; //方案
String decided = ''; //%數
double changed_tdee = 0;
double protein = 0;
double fat = 0;
double carb = 0;


//食譜
List foods = [];
List gredients = [];
List link = [];
List pic = [];
//排序的食譜
List order_foods = [];
List order_gredients = [];
List order_link = [];
List order_pic = [];
//有材料的食譜
List has_foods = [];
List has_gredients = [];
List has_link = [];
List has_pic = [];
//查看的那個食譜
List look_gredients= [];
List look_link= [];
int recipe_index;
List yesno = [];
//過期排序
List sorted_exp=[];
List sorted_id=[];
List sorted_exp1=[];
List sorted_id1=[];
List sorted_exp2=[];
List sorted_id2=[];
List sorted_exp3=[];
List sorted_id3=[];
List sorted_exp4=[];
List sorted_id4=[];

//季軒
//撿便宜
List prices1 = [];
List picture1 = [];
List product1 = [];
List links1=[];
List original1=[];

List prices2 = [];
List picture2 = [];
List product2 = [];
List links2=[];
List original2=[];

List prices3 = [];
List picture3 = [];
List product3 = [];
List links3=[];
List original3=[];

List prices4 = [];
List picture4 = [];
List product4 = [];
List links4=[];
List original4=[];


String search="";

int h=719;//mediaquery用
int w=393;//mediaquery用
int h1=719;
int w1=393;

//mall
List prices5 = [];
List picture5 = [];
List product5 = [];
List links5=[];
List original5=[];

int foundjung_index;

//shopping
List amount0 = [];
List name0 = [];
List num0 = [];
List picture0 =[];
List prices0 = [];
List id0 = [];

//yolov4
String detect_path;

imageLib.Image detect_image;

//exercise video
Timer video_timer;
int video_time;
bool reward;
VideoPlayerController controller;