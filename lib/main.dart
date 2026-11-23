import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          secondary: Colors.amber[700],
        ),
        useMaterial3: true,
      ),
      home: const Tutorial9HomePage(),
    );
  }
}

class Tutorial9HomePage extends StatelessWidget {
  const Tutorial9HomePage({super.key});

  void _openProjectForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const ProjectFormPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      ItemHomepage('Lihat Proyek', Icons.folder, Colors.blue),
      ItemHomepage('Tambah Proyek', Icons.add_circle, Colors.green),
      ItemHomepage('Logout', Icons.logout, Colors.red),
      ItemHomepage('Tambah Pendidikan', Icons.school, Colors.deepPurple),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(
        onHome: () => Navigator.pop(context),
        onAddProject: () {
          Navigator.pop(context);
          _openProjectForm(context);
        },
        onAddEducation: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => const EducationFormPage(),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: '2506622494'),
                InfoCard(title: 'Name', content: 'Joel Sheldy S'),
                InfoCard(title: 'Class', content: 'PBP A'),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Selamat datang di MyPortfolio Mobile!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            GridView.count(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: items.map((item) => ItemCard(item)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
