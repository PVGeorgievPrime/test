// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'login_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class LoginBlocType extends RxBlocTypeBase {
  LoginBlocEvents get events;
  LoginBlocStates get states;
}

/// [$LoginBloc] extended by the [LoginBloc]
/// @nodoc
abstract class $LoginBloc extends RxBlocBase
    implements LoginBlocEvents, LoginBlocStates, LoginBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [setEmail]
  final _$setEmailEvent = BehaviorSubject<String>.seeded('');

  /// Тhe [Subject] where events sink to by calling [setPassword]
  final _$setPasswordEvent = BehaviorSubject<String>.seeded('');

  /// Тhe [Subject] where events sink to by calling [login]
  final _$loginEvent = PublishSubject<void>();

  /// The state of [email] implemented in [_mapToEmailState]
  late final Stream<String> _emailState = _mapToEmailState();

  /// The state of [password] implemented in [_mapToPasswordState]
  late final Stream<String> _passwordState = _mapToPasswordState();

  /// The state of [loggedIn] implemented in [_mapToLoggedInState]
  late final ConnectableStream<bool> _loggedInState = _mapToLoggedInState();

  /// The state of [showErrors] implemented in [_mapToShowErrorsState]
  late final Stream<bool> _showErrorsState = _mapToShowErrorsState();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

  @override
  void setEmail(String email) => _$setEmailEvent.add(email);

  @override
  void setPassword(String password) => _$setPasswordEvent.add(password);

  @override
  void login() => _$loginEvent.add(null);

  @override
  Stream<String> get email => _emailState;

  @override
  Stream<String> get password => _passwordState;

  @override
  ConnectableStream<bool> get loggedIn => _loggedInState;

  @override
  Stream<bool> get showErrors => _showErrorsState;

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<ErrorModel> get errors => _errorsState;

  Stream<String> _mapToEmailState();

  Stream<String> _mapToPasswordState();

  ConnectableStream<bool> _mapToLoggedInState();

  Stream<bool> _mapToShowErrorsState();

  Stream<bool> _mapToIsLoadingState();

  Stream<ErrorModel> _mapToErrorsState();

  @override
  LoginBlocEvents get events => this;

  @override
  LoginBlocStates get states => this;

  @override
  void dispose() {
    _$setEmailEvent.close();
    _$setPasswordEvent.close();
    _$loginEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
