import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/update_task_status_sheet.dart';
import 'package:task_manager/ui/state_managers/delete_task_controller.dart';
import 'package:task_manager/ui/widgets/task_list_tile.dart';
import 'package:task_manager/ui/widgets/user_profile_banner.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({Key? key}) : super(key: key);

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  bool _getCanceledTasksCanceled = false;
  TaskListModel _taskListModel = TaskListModel();
  final DeleteTaskController _deleteTaskController = Get.find<DeleteTaskController>();


  Future<void> getCanceledTasks() async {
    _getCanceledTasksCanceled = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.canceledTasks);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cancelling tasks get failed')));
      }
    }
    _getCanceledTasksCanceled = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCanceledTasks();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserProfileAppBar(),
            Expanded(
              child: _getCanceledTasksCanceled
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
                                getCanceledTasks();


                              },
                              onCancel: () {
                                Get.back();
                              }

                          );
                        },
                        onEditTap: () {showStatusUpdateBottomSheet(_taskListModel.data![index]);},
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
          ],
        ),
      ),
    );
  }

  void showStatusUpdateBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskStatusSheet(task: task, onUpdate: () {
          getCanceledTasks();
        });
      },
    );
  }
}