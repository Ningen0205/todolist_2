import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:todolist_2/pages/todo/create.dart';
import 'package:todolist_2/pages/account/login.dart';
import 'package:todolist_2/pages/todo/detail.dart';

import '../../logic/todo.dart';

class TodoListPageArguments {
  final String uid;
  const TodoListPageArguments({required this.uid});
}

class TodoListPage extends StatefulWidget {
  static const path = '/todos';

  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  void initState() {
    super.initState();
  }

  Widget buildTodos(String userId) {
    const doneIcon = Icon(Icons.done);
    const duringIcon = Icon(Icons.article);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('todos')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Text('エラーが発生しました。');
        }

        return ListView(
          children: snapshot.data!.docs.map((document) {
            final data = document.data()! as Map<String, dynamic>;
            final todo = Todo(
              id: document.id,
              userId: data['userId'],
              text: data['text'],
              isDone: data['isDone'],
            );

            return ListTile(
              tileColor: todo.isDone ? Colors.white30 : Colors.white,
              leading: const Icon(Icons.article),
              title: Text(todo.text),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TodoDetailPage.path,
                  arguments: TodoDetailPageArgument(uid: userId, todo: todo),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _args =
        ModalRoute.of(context)!.settings.arguments as TodoListPageArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoList'),
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
      body: Center(
        child: buildTodos(_args.uid),
      ),
    );
  }
}
