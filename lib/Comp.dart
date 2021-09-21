
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/cubit/cubits.dart';

Widget defaultFormFeild({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTab,
  @required Function validate,
  @required String lable,
  @required IconData prefix,
  bool isClickable =true ,
})=>TextFormField(
  controller: controller,
  keyboardType:  type,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  validator: validate,
  onTap: onTab,
  enabled:isClickable ,
  decoration: InputDecoration(
      labelText: lable,
      prefixIcon:
      Icon
        (
        prefix,
      )
  ),
);

Widget buildTaskItem(Map  model,context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 40.0,
  
          child: Text('${model['time']}'),
  
        ),
  
        SizedBox(
  
          width: 20,
  
        ),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            children: [
  
              Text('${model['title']}',
  
                style: TextStyle(
  
                  fontSize: 16.0,
  
                  fontWeight: FontWeight.bold,
  
                ),),
  
              Text('${model['date']}',
  
                style: TextStyle(
  
                  color: Colors.grey,
  
                ),),
  
            ],
  
          ),
  
        ),
  
        SizedBox(
  
          width: 20,
  
        ),
  
        IconButton(icon: Icon(Icons.check_box,),
  
          color: Colors.green,
  
          onPressed:()
  
        {
  
  AppCubit.get(context).updateData(status: 'done', id: model['id'],);
  
        },),
  
        IconButton(icon: Icon(Icons.archive,) ,
  
          color: Colors.black54,
  
          onPressed:()
  
        {
  
          AppCubit.get(context).updateData(status: 'archive', id: model['id'],);
  
        },),
  
      ],
  
    ),
  
  ),
  onDismissed: (direction)
  {
AppCubit.get(context).deleteData(id: model['id'],);
  },
);
Widget tasksBuilder(
{
  @required List<Map> tasks,
})=> ConditionalBuilder(
  condition: tasks.length>0,
  builder: (context)=>ListView.separated(
      itemBuilder: (context, index ) => buildTaskItem(tasks[index],context  ),
      separatorBuilder: (context,index)=> Container
        (
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
      itemCount: tasks.length),
  fallback: (context)=>Center(
    child: Column
      (
      mainAxisAlignment: MainAxisAlignment.center,

      children:
      [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text('No Tasks Yet , Please Add Some Tasks',
          style: TextStyle
            (
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),

      ],
    ),
  ),
);