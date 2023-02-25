import 'package:flutter/material.dart';
import '../services/todo_services.dart';
import '../utils.dart';
import 'add_todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List items = [];

  Future<void> fetchTodoList() async {
    setState(() {
      isLoading = true;
    });
    final response = await TodoService.fetchTodos();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      print("Error: Couldn't fetch todos.");
      showMessage(context, message: 'Something went wrong.');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    //Delete Item
    final isSuccess = await TodoService.deleteByID(id);
    if (isSuccess) {
      //Remove item from list
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      print("Error: Couldn't delete");
      showMessage(context, message: "Couldn't delete.");
    }
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodo());
    await Navigator.push(context, route);
    fetchTodoList();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddTodo(todo: item));
    await Navigator.push(context, route);
    fetchTodoList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Todo App",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: RefreshIndicator(
            color: Colors.blueGrey,
            onRefresh: fetchTodoList,
            child: Visibility(
              visible: items.isNotEmpty,
              replacement: const Center(
                child: Text(
                  "Empty List",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return Card(
                    color: Colors.grey.shade100,
                    elevation: 0.5,
                    child: ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 8,
                          child: Icon(
                            Icons.circle_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                      trailing: PopupMenuButton(
                        onSelected: (value) async {
                          if (value == "edit") {
                            navigateToEditPage(item);
                          } else if (value == "delete") {
                            await deleteById(id);
                            fetchTodoList();
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: "edit",
                              child: Text("Edit"),
                            ),
                            const PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ];
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.blueGrey,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPage,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.blueGrey,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
