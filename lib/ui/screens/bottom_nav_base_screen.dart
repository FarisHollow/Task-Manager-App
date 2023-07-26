import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/canceled_task_screen.dart';
import 'package:task_manager/ui/screens/completed_task_screen.dart';
import 'package:task_manager/ui/screens/in_progress_task_screen.dart';
import 'package:task_manager/ui/screens/new_task_screen.dart';

class BottomNavBaseScreen extends StatefulWidget {
  const BottomNavBaseScreen({super.key});

  @override
  State<BottomNavBaseScreen> createState() => _BottomNavBaseScreenState();
}

class _BottomNavBaseScreenState extends State<BottomNavBaseScreen> {

  int _selectedScreenIndex = 0;

  final List<Widget> _screen = const[
    NewTaskScreen(),
    InProgressTaskScreen(),
    CanceledTaskScreen(),
    CompletedTaskScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectedScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(
          color: Colors.grey
        ),
        showUnselectedLabels: true,
        selectedItemColor: Colors.deepPurple,
        onTap: (int index){
          _selectedScreenIndex = index;
          if(mounted){
            setState(() {

            });
          }
        },
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'New'),
        BottomNavigationBarItem(icon: Icon(Icons.account_tree), label: 'In Progress'),
        BottomNavigationBarItem(icon: Icon(Icons.cancel_outlined), label: 'Cancel'),
        BottomNavigationBarItem(icon: Icon(Icons.done_all), label: 'Completed'),
      ],),
    );
  }
}
