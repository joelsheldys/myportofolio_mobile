import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final imageUrl = project.projectImageUrl.trim();
    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
          Text(project.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text('Tech stack: ${project.techStack}'),
          const SizedBox(height: 12),
          Text(project.description),
          if (project.projectUrl.isNotEmpty) ...[
            const SizedBox(height: 12),
            SelectableText('Project URL: ${project.projectUrl}'),
          ],
        ],
      ),
    );
  }
}
