import 'package:material_ui/material_ui.dart';
import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  Future<void> _onTap(BuildContext context) async {
    if (item.name == 'Lihat Proyek') {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const ProjectListScreen(),
        ),
      );
      return;
    }

    if (item.name == 'Tambah Proyek') {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (!await ensureLoggedIn(context) || !context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (context) => const ProjectFormPage()),
      );
      return;
    }

    if (item.name == 'Tambah Pendidikan') {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const EducationFormPage(),
        ),
      );
      return;
    }

    if (item.name == 'Logout') {
      if (!context.read<AuthState>().isLoggedIn) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('You are not logged in.')));
        return;
      }
      try {
        await context.read<AuthState>().logout();
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have been logged out.')),
        );
      } on ApiException catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Logged out locally, but server logout failed '
              '(HTTP ${error.statusCode}).',
            ),
          ),
        );
      } on http.ClientException {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out locally; could not reach the server.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Kamu telah menekan tombol ${item.name}!'),
              ),
            );
          await _onTap(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
