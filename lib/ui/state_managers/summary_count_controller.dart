import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/summary_count_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class SummaryCountController extends GetxController{

  bool _getCountSummaryInProgress = false;
  SummaryCountModel _summaryCountModel = SummaryCountModel();

  bool get getCountSummaryInProgress => _getCountSummaryInProgress;
  SummaryCountModel get summaryCountModel => _summaryCountModel;





  Future<bool> getCountSummary() async {
    _getCountSummaryInProgress = true;
   update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.taskStatusCount);
    _getCountSummaryInProgress = false;
    if (response.isSuccess) {
      _summaryCountModel = SummaryCountModel.fromJson(response.body!);
      update();
      return true;
    } else {
      return false;
    }
  }

}