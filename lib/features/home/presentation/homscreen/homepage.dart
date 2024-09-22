


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_task/features/home/controller/taskcontroller.dart';
import 'package:getx_task/features/home/model/hivemodel/hive_model.dart';
import 'package:getx_task/features/home/presentation/taskinfo/showtask.dart';
import 'package:intl/intl.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final TaskController taskCtrl = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 187, 100, 100),
        centerTitle: true,
        title: const Text("ToDo App"),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Color.fromARGB(255, 227, 202, 202))]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() => Text(
                        taskCtrl.selectedDate.value == null
                            ? "Select date"
                            : 'Date: ${DateFormat.yMd().format(taskCtrl.selectedDate.value!)}',
                        style: const TextStyle(fontSize: 20),
                      )),
                      ElevatedButton(
                        onPressed: () => taskCtrl.selectDate(context),
                        child: const Text("Choose Date"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() => Text(
                        taskCtrl.selectedTime.value == null
                            ? "Select Time"
                            : 'Time: ${taskCtrl.selectedTime.value!.format(context)}',
                        style: const TextStyle(fontSize: 20),
                      )),
                      ElevatedButton(
                        onPressed: () => taskCtrl.selectTime(context),
                        child: const Text("Choose Time"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: const BoxDecoration(color: Color.fromARGB(255, 227, 202, 202)),
            child: TextFormField(
              controller: taskCtrl.taskController,
              decoration: const InputDecoration(
                hintText: 'Enter a task',
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (taskCtrl.taskController.text.isNotEmpty &&
                  taskCtrl.selectedDate.value != null &&
                  taskCtrl.selectedTime.value != null) {
                final newTask = Task(
                  title: taskCtrl.taskController.text,
                  date: taskCtrl.selectedDate.value!,
                  time: taskCtrl.selectedTime.value!,
                );
                taskCtrl.addTask(newTask);
              }
            },
            child: const Text('Submit Task'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Get.to(() => ShowTasksPage()),
            child: const Text('Show Tasks'),
          ),
        ],
      ),
    );
  }
}
