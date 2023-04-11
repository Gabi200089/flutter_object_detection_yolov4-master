import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:date_format/date_format.dart';

const double kPickerHeight = 216.0;
const double kItemHeight = 40.0;
const Color kBtnColor = Colors.blue;//50
const Color kTitleColor = Colors.black;//120
const double kTextFontSize = 17.0;

typedef StringClickCallback = void Function(int selectIndex,Object selectStr);
typedef ArrayClickCallback = void Function( List<int> selecteds,List<dynamic> strData);
typedef DateClickCallback = void Function(dynamic selectDateStr,dynamic selectDate);


class JhPickerTool {

  /** 单列*/
  static void showStringPicker<T>(
      BuildContext context, {
        @required List<T> data,
        String title,
        String next,
        int normalIndex,
        PickerDataAdapter adapter,
        @required StringClickCallback clickCallBack,
      }) {

    openModalPicker(context,
        adapter: adapter ??  PickerDataAdapter( pickerdata: data, isArray: false),
        clickCallBack:(Picker picker, List<int> selecteds){
          //print(picker.adapter.text);
          clickCallBack(selecteds[0],data[selecteds[0]]);
        },
        selecteds: [normalIndex??0] ,
        title: title,
      next: next,
    );
  }



  static void openModalPicker(
      BuildContext context, {
        @required PickerAdapter adapter,
        String title,
        String next,
        List<int> selecteds,
        @required PickerConfirmCallback clickCallBack,
      }) {
    new Picker(
        adapter: adapter,
        title: new Text(title ?? "請選擇",style:TextStyle(color: kTitleColor,fontSize: kTextFontSize)),
        selecteds: selecteds,
        cancelText: '取消',
        confirmText: next??'確定',
        cancelTextStyle: TextStyle(color: kBtnColor,fontSize: kTextFontSize),
        confirmTextStyle: TextStyle(color: kBtnColor,fontSize: kTextFontSize),
        textAlign: TextAlign.right,
        itemExtent: kItemHeight,
        height: kPickerHeight,
        selectedTextStyle: TextStyle(color: Colors.black),
        onConfirm:clickCallBack
    ).showModal(context);
  }

  static void showNumberPicker(
      BuildContext context, {
        // @required List<T> data,
        int min,
        int max,
        String title,
        int normalIndex,
        PickerDataAdapter adapter,
        @required StringClickCallback clickCallBack,
      }){

    openNumberModalPicker(context,
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
              begin: min,
              end: max,
              onFormatValue: (v) {
                return "$v歲" ;
              }
          ),
        ]),

        clickCallBack:(Picker picker, List<int> value){
          print(value.toString());
          print(picker.getSelectedValues());
          clickCallBack(value[0],picker.getSelectedValues());
        },
        selecteds: [normalIndex??0] ,
        title: title);
  }

  static void openNumberModalPicker(
      BuildContext context, {
        @required PickerAdapter adapter,
        String title,
        List<int> selecteds,
        @required PickerConfirmCallback clickCallBack,
      }) {
    new Picker(
        adapter: adapter,
        title: new Text(title ?? "請選擇",style:TextStyle(color: kTitleColor,fontSize: kTextFontSize)),
        selecteds: selecteds,
        cancelText: '取消',
        confirmText: '確定',
        cancelTextStyle: TextStyle(color: kBtnColor,fontSize: kTextFontSize),
        confirmTextStyle: TextStyle(color: kBtnColor,fontSize: kTextFontSize),
        textAlign: TextAlign.right,
        itemExtent: kItemHeight,
        height: kPickerHeight,
        selectedTextStyle: TextStyle(color: Colors.black),
        onConfirm: clickCallBack,
    ).showModal(context);
  }


  // static void showPickerNumberFormatValue(BuildContext context) {
  //   Picker(
  //       adapter: NumberPickerAdapter(data: [
  //         NumberPickerColumn(
  //             begin: 0,
  //             end: 999,
  //             onFormatValue: (v) {
  //               return v < 10 ? "0$v歲" : "$v歲";
  //             }
  //         ),
  //         NumberPickerColumn(begin: 100, end: 200),
  //       ]),
  //       delimiter: [
  //         PickerDelimiter(child: Container(
  //           width: 30.0,
  //           alignment: Alignment.center,
  //           child: Icon(Icons.more_vert),
  //         ))
  //       ],
  //       hideHeader: true,
  //       title: Text("Please Select"),
  //       selectedTextStyle: TextStyle(color: Colors.blue),
  //       onConfirm: (Picker picker, List value) {
  //         print(value.toString());
  //         print(picker.getSelectedValues());
  //       }
  //   ).showDialog(context);
  // }

}