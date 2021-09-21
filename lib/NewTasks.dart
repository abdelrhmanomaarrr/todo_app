import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/cubit/cubits.dart';
import 'package:todolist/cubit/states.dart';
import 'Comp.dart';

class NewTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
    listener: (context,state)
    {

    },
    builder : (context,state)
    {
      var tasks = AppCubit.get(context).newtasks;
      return tasksBuilder(
        tasks: tasks,
      );
    },
    ) ;
  }
}
