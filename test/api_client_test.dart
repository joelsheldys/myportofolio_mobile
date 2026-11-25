import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  test(
    'project JSON uses API field names and ignores server-only id on POST',
    () {
      final project = Project(
        id: 'server-id',
        title: 'Portfolio',
        description: 'Mobile app',
        techStack: 'Flutter',
        projectUrl: 'https://example.com',
      );

      expect(project.toJson(), {
        'title': 'Portfolio',
        'description': 'Mobile app',
        'tech_stack': 'Flutter',
        'project_url': 'https://example.com',
        'project_image_url': '',
      });

      final fromJson = Project.fromJson({
        'id': 'server-id',
        'title': 'Portfolio',
        'description': 'Mobile app',
        'tech_stack': 'Flutter',
        'project_url': 'https://example.com',
        'project_image_url': null,
      });
      expect(fromJson.id, 'server-id');
      expect(fromJson.projectImageUrl, isEmpty);
    },
  );

  test(
    'ApiClient sends project and token requests with expected headers',
    () async {
      final client = ApiClient(
        baseUrl: 'https://api.example.test/',
        client: MockClient((request) async {
          expect(request.url.origin, 'https://api.example.test');
          if (request.url.path == '/api/v1/auth/token/') {
            expect(request.method, 'POST');
            expect(
              request.headers['Content-Type'],
              'application/json; charset=UTF-8',
            );
            expect(jsonDecode(request.body), {
              'username': 'owner',
              'password': 'secret',
            });
            return http.Response('{"token":"abc123"}', 200);
          }
          if (request.url.path == '/api/v1/projects/' &&
              request.method == 'POST') {
            expect(request.headers['Authorization'], 'Token abc123');
            expect(request.headers['Accept'], 'application/json');
            expect(
              request.headers['Content-Type'],
              'application/json; charset=UTF-8',
            );
            final body = jsonDecode(request.body) as Map<String, dynamic>;
            expect(body.containsKey('id'), isFalse);
            expect(body['tech_stack'], 'Flutter');
            return http.Response(
              jsonEncode({
                ...body,
                'id': 'server-id',
                'star_count': 0,
                'is_starred': false,
                'starred_by_names': '',
              }),
              201,
            );
          }
          if (request.url.path == '/api/v1/auth/logout/') {
            expect(request.method, 'POST');
            expect(request.headers['Authorization'], 'Token abc123');
            return http.Response('', 204);
          }
          return http.Response('Not found', 404);
        }),
      );
      addTearDown(client.close);

      final token = await client.obtainToken('owner', 'secret');
      expect(token, 'abc123');

      final project = await client.createProject(
        const Project(
          title: 'Portfolio',
          description: 'Mobile app',
          techStack: 'Flutter',
          projectUrl: 'https://example.com',
        ),
        token: token,
      );
      expect(project.id, 'server-id');
      await client.logout(token: token);
    },
  );

  test('ApiClient reports non-success HTTP responses', () async {
    final client = ApiClient(
      baseUrl: 'https://api.example.test',
      client: MockClient((request) async => http.Response('Denied', 401)),
    );
    addTearDown(client.close);

    await expectLater(
      client.obtainToken('owner', 'wrong'),
      throwsA(
        isA<ApiException>()
            .having((error) => error.statusCode, 'statusCode', 401)
            .having((error) => error.message, 'message', 'Denied'),
      ),
    );
  });
}
