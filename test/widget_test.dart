import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

ApiClient _testApiClient({int loginStatusCode = 200}) {
  return ApiClient(
    baseUrl: 'https://api.example.test',
    client: MockClient((request) async {
      if (request.url.path == '/api/v1/auth/token/') {
        if (loginStatusCode != 200) {
          return http.Response('Invalid credentials', loginStatusCode);
        }
        return http.Response('{"token":"test-token"}', 200);
      }
      if (request.url.path == '/api/v1/auth/logout/') {
        return http.Response('', 204);
      }
      if (request.url.path == '/api/v1/projects/' && request.method == 'GET') {
        return http.Response(
          jsonEncode([
            {
              'id': 'project-1',
              'title': 'Portfolio',
              'description': 'A portfolio project',
              'tech_stack': 'Flutter, Django',
              'project_url': 'https://example.com',
              'project_image_url': '',
            },
          ]),
          200,
        );
      }
      if (request.url.path == '/api/v1/projects/' && request.method == 'POST') {
        final project = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            ...project,
            'id': 'project-2',
            'star_count': 0,
            'is_starred': false,
            'starred_by_names': '',
          }),
          201,
        );
      }
      return http.Response('Not found', 404);
    }),
  );
}

Future<void> _pumpTestApp(
  WidgetTester tester, {
  int loginStatusCode = 200,
}) async {
  await tester.pumpWidget(
    MyApp(apiClient: _testApiClient(loginStatusCode: loginStatusCode)),
  );
}

void main() {
  testWidgets('MyPortfolio renders its profile and menu', (tester) async {
    await _pumpTestApp(tester);

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('2506622494'), findsOneWidget);
    expect(find.text('Joel Sheldy S'), findsOneWidget);
    expect(find.text('PBP A'), findsOneWidget);
    expect(find.text('Lihat Proyek'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);
    expect(find.text('Tambah Pendidikan'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('add-project action opens the validated project form', (
    tester,
  ) async {
    await _pumpTestApp(tester);

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsNWidgets(2));
    await tester.enterText(find.byType(TextFormField).at(0), 'owner');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Title cannot be empty!'), findsOneWidget);
    expect(find.text('Description cannot be empty!'), findsOneWidget);
    expect(find.text('Tech stack cannot be empty!'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Portfolio');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'A personal portfolio app',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'Flutter');
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'https://example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).at(4),
      'https://example.com/image.png',
    );
    tester.binding.focusManager.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Project created'), findsOneWidget);
    expect(find.text('Title: Portfolio'), findsOneWidget);
    expect(find.text('Description: A personal portfolio app'), findsOneWidget);
    expect(find.text('Tech stack: Flutter'), findsOneWidget);
    expect(find.text('Project URL: https://example.com'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller!
          .text,
      isEmpty,
    );
  });

  testWidgets('education card validates input and shows a summary', (
    tester,
  ) async {
    await _pumpTestApp(tester);

    await tester.ensureVisible(find.text('Tambah Pendidikan'));
    await tester.tap(find.text('Tambah Pendidikan'));
    await tester.pumpAndSettle();

    expect(find.text('Add Education Form'), findsOneWidget);

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Institusi wajib diisi.'), findsOneWidget);
    expect(find.text('Gelar wajib diisi.'), findsOneWidget);
    expect(find.text('Bidang studi wajib diisi.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), '   ');
    await tester.enterText(find.byType(TextFormField).at(1), 'S1');
    await tester.enterText(find.byType(TextFormField).at(2), 'Ilmu Komputer');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Institusi wajib diisi.'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Universitas Indonesia',
    );
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Pendidikan berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Institusi: Universitas Indonesia'), findsOneWidget);
    expect(find.text('Gelar: S1'), findsOneWidget);
    expect(find.text('Bidang Studi: Ilmu Komputer'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Add Education Form'), findsOneWidget);
  });

  testWidgets('education drawer route opens form and Home returns to main', (
    tester,
  ) async {
    await _pumpTestApp(tester);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project'), findsOneWidget);
    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();

    expect(find.text('Add Education Form'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Add Education Form'), findsNothing);
  });

  testWidgets('project list displays API data and opens project details', (
    tester,
  ) async {
    await _pumpTestApp(tester);

    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();

    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('Portfolio'), findsOneWidget);
    expect(find.textContaining('Flutter, Django'), findsOneWidget);

    await tester.tap(find.text('Portfolio'));
    await tester.pumpAndSettle();

    expect(find.text('A portfolio project'), findsOneWidget);
    expect(find.text('Project URL: https://example.com'), findsOneWidget);
  });

  testWidgets('drawer Add Project requires login before opening the form', (
    tester,
  ) async {
    await _pumpTestApp(tester);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsNWidgets(2));
    expect(find.text('Add Project Form'), findsNothing);

    await tester.enterText(find.byType(TextFormField).at(0), 'owner');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);
  });

  testWidgets('invalid login displays the API status and stays on login', (
    tester,
  ) async {
    await _pumpTestApp(tester, loginStatusCode: 400);

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'owner');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong');
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Login failed (HTTP 400).'), findsOneWidget);
    expect(find.text('Login'), findsNWidgets(2));
    expect(find.text('Add Project Form'), findsNothing);
  });
}
