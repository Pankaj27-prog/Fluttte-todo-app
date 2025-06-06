import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    isCompleted: json['isCompleted'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class TaskDashboard extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const TaskDashboard({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  List<Task> _tasks = [];
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Task? _editingTask;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList('tasks') ?? [];
    setState(() {
      _tasks = tasksJson
          .map((taskJson) => Task.fromJson(json.decode(taskJson)))
          .toList();
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks
        .map((task) => json.encode(task.toJson()))
        .toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  void _showAddEditTaskDialog([Task? task]) {
    _editingTask = task;
    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
    } else {
      _titleController.clear();
      _descriptionController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task == null ? 'Add New Task' : 'Edit Task'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _titleController.clear();
              _descriptionController.clear();
              _editingTask = null;
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _saveTask,
            child: Text(task == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (_editingTask != null) {
          // Update existing task
          final index = _tasks.indexWhere((t) => t.id == _editingTask!.id);
          _tasks[index] = Task(
            id: _editingTask!.id,
            title: _titleController.text,
            description: _descriptionController.text,
            isCompleted: _editingTask!.isCompleted,
            createdAt: _editingTask!.createdAt,
          );
        } else {
          // Add new task
          _tasks.add(Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _titleController.text,
            description: _descriptionController.text,
            createdAt: DateTime.now(),
          ));
        }
      });
      _saveTasks();
      Navigator.pop(context);
      _titleController.clear();
      _descriptionController.clear();
      _editingTask = null;
    }
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
    _saveTasks();
  }

  void _toggleTaskCompletion(String id) {
    setState(() {
      final task = _tasks.firstWhere((task) => task.id == id);
      task.isCompleted = !task.isCompleted;
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.black87 : Colors.indigo,
        title: const Text('Your Tasks'),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: widget.isDarkMode ? Colors.yellow : Colors.white,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 64,
                    color: widget.isDarkMode ? Colors.white70 : Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: widget.isDarkMode ? Colors.white70 : Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a task to get started',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: widget.isDarkMode ? Colors.white70 : Colors.grey,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => _toggleTaskCompletion(task.id),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task.description.isNotEmpty)
                          Text(task.description),
                        Text(
                          'Created: ${task.createdAt.toString().split('.')[0]}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showAddEditTaskDialog(task),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTask(task.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}