import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _passwordController = TextEditingController();
  bool _changing = false;
  String? _message;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    try {
      await AuthService.instance.changePassword(_passwordController.text);

      setState(() {
        _message = 'Password updated successfully';
      });

      _passwordController.clear();
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
      });
    }
  }

  Future<void> _logout() async {
    await AuthService.instance.signOut();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthenticationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFF3E5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logged in as:',
              style: TextStyle(fontSize: 18, color: Colors.deepPurple.shade700),
            ),
            Text(
              user?.email ?? "Unknown",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 132, 214, 249),
              ),
            ),

            const SizedBox(height: 20),

            if (_message != null)
              Text(
                _message!,
                style: TextStyle(
                  color: _message!.startsWith('Error')
                      ? Colors.red
                      : Colors.green,
                ),
              ),

            ListTile(
              title: const Text('Change Password'),
              trailing: Icon(
                _changing ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.deepPurple,
              ),
              onTap: () {
                setState(() {
                  _changing = !_changing;
                });
              },
            ),

            if (_changing)
              Column(
                children: [
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 144, 234, 255),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _updatePassword,
                    child: const Text('Update Password'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
