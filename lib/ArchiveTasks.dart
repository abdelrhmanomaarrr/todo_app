import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Comp.dart';
import 'cubit/cubits.dart';
import 'cubit/states.dart';

class ArchiveTasks extends StatelessWidget {
  const ArchiveTasks({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {

      },
      builder : (context,state)
      {
        var tasks = AppCubit.get(context).archivetasks;
        return tasksBuilder(
          tasks: tasks,
        );
      },
    ) ;
  }
}