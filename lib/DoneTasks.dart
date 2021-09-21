import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/Comp.dart';


import 'cubit/cubits.dart';
import 'cubit/states.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {

      },
      builder : (context,state)
      {
        var tasks = AppCubit.get(context).donetasks;
        return tasksBuilder(
          tasks: tasks,
        );
      },
    ) ;
  }
}