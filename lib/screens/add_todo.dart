import 'package:flutter/material.dart';

import '../services/todo_services.dart';
import '../utils.dart';

class AddTodo extends StatefulWidget {
  final Map? todo;
  const AddTodo({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  bool isEdit = false;

  addTodo() async {
    //Get the data from form
    final title = _titleTextController.text;
    final description = _descriptionTextController.text;

    //Submit data to the server
    final isSuccess = await TodoService.addTodo(title, description);

    //Display final response
    if (isSuccess) {
      _titleTextController.clear();
      _descriptionTextController.clear();
      print("Post Success");
      showMessage(context, message: "Task added successfully");
      Navigator.pop(context);
    } else{
      print("Error: Post failed");
      showMessage(context, message: "Couldn't add task.");
    }
  }

  updateTodo() async {
    //Get the data from form
    final todo = widget.todo;
    if(todo == null) {
      print("Todo doesn't exist.");
      return;
    }
    final id = todo['_id'];
    final title = _titleTextController.text;
    final description = _descriptionTextController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    //Submit data to the server
    final isSuccess = await TodoService.updateTodo(id, title, description);

    //Display final response
    if (isSuccess) {
      print("Update Success");
      showMessage(context, message: "Task updated successfully.");
      Navigator.pop(context);
    } else{
      print("Error: Update failed");
      showMessage(context, message: "Couldn't update task.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if(todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      _titleTextController.text = title;
      _descriptionTextController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  isEdit ? "Edit Todo" : "Add Todo",
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 28,
                      fontWeight: FontWeight.w800),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: _titleTextController,
                  decoration: const InputDecoration(hintText: "Title"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: TextField(
                  controller: _descriptionTextController,
                  decoration: const InputDecoration(hintText: "Description"),
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: isEdit ? updateTodo : addTodo,
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                  ),
                  child: Text(
                    isEdit ? "Update" : "Add",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
