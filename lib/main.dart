import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // Constructor for MyApp. 'key' is an optional parameter used to identify widgets.
  const MyApp({super.key});

  // The build method describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    // MaterialApp is a convenience widget that wraps a number of widgets that are
    // commonly required for Material Design applications.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // The title of the application, used by the device's multi-tasking UI.
      title: 'Simple Todo App',
      // Define a new, warmer light theme.
      theme: ThemeData(
        brightness: Brightness.light, // Set the overall theme to light mode.
        primarySwatch: Colors.green, // A warm, inviting primary color.
        primaryColor: Colors.white, // A slightly darker shade for primary elements.
        scaffoldBackgroundColor: Colors.white, // Very light, creamy orange background.
        cardColor: Colors.white, // Pure white for cards to stand out.
        hintColor: Colors.grey[500], // Softer grey for hint text.

        // Define typography for light theme
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // App bar title text.
          bodyMedium: TextStyle(color: Colors.grey[800]), // Default body text color.
          labelLarge: TextStyle(color: Colors.grey[700]), // For text on buttons etc.
        ),

        // Styling for input fields
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(color: Colors.grey[500]),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)), // Slightly more rounded corners.
            borderSide: BorderSide(color: Colors.grey[300]!), // Light grey border.
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.green), // Vibrant accent when focused.
          ),
          fillColor: Colors.white, // White background for the input field itself.
          filled: true, // Enable background fill.
          contentPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0), // More generous padding.
        ),

        // Styling for elevated buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Vibrant orange accent color.
            foregroundColor: Colors.white, // White text on the button.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Matches input field rounding.
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Larger padding for buttons.
            elevation: 4.0, // Slight shadow for a softer lift.
          ),
        ),

        // Styling for checkboxes
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.green; // Accent color when checked.
            }
            return Colors.grey[400]; // Lighter grey when unchecked.
          }),
          checkColor: MaterialStateProperty.all(Colors.white), // White checkmark for contrast.
        ),

        // Dialog and SnackBar theming for consistency
        dialogBackgroundColor: Colors.white,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.grey[800], // Darker background for contrast on light theme.
          contentTextStyle: TextStyle(color: Colors.white),
          actionTextColor: Colors.deepOrangeAccent,
        ),
        useMaterial3: true, // Opt-in for Material 3 design features.
      ),
      // The home property defines the default route of the app.
      // Here, it's our TodoListScreen, which will display the list of tasks.
      home: const TodoListScreen(),
    );
  }
}

// TodoListScreen is a StatefulWidget because its state (the list of to-do items)
// can change over time based on user interactions (adding, deleting, completing tasks).
class TodoListScreen extends StatefulWidget {
  // Constructor for TodoListScreen.
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
  // This TextEditingController is specifically for the edit dialog to avoid conflicts.
  final TextEditingController _editTextFieldController = TextEditingController();


