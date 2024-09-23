import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_task/features/home/model/hivemodel/hive_model.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  final TextEditingController taskController = TextEditingController();
  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();

  late Box<Task> taskBox;

  @override
  void onInit() {
    super.onInit();
    taskBox = Hive.box<Task>('tasks');
    loadTasks();
  }

  void loadTasks() {
    tasks.assignAll(taskBox.values.toList());
  }

  void addTask(Task task) {
    taskBox.add(task);
    tasks.add(task);
    clearInputs();
  }

  void updateTask(int index, Task updatedTask) {
    taskBox.add(updatedTask);
    tasks[index] = updatedTask;
  }
void deleteTask(int index) {
final task = tasks[index];
    taskBox.delete(task);
    tasks.removeAt(index);
}
 
  void clearInputs() {
    taskController.clear();
    selectedDate.value = null;
    selectedTime.value = null;
  }

  String formatDate(DateTime date) => DateFormat.yMd().format(date);
  String formatTime(TimeOfDay time, BuildContext context) =>
      time.format(context);

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3000),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      selectedTime.value = picked;
    }
  }
}
