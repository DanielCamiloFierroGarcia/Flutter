import 'package:myproject/services/auth/auth_exceptions.dart';
import 'package:myproject/services/auth/auth_provider.dart';
import 'package:myproject/services/auth/auth_user.dart';
import 'package:test/test.dart';
//ninguno funciono
void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should no be initialized to begin with', (){
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', (){
      expect(provider.logOut(), throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to be initialized', ()async{
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', (){
      expect(provider.currentUser, null);
    });

    test('Should be able to initialize in less than 2 seconds', () async{
      await provider.initialize();
      expect(provider.isInitialized, true);
    },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to login function', (){
      final badEmailuser = provider.createUser(email: 'example@ex.com', password: 'password');
      expect(badEmailuser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      
      final badPasswordUser = provider.createUser(email: 'someaone@gmail.com', password: 'example');
      expect(badPasswordUser, throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = provider.createUser(email: 'xd', password: 'equisde');
      expect(provider.currentUser, user);
      //expect(user., false);
    });

    test('Login should be able to get verified', (){
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to logout and login again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });

  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  AuthUser? _user;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async{
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if(email == 'example@ex.com') throw UserNotFoundAuthException();
    if(password == 'example') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: 'dfierro192@gmail.com', id: "xdxdxxd");
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async{
    if (!isInitialized) throw NotInitializedException();
    if(_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async{
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if(user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: 'dfierro192@gmail.com', id: "xdxdxdxd");
    _user = newUser;
  }
}
