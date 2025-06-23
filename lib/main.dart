import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Constructor for MyApp. 'key' is an optional parameter used to identify widgets.
  const MyApp({super.key});

  // The build method describes the part of the user interface represented by this widget.
  // For StatelessWidget, it's called once when the widget is inserted into the widget tree.
  @override
  Widget build(BuildContext context) {
    // MaterialApp is a convenience widget that wraps a number of widgets that are
    // commonly required for Material Design applications.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // The title of the application, used by the device's multi-tasking UI.
      title: 'Simple Todo App',
      // The theme of the application. Here we're using a blue color scheme.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true, // Opt-in for Material 3 design features.
      ),
      // The home property defines the default route of the app.
      // Here, it's our TodoListScreen, which will display the list of tasks.
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});
  // createState() creates the mutable state for this widget at a given location in the widget tree.
  // It returns an instance of _TodoListScreenState.
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

// _TodoListScreenState holds the mutable state for the TodoListScreen.
// It extends State<TodoListScreen>, indicating it's the state for the TodoListScreen widget.
class _TodoListScreenState extends State<TodoListScreen> {
  // This is the list that will hold our Todo objects.
  // It's initialized as an empty list and will be updated when tasks are added, completed, or deleted.
  final List<Todo> _todos = [];

  // This TextEditingController is used to get the text input from the user
  // when they want to add a new task.
  final TextEditingController _textFieldController = TextEditingController();

  void _addTodo() {
    final String newTodoTitle = _textFieldController.text.trim(); // Get text and remove leading/trailing spaces.
    if (newTodoTitle.isNotEmpty) {
      // setState is crucial for updating the UI. Any changes made inside setState()
      // will trigger a rebuild of the widget, reflecting the new state on screen.
      setState(() {
        // Add a new Todo object to the _todos list.
        // The new task is initially not completed (isCompleted: false).
        _todos.add(Todo(title: newTodoTitle, isCompleted: false));
        _textFieldController.clear(); // Clear the text field after adding.
      });
    }
  }

  // Function to toggle the completion status of a To-Do item.
  // It takes the Todo object whose status needs to be changed.
  void _toggleTodoStatus(Todo todo) {
    setState(() {
      final index = _todos.indexOf(todo);
      if (index != -1) {
        _todos[index].isCompleted = !_todos[index].isCompleted;
      }
    });
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.remove(todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textFieldController, // Connects the TextField to our controller.
                    decoration: const InputDecoration(
                      hintText: 'Enter a new todo...', // Placeholder text.
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)), // Rounded corners for the input.
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0), // Adjust padding inside.
                    ),
                    autofocus: false, // Don't autofocus initially, as it's always visible.
                    onSubmitted: (value) {
                      _addTodo();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTodo, // When pressed, call _addTodo.
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners for the button.
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _todos.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks yet! Type in the field above and click "Add".',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final Todo todo = _todos[index];
                      return Dismissible(
                        key: Key(todo.title + index.toString()), // Unique key for each dismissible item.
                        direction: DismissDirection.endToStart, // Allow swiping from right to left.
                        background: Container(
                          color: Colors.red, // Red background when swiping to delete.
                          alignment: Alignment.centerRight, // Align icon to the right.
                          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding for the icon.
                          child: const Icon(Icons.delete, color: Colors.white), // Delete icon.
                        ),
                        onDismissed: (direction) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"${todo.title}" deleted'),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  setState(() {
                                    _todos.insert(index, todo);
                                  });
                                },
                              ),
                            ),
                          );
                          _deleteTodo(todo);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          child: ListTile(
                            // Title of the To-Do item.
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                // Strikethrough text if the task is completed.
                                decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                                color: todo.isCompleted ? Colors.grey : Colors.black87, // Dim text if completed.
                              ),
                            ),
                            // Leading checkbox to mark as completed/incomplete.
                            leading: Checkbox(
                              value: todo.isCompleted, // The current status of the todo.
                              onChanged: (bool? newValue) {
                                // When the checkbox is tapped, toggle the status.
                                _toggleTodoStatus(todo);
                              },
                            ),
                            // Trailing icon button for direct deletion (alternative to swipe).
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: Text('Are you sure you want to delete "${todo.title}"?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close dialog.
                                          },
                                        ),
                                        ElevatedButton(
                                          // ignore: sort_child_properties_last
                                          child: const Text('Delete'),
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                          onPressed: () {
                                            _deleteTodo(todo); // Delete the todo.
                                            Navigator.of(context).pop(); // Close dialog.
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            // Tapping the entire list tile can also toggle completion.
                            onTap: () {
                              _toggleTodoStatus(todo);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Todo {
  String title;
  bool isCompleted;

  Todo({required this.title, this.isCompleted = false}); // Default isCompleted to false.
}