import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist_2/pages/todo/list.dart';

import '../account/login.dart';

class CreateTodoPageArguments {
  final String uid;

  CreateTodoPageArguments({required this.uid});
}

class CreateTodoPage extends StatefulWidget {
  static const path = '/todos/new';

  const CreateTodoPage({super.key});

  @override
  CreateTodoPageState createState() => CreateTodoPageState();
}

class CreateTodoPageState extends State<CreateTodoPage> {
  String _inputText = '';
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void onPressedCreateButton(String uid) async {}

  @override
  Widget build(BuildContext context) {
    var _args =
        ModalRoute.of(context)!.settings.arguments as CreateTodoPageArguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Todo'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('作成'),
              onTap: () {
                Navigator.pushNamed(context, CreateTodoPage.path,
                    arguments: CreateTodoPageArguments(uid: _args.uid));
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('一覧'),
              onTap: () {
                Navigator.pushNamed(context, TodoListPage.path,
                    arguments: TodoListPageArguments(uid: _args.uid));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('ログアウト'),
              onTap: () async {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushReplacementNamed(context, LoginPage.path);
                });
              },
            )
          ],
        ),
      ),
      body: Form(
        key: _form,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'todo',
                hintText: 'ガムテープを買う',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please provide a value';
                }
                return null;
              },
              onChanged: (value) {
                _inputText = value;
              },
            ),
            const Padding(padding: EdgeInsets.all(5)),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('todos').add({
                  'userId': _args.uid,
                  'text': _inputText,
                  'isDone': false,
                });
                if (!mounted) return;
                Navigator.pushReplacementNamed(
                  context,
                  TodoListPage.path,
                  arguments: TodoListPageArguments(uid: _args.uid),
                );
              },
              child: const Text('create'),
            ),
          ],
        ),
      ),
    );
  }
}
