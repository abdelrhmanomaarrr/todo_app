import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/cubit/cubits.dart';
import 'package:todolist/cubit/states.dart';
import 'Comp.dart';

class HomeScreen extends StatelessWidget
{
  Database database;
  var scafoldkey=GlobalKey<ScaffoldState>();
  var formkey=GlobalKey<FormState>();
  var tittleController =  TextEditingController();
  var timeController =  TextEditingController();
  var dateController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context,AppStates state){
          if(state is AppInsertDataBaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context,AppStates state)
        {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scafoldkey,
            appBar: AppBar(
              title: Text
              (
                  cubit.titles[cubit.currentIndex]
              ),
            ),
            body: ConditionalBuilder(
              condition:state is! AppGetDataBaseLoadingState,
              builder: (context)=>cubit.Screens[cubit.currentIndex],
              fallback: (context)=> Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()
              {
                if(cubit.isBottomSheetShown){
                  if(formkey.currentState.validate())
                  {
                    cubit.insertTODatabase(title: tittleController.text, time: timeController.text, date: dateController.text);
                    // insertTODatabase
                    //   (
                    //   title:tittleController.text,
                    //   time: timeController.text,
                    //   date: dateController.text  ,
                    //
                    // ).then((value)
                    // {
                    //   getDataFromDatabase(database).then((value)
                    //   {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isBottomSheetShown=false;
                    //     //   FabIcon=Icons.edit;
                    //     //   tasks=value;
                    //     //   print(tasks);
                    //     // });
                    //   });
                    //
                    // });
                  }
                }else
                {
                  scafoldkey.currentState.showBottomSheet(
                        (context) => Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0,),
                      child: Form(
                        key: formkey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormFeild
                              (
                              controller: tittleController,
                              type: TextInputType.text,
                              validate: (String value)
                              {
                                if(value.isEmpty)
                                {
                                  return'tittle must not be embty';
                                }
                                return null;
                              },
                              lable: 'Task Tittle',
                              prefix: Icons.title,
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            defaultFormFeild
                              (
                              controller: timeController,
                              type: TextInputType.datetime,
                              onTab: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value)
                                {
                                  timeController.text=value.format(context).toString();
                                  print(value.format(context));
                                });
                              },
                              validate: (String value)
                              {
                                if(value.isEmpty)
                                {
                                  return'time must not be embty';
                                }
                                return null;
                              },
                              lable: 'Task Time',
                              prefix: Icons.watch_later_outlined,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            defaultFormFeild
                              (
                              controller: dateController,
                              type: TextInputType.datetime,
                              onTab: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2021-12-03'),
                                ).then((value)
                                {
                                  dateController.text=DateFormat.yMMMd().format(value);
                                });
                              },
                              validate: (String value)
                              {
                                if(value.isEmpty)
                                {
                                  return'date must not be embty';
                                }
                                return null;
                              },
                              lable: 'Date Time',
                              prefix: Icons.calendar_today,
                            )] ,
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  ).closed.then((value)
                  {
                    cubit.ChangeBottomSheetState(ishow: false, icon: Icons.edit,);

                  });
                  cubit.ChangeBottomSheetState(ishow: true, icon: Icons.add,);

                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                elevation: 20.0,
                currentIndex: AppCubit.get(context).currentIndex,
                onTap: (index){
                  cubit.ChangeIndex(index);
                },
                items:
                [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label:'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label:'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label:'Archive',
                  ),
                ]
            ),

          );
        },
      ),
    );
  }

}

