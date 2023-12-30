import 'package:dio/dio.dart';

class GithubRepository {
  final String repo;
  late String _api;
  GithubRepository(this.repo) {
    _api = "https://api.github.com/repos/$repo";
  }

  Future<String?> version() async {
    var client = Dio();
    var resp = await client.get("$_api/releases");
    List data = resp.data;
    // TODO Finish here when after publish
    if (data.isEmpty) {
      return null;
    }
    return data[0];
  }
}
