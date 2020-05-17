import 'dart:async';

import 'package:graphql/client.dart';
import 'package:hive/hive.dart';
import 'package:lifelog/auth/models/auth_models.dart';
import 'package:meta/meta.dart';

import '../constants.dart';

class UserRepository {
  final Box _store;

  const UserRepository(Box store) : _store = store;

  static FutureOr<UserRepository> openRepository() async {
    var box = await Hive.openBox('tokens');
    return UserRepository(box);
  }

  Future<AuthResult> authenticate({
    @required String uri,
    @required String username,
    @required String password,
  }) async {
    final httpLink = HttpLink(uri: uri);

    final client = GraphQLClient(
      cache: OptimisticCache(
        dataIdFromObject: typenameDataIdFromObject,
      ),
      link: httpLink,
    );

    final _options = MutationOptions(documentNode: gql('''
mutation LoginUser {
  login(input: { email: "$username", password: "$password" }) {
    authToken {
      accessToken
      expiredAt
    }
    user {
      id
      username
      email
      createdAt
      updatedAt
    }
  }
}
'''));

    var res = await client.mutate(_options);

    if (res.hasException) {
      return AuthResult(
        null,
        null,
        error: true,
        errorMessages:
            res.exception.graphqlErrors.map((e) => e.message).toList(),
      );
    } else {
      return AuthResult(
        AuthToken.fromJson(res.data['login']['authToken']),
        User.fromJson(res.data['login']['user']),
      );
    }
  }

  Future<void> deleteToken() async {
    await _store.delete(prefKeyJWTToken);
    return;
  }

  Future<void> persistToken(AuthResult token) async {
    await _store.put(prefKeyJWTToken, token.jwtToken.accessToken);
    await _store.put(prefKeyJWTToken, token.jwtToken.expiredAt);
  }

  Future<bool> hasToken() async {
    String token = await _store.get(prefKeyJWTToken, defaultValue: '');
    if (token == null || token.isEmpty) return false;
    return true;
  }
}