  // Function to add a new To-Do item to the list.
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
      // Find the index of the given todo in the list.
      final index = _todos.indexOf(todo);
      // If the todo is found, update its isCompleted status.
      if (index != -1) {
        _todos[index].isCompleted = !_todos[index].isCompleted;
      }
    });
  }

  // Function to delete a To-Do item from the list.
  // It takes the Todo object to be deleted.
  void _deleteTodo(Todo todo) {
    setState(() {
      // Remove the specified todo object from the _todos list.
      _todos.remove(todo);
    });
  }

  // New function to edit an existing To-Do item.
  // It takes the Todo object to edit and the new title string.
  void _editTodo(Todo todoToEdit, String newTitle) {
    if (newTitle.trim().isNotEmpty) { // Ensure the new title is not empty after trimming whitespace.
      setState(() {
        // Find the index of the todo to be edited.
        final index = _todos.indexOf(todoToEdit);
        if (index != -1) {
          // Update the title of the existing Todo object.
          _todos[index].title = newTitle.trim();
        }
      });
    }
  }

  // New function to display an alert dialog for editing a To-Do item.
  Future<void> _displayEditTodoDialog(BuildContext context, Todo todoToEdit) async {
    // Pre-fill the text field with the current title of the todo being edited.
    _editTextFieldController.text = todoToEdit.title;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: TextField(
            controller: _editTextFieldController, // Use the dedicated edit controller.
            decoration: InputDecoration(
              hintText: 'Edit your todo...',
              // Styles for the InputDecoration are inherited from ThemeData.inputDecorationTheme.
            ),
            autofocus: true, // Automatically focus on the text field when dialog appears.
            onSubmitted: (value) {
                // When the user submits the text, save the changes and close the dialog.
                _editTodo(todoToEdit, value);
                Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _editTextFieldController.clear(); // Clear the controller if cancelled.
                Navigator.of(context).pop(); // Close the dialog.
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                // Save the edited title.
                _editTodo(todoToEdit, _editTextFieldController.text);
                Navigator.of(context).pop(); // Close the dialog.
              },
            ),
          ],
        );
      },
    );
  }


  // The build method describes the user interface for this StatefulWidget.
  // It's called initially and whenever setState() is called.
  @override
  Widget build(BuildContext context) {
    // Scaffold provides a basic Material Design visual structure.
    return Scaffold(
      // AppBar is the top bar of the application.
      appBar: AppBar(
        // The text displayed in the app bar.
        title: const Text('TASK MANAGER APP'),
        // Center the title for better aesthetics.
        // centerTitle: true,
        // Using the theme's primaryColor for the app bar background.
        backgroundColor: Theme.of(context).primaryColor,
        // Title text color is set in the theme's TextTheme.titleLarge.
      ),
      // The body of the Scaffold, which contains the main content of the screen.
      // We use a Column to stack the input row and the list vertically.
      body: Column(
        children: [
          // Padding around the input row for visual spacing.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Expanded widget makes the TextField take up most of the available horizontal space.
                Expanded(
                  child: TextField(
                    controller: _textFieldController, // Connects the TextField to our controller.
                    // InputDecoration is now mostly handled by inputDecorationTheme in ThemeData.
                    decoration: InputDecoration(
                      hintText: 'Enter a new todo...', // Placeholder text.
                      // The border, fill, and text colors are now defined in the ThemeData.
                    ),
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color), // Text entered by user
                    autofocus: false, // Don't autofocus initially, as it's always visible.
                    onSubmitted: (value) {
                      // When the user submits the text (e.g., by pressing Enter on a keyboard),
                      // call _addTodo to add the task.
                      _addTodo();
                    },
                  ),
                ),
                // Add some horizontal space between the TextField and the button.
                const SizedBox(width: 10),
                // Button to add the todo.
                ElevatedButton(
                  onPressed: _addTodo, // When pressed, call _addTodo.
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          // Expanded widget makes the ListView take up the remaining vertical space.
          Expanded(
            child: _todos.isEmpty
                // If the list is empty, display a message.
                ? Center(
                    child: Text(
                      'No tasks yet! Type in the field above and click "Add".',
                      style: TextStyle(fontSize: 18, color: Theme.of(context).hintColor), // Using hintColor for message.
                      textAlign: TextAlign.center,
                    ),
                  )
                // If there are tasks, display them in a ListView.
                : ListView.builder(
                    // itemCount specifies the number of items in the list.
                    itemCount: _todos.length,
                    // itemBuilder is called for each item to build its widget.
                    itemBuilder: (context, index) {
                      // Get the current Todo item from the list.
                      final Todo todo = _todos[index];
                      // Dismissible widget allows the user to dismiss a list item by swiping.
                      return Dismissible(
                        key: Key(todo.title + index.toString()), // Unique key for each dismissible item.
                        direction: DismissDirection.endToStart, // Allow swiping from right to left.
                        background: Container(
                          color: Colors.green, // Red background when swiping to delete.
                          alignment: Alignment.centerRight, // Align icon to the right.
                          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding for the icon.
                          child: const Icon(Icons.delete, color: Colors.white), // Delete icon.
                        ),
                        // onDismissed is called when the item is dismissed.
                        onDismissed: (direction) {
                          // Show a SnackBar to confirm deletion and offer an undo option.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"${todo.title}" deleted'),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  setState(() {
                                    // Re-insert the deleted todo at its original position if UNDO is pressed.
                                    _todos.insert(index, todo);
                                  });
                                },
                              ),
                            ),
                          );
                          // Actually delete the todo from the list.
                          _deleteTodo(todo);
                        },
                        // The actual content of the list tile.
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          elevation: 2.0, // Slightly increased elevation for a softer shadow.
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // More rounded cards.
                          // Card background color comes from ThemeData.cardColor.
                          child: ListTile(
                            // Title of the To-Do item.
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                // Strikethrough text if the task is completed.
                                decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                                // Color changes based on completion status for better visibility.
                                color: todo.isCompleted ? Colors.grey[500] : Colors.grey[800], // Darker grey for completed, almost black for active.
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
                            // Trailing section now contains both edit and delete buttons.
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min, // Keep the row size minimal.
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.green), // Edit icon.
                                  onPressed: () {
                                    // Show the edit dialog when pressed.
                                    _displayEditTodoDialog(context, todo);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () {
                                    // Show a confirmation dialog before deleting.
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
                                              child: const Text('Delete'),
                                              // Explicitly setting color for consistency, though theme handles it.
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
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
                              ],
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

// A simple model class to represent a single To-Do item.
class Todo {
  // The title or description of the To-Do item.
  String title;
  // A boolean indicating whether the To-Do item is completed or not.
  bool isCompleted;

  // Constructor for the Todo class.
  // 'required' ensures that these parameters must be provided when creating a Todo object.
  Todo({required this.title, this.isCompleted = false}); // Default isCompleted to false.
}