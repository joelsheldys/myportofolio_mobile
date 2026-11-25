import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    super.key,
    this.onHome,
    this.onAddProject,
    this.onAddEducation,
  });

  final VoidCallback? onHome;
  final VoidCallback? onAddProject;
  final VoidCallback? onAddEducation;

  Future<void> _openProjectForm(BuildContext context) async {
    if (!await ensureLoggedIn(context) || !context.mounted) return;
    if (onAddProject != null) {
      onAddProject!();
      return;
    }
    final navigator = Navigator.of(context);
    navigator.pop();
    await navigator.push(
      MaterialPageRoute<void>(builder: (context) => const ProjectFormPage()),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final authState = context.read<AuthState>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      await authState.logout();
      if (!context.mounted) return;
      Navigator.pop(context);
      messenger.showSnackBar(
        const SnackBar(content: Text('You have been logged out.')),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Logged out locally, but server logout failed '
            '(HTTP ${error.statusCode}).',
          ),
        ),
      );
    } on http.ClientException {
      if (!context.mounted) return;
      Navigator.pop(context);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Logged out locally; could not reach the server.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Portfolio',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore personal projects and experiences!',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap:
                onHome ??
                () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () => _openProjectForm(context),
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Add Education'),
            onTap:
                onAddEducation ??
                () {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  navigator.push(
                    MaterialPageRoute<void>(
                      builder: (context) => const EducationFormPage(),
                    ),
                  );
                },
          ),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            )
          else
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                final navigator = Navigator.of(context);
                navigator.pop();
                navigator.push(
                  MaterialPageRoute<bool>(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
