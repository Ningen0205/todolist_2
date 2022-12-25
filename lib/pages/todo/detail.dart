import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist_2/logic/todo.dart';
import 'package:todolist_2/pages/todo/create.dart';
import 'package:todolist_2/pages/todo/list.dart';

import '../account/login.dart';

class TodoDetailPageArgument {
  final String uid;
  final Todo todo;

  TodoDetailPageArgument({required this.uid, required this.todo});
}

class TodoDetailPage extends StatefulWidget {
  static const path = '/todo/detail';

  @override
  TodoDetailPageState createState() => TodoDetailPageState();
}

class TodoDetailPageState extends State<TodoDetailPage> {
  final _form = GlobalKey<FormState>();

  late String? text;
  late bool? isDone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var _args =
        ModalRoute.of(context)!.settings.arguments as TodoDetailPageArgument;

    setState(() {
      text = _args.todo.text;
      isDone = _args.todo.isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _args =
        ModalRoute.of(context)!.settings.arguments as TodoDetailPageArgument;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('作成'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  CreateTodoPage.path,
                  arguments: CreateTodoPageArguments(uid: _args.uid),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('一覧'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TodoListPage.path,
                  arguments: TodoListPageArguments(uid: _args.uid),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('ログアウト'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, LoginPage.path);
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
                labelText: 'Todoの内容',
              ),
              initialValue: _args.todo.text,
              onChanged: (value) {
                setState(() {
                  text = value;
                });
              },
            ),
            Checkbox(
              value: isDone,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    isDone = value;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (text != _args.todo.text || isDone != _args.todo.isDone) {
                  var docRef = FirebaseFirestore.instance
                      .collection('todos')
                      .doc(_args.todo.id);
                  await docRef.update({'text': text, 'isDone': isDone});
                }

                if (!mounted) return;

                Navigator.pushReplacementNamed(
                  context,
                  TodoListPage.path,
                  arguments: TodoListPageArguments(uid: _args.uid),
                );
              },
              child: const Text('編集完了'),
            )
          ],
        ),
      ),
    );
  }
}
