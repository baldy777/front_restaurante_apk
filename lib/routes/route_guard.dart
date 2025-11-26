import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleGuard extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;

  const RoleGuard({super.key, required this.child, required this.allowedRoles});

  Future<bool> _hasAccess() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    return allowedRoles.contains(role);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _hasAccess(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return child;
        }

        return const Scaffold(
          body: Center(
            child: Text(
              "No tienes permiso para acceder a esta vista",
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }
}
