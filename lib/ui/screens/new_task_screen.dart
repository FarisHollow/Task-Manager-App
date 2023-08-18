import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/screens/update_task_status_sheet.dart';
import 'package:task_manager/ui/state_managers/delete_task_controller.dart';
import 'package:task_manager/ui/state_managers/summary_count_controller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/summary_card.dart';
import 'package:task_manager/ui/widgets/task_list_tile.dart';
import 'package:task_manager/ui/widgets/user_profile_banner.dart';

import 'update_task_bottom_sheet.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskInProgress = false;

  TaskListModel _taskListModel = TaskListModel();
  final SummaryCountController _summaryCountController = Get.find<SummaryCountController>();
  final DeleteTaskController _deleteTaskController = Get.find<DeleteTaskController>();

  @override
  void initState() {
    super.initState();
    // after widget binding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _summaryCountController.getCountSummary();
      getNewTasks();
    });
  }



  Future<void> getNewTasks() async {
    _getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.newTasks);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Summary data get failed')));
      }
    }
    _getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: [
            const UserProfileAppBar(),
            GetBuilder<SummaryCountController>(
                builder: (_) {
                  if (_summaryCountController.getCountSummaryInProgress ==
                      true) {
                    return const Center(child: LinearProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 80,
                      width: double.infinity,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _summaryCountController.summaryCountModel
                            .data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return SummaryCard(
                            title: _summaryCountController.summaryCountModel
                                .data![index].sId ?? 'New',
                            number: _summaryCountController.summaryCountModel
                                .data![index].sum ?? 0,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 4,
                          );
                        },
                      ),
                    ),
                  );
                }

            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getNewTasks();
                  _summaryCountController.getCountSummary();
                },
                child: _getNewTaskInProgress
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : ListView.separated(
                  itemCount: _taskListModel.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return GetBuilder<DeleteTaskController>(
                      builder: (_) {
                        return TaskListTile(
                          data: _taskListModel.data![index],
                          onDeleteTap: () {
                            Get.defaultDialog(
                                title: "Alert!",
                                titlePadding: const EdgeInsets.all(8),

                                middleText: "Confirm Delete?",
                                barrierDismissible: false,

                                textConfirm: "Confirm",
                                textCancel: "Cancel",

                                backgroundColor: Colors.white70,
                                radius: 3,

                                onConfirm: () {
                                  _deleteTaskController.deleteTask(_taskListModel.data![index].sId!);
                                   Get.back();
                                   Get.snackbar("Deleted", "Task deleted successfully",
                                   snackPosition: SnackPosition.BOTTOM);
                                   getNewTasks();


                                },
                                onCancel: () {
                                  Get.back();
                                }


                            );
                          },

                          onEditTap: () {
                            // showEditBottomSheet(_taskListModel.data![index]);
                            showStatusUpdateBottomSheet(_taskListModel
                                .data![index]);
                          },
                        );
                      }
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 4,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddNewTaskScreen()));
        },
      ),
    );
  }

  void showEditBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskSheet(
          task: task,
          onUpdate: () {
            getNewTasks();
          },
        );
      },
    );
  }


  void showStatusUpdateBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskStatusSheet(task: task, onUpdate: () {
          getNewTasks();
        });
      },
    );
  }
}