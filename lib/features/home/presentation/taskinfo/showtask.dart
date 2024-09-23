
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_task/features/home/controller/taskcontroller.dart';
import 'package:getx_task/features/home/model/hivemodel/hive_model.dart';
import 'package:intl/intl.dart';

class ShowTasksPage extends StatelessWidget {
  final TaskController taskCtrl = Get.find();

  ShowTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: taskCtrl.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskCtrl.tasks[index];
                  final taskDate = task.date;
                  Color dateColor = taskDate.isBefore(DateTime.now())
                      ? Colors.red
                      : const Color.fromARGB(255, 1, 144, 6);

                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(
                      'Date: ${DateFormat.yMd().format(task.date)}, Time: ${task.time.format(context)}',
                      style: TextStyle(color: dateColor),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editTaskDialog(context, task, index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            taskCtrl.deleteTask(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editTaskDialog(BuildContext context, Task task, int index) {
    final TextEditingController taskTitleController = TextEditingController(text: task.title);
    DateTime? selectedDate = task.date;
    TimeOfDay? selectedTime = task.time;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskTitleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(selectedDate == null
                      ? 'Select Date'
                      : 'Date: ${DateFormat.yMd().format(selectedDate!)}'),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(3000),
                      );
                      if (pickedDate != null) {
                        selectedDate = pickedDate;
                      }
                    },
                    child: const Text('Choose Date'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(selectedTime == null
                      ? 'Select Time'
                      : 'Time: ${selectedTime?.format(context)}'),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        selectedTime = pickedTime;
                      }
                    },
                    child: const Text('Choose Time'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskTitleController.text.isNotEmpty &&
                    selectedDate != null &&
                    selectedTime != null) {
                  final updatedTask = Task(
                    title: taskTitleController.text,
                    date: selectedDate!,
                    time: selectedTime!,
                  );
                  taskCtrl.updateTask(index, updatedTask);
                  Get.back();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
