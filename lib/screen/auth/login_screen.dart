import 'package:dtube/models/auth/login_bridge_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isLoading = false;
  static const platform = MethodChannel('com.sagar.dtube/auth');
  var username = '';
  var key = '';

  // Create storage
  // final storage = new FlutterSecureStorage();

  void onLoginTapped() async {
    setState(() {
      isLoading = true;
    });
    try {
      final String result = await platform.invokeMethod('validate', {
        'username': username,
        'key': key,
      });
      var response = LoginBridgeResponse.fromJsonString(result);
      if (response.valid && response.error.isEmpty) {
        debugPrint("Successful login");
      } else {
        showError(response.error);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('Error occurred - ${e.toString()}');
    }
  }

  void showError(String string) {
    var snackBar = SnackBar(content: Text('Error: $string'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _loginForm() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              label: Text('DTube Username'),
              hintText: 'DTube username here',
            ),
            autocorrect: false,
            onChanged: (value) {
              setState(() {
                username = value;
              });
            },
            enabled: isLoading ? false : true,
          ),
          const SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.key),
              label: Text('DTube Private Key'),
              hintText: 'Copy & paste key here',
            ),
            onChanged: (value) {
              setState(() {
                key = value;
              });
            },
            enabled: isLoading ? false : true,
          ),
          const SizedBox(height: 20),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: onLoginTapped,
                  child: const Text('Log in'),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: _loginForm(),
    );
  }
}
