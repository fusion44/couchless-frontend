import 'dart:async';

import 'package:graphql/client.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../constants.dart';
import 'models/auth_models.dart';

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

    final _options = _getAuthMutationOptions(username, password);

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

  Future<void> deleteUserData() async {
    await _store.deleteAll([
      prefKeyUrl,
      prefKeyJWTToken,
      prefKeyJWTExpiry,
      prefKeyUserId,
      prefKeyUsername,
      prefKeyUserEmail,
      prefKeyUserCreatedAt,
      prefKeyUserUpdatedAt,
    ]);

    return;
  }

  Future<void> persistUserData(String uri, AuthResult token) async {
    await _store.put(prefKeyUrl, uri);
    await _store.put(prefKeyJWTToken, token.jwtToken.accessToken);
    await _store.put(prefKeyJWTExpiry, token.jwtToken.expiredAt);
    await _store.put(prefKeyUserId, token.user.id);
    await _store.put(prefKeyUsername, token.user.username);
    await _store.put(prefKeyUserEmail, token.user.email);
    await _store.put(prefKeyUserCreatedAt, token.user.createdAt);
    await _store.put(prefKeyUserUpdatedAt, token.user.updatedAt);
  }

  Future<User> getUser() async {
    return User(
      id: await _store.get(prefKeyUserId),
      username: await _store.get(prefKeyUsername),
      email: await _store.get(prefKeyUserEmail),
      createdAt: await _store.get(prefKeyUserCreatedAt),
      updatedAt: await _store.get(prefKeyUserUpdatedAt),
    );
  }

  Future<bool> hasToken() async {
    String token = await _store.get(prefKeyJWTToken, defaultValue: '');
    if (token == null || token.isEmpty) return false;
    return true;
  }

  MutationOptions _getAuthMutationOptions(String username, String password) {
    return MutationOptions(documentNode: gql('''
mutation LoginUser {
  login(input: { username: "$username", password: "$password" }) {
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
  }
}
