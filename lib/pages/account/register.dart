import 'package:flutter/material.dart';
import 'package:todolist_2/logic/account.dart';
import 'package:todolist_2/pages/account/login.dart';
import 'package:todolist_2/pages/todo/list.dart';

class RegisterPage extends StatefulWidget {
  static const String path = '/register';

  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  String _inputEmail = '';
  String _inputPassword = '';
  String _errorText = '';

  final AccountLogic _accountLogic = AccountLogic();

  final _form = GlobalKey<FormState>();
  void onPressedRegisterButton() {
    if (_form.currentState == null) return;
    if (!_form.currentState!.validate()) return;
    try {
      _accountLogic.register(_inputEmail, _inputPassword);
    } on WeekPasswordException catch (_) {
      setState(() {
        _errorText = 'パスワードをより強固なものにしてください。';
      });
    } on EmailAlreadyInUseException catch (_) {
      setState(() {
        _errorText = '別のメールアドレスを使用して、登録してください。';
      });
    } on UnknownRegisterFailedException catch (_) {
      setState(() {
        _errorText = '不明なエラーが発生しました、時間をおいて再度登録をお願いします。';
      });
    }

    // Navigator.pushReplacementNamed(context, TodoListPage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('register'),
      ),
      body: Form(
        key: _form,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'email',
                hintText: 'test@example.com',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please provide a value';
                }
                return null;
              },
              onChanged: (value) {
                _inputEmail = value;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please provide a value';
                }
                return null;
              },
              onChanged: (value) {
                _inputPassword = value;
              },
            ),
            const Padding(padding: EdgeInsets.all(5)),
            ElevatedButton(
              onPressed: onPressedRegisterButton,
              child: const Text('register'),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Text(
              _errorText,
              style: const TextStyle(color: Colors.red),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextButton(
              child: const Text('ログインはこちら'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginPage.path);
              },
            )
          ],
        ),
      ),
    );
  }
}
