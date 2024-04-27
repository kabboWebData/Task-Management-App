import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskproject/dashboard/login.dart';
import 'package:taskproject/dashboard/registration.dart'; // Import the registration page if you haven't already

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late TextEditingController _taskNameController;
  late TextEditingController _requiredSkillController;
  List<Task> _tasks = []; // List to store tasks

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController();
    _requiredSkillController = TextEditingController();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _requiredSkillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press
        return true; // Return true to allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Task',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _taskNameController,
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _requiredSkillController,
                decoration: InputDecoration(
                  labelText: 'Required Skill',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add your logic to handle adding a new task here
                  String taskName = _taskNameController.text;
                  String requiredSkill = _requiredSkillController.text;

                  setState(() {
                    _tasks.add(Task(taskName, requiredSkill));
                  });

                  // Clear text fields after adding task
                  _taskNameController.clear();
                  _requiredSkillController.clear();
                },
                child: Text('Add Task'),
              ),
              SizedBox(height: 20),
              Text(
                'All Tasks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_tasks[index].name),
                      subtitle: Text(_tasks[index].requiredSkill),
                      trailing: IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            _tasks.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final auth = FirebaseAuth.instance;
            await auth.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
          child: Icon(Icons.logout),
        ),
      ),
    );
  }
}

class Task {
  final String name;
  final String requiredSkill;

  Task(this.name, this.requiredSkill);
}