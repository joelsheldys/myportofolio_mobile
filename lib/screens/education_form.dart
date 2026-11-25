import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _degreeController = TextEditingController();
  final _fieldOfStudyController = TextEditingController();

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _fieldOfStudyController.dispose();
    super.dispose();
  }

  String? _validateRequiredText(String? value, String label, int maxLength) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return '$label wajib diisi.';
    }
    if (trimmedValue.length > maxLength) {
      return '$label maksimal $maxLength karakter.';
    }
    return null;
  }

  Future<void> _saveEducation() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final institution = _institutionController.text.trim();
    final degree = _degreeController.text.trim();
    final fieldOfStudy = _fieldOfStudyController.text.trim();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pendidikan berhasil ditambahkan!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Institusi: $institution'),
            Text('Gelar: $degree'),
            Text('Bidang Studi: $fieldOfStudy'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openProjectForm() {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const ProjectFormPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Education Form'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(
        onHome: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        onAddProject: _openProjectForm,
        onAddEducation: () => Navigator.pop(context),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _institutionController,
                maxLength: 120,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Institusi',
                  hintText: 'Contoh: Universitas Indonesia',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    _validateRequiredText(value, 'Institusi', 120),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _degreeController,
                maxLength: 100,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Gelar',
                  hintText: 'Contoh: Sarjana Komputer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    _validateRequiredText(value, 'Gelar', 100),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fieldOfStudyController,
                maxLength: 100,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Bidang Studi',
                  hintText: 'Contoh: Ilmu Komputer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    _validateRequiredText(value, 'Bidang studi', 100),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveEducation,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
