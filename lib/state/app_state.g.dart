// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppState on _AppState, Store {
  Computed<ObservableList<Entry>>? _$sortedEntriesComputed;

  @override
  ObservableList<Entry> get sortedEntries => (_$sortedEntriesComputed ??=
          Computed<ObservableList<Entry>>(() => super.sortedEntries,
              name: '_AppState.sortedEntries'))
      .value;

  late final _$currentScreenAtom =
      Atom(name: '_AppState.currentScreen', context: context);

  @override
  AppScreen get currentScreen {
    _$currentScreenAtom.reportRead();
    return super.currentScreen;
  }

  @override
  set currentScreen(AppScreen value) {
    _$currentScreenAtom.reportWrite(value, super.currentScreen, () {
      super.currentScreen = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AppState.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$authErrorAtom =
      Atom(name: '_AppState.authError', context: context);

  @override
  AuthError? get authError {
    _$authErrorAtom.reportRead();
    return super.authError;
  }

  @override
  set authError(AuthError? value) {
    _$authErrorAtom.reportWrite(value, super.authError, () {
      super.authError = value;
    });
  }

  late final _$entriesAtom = Atom(name: '_AppState.entries', context: context);

  @override
  ObservableList<Entry> get entries {
    _$entriesAtom.reportRead();
    return super.entries;
  }

  @override
  set entries(ObservableList<Entry> value) {
    _$entriesAtom.reportWrite(value, super.entries, () {
      super.entries = value;
    });
  }

  late final _$deleteAsyncAction =
      AsyncAction('_AppState.delete', context: context);

  @override
  Future<bool> delete(Entry entry) {
    return _$deleteAsyncAction.run(() => super.delete(entry));
  }

  late final _$deleteAccountAsyncAction =
      AsyncAction('_AppState.deleteAccount', context: context);

  @override
  Future<bool> deleteAccount() {
    return _$deleteAccountAsyncAction.run(() => super.deleteAccount());
  }

  late final _$logOutAsyncAction =
      AsyncAction('_AppState.logOut', context: context);

  @override
  Future<void> logOut() {
    return _$logOutAsyncAction.run(() => super.logOut());
  }

  late final _$createEntryAsyncAction =
      AsyncAction('_AppState.createEntry', context: context);

  @override
  Future<bool> createEntry(String text) {
    return _$createEntryAsyncAction.run(() => super.createEntry(text));
  }

  late final _$modifyEntriesAsyncAction =
      AsyncAction('_AppState.modifyEntries', context: context);

  @override
  Future<bool> modifyEntries({required String entryId, required bool isDone}) {
    return _$modifyEntriesAsyncAction
        .run(() => super.modifyEntries(entryId: entryId, isDone: isDone));
  }

  late final _$initializeAsyncAction =
      AsyncAction('_AppState.initialize', context: context);

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$_loadEntriesAsyncAction =
      AsyncAction('_AppState._loadEntries', context: context);

  @override
  Future<bool> _loadEntries() {
    return _$_loadEntriesAsyncAction.run(() => super._loadEntries());
  }

  late final _$_registerOrLoginAsyncAction =
      AsyncAction('_AppState._registerOrLogin', context: context);

  @override
  Future<bool> _registerOrLogin(
      {required LoginOrRegisterFunction fn,
      required String email,
      required String password}) {
    return _$_registerOrLoginAsyncAction.run(
        () => super._registerOrLogin(fn: fn, email: email, password: password));
  }

  late final _$uploadAsyncAction =
      AsyncAction('_AppState.upload', context: context);

  @override
  Future<bool> upload({required String filePath, required String forEntryId}) {
    return _$uploadAsyncAction
        .run(() => super.upload(filePath: filePath, forEntryId: forEntryId));
  }

  late final _$_AppStateActionController =
      ActionController(name: '_AppState', context: context);

  @override
  void goTo(AppScreen screen) {
    final _$actionInfo =
        _$_AppStateActionController.startAction(name: '_AppState.goTo');
    try {
      return super.goTo(screen);
    } finally {
      _$_AppStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<bool> register({required String email, required String password}) {
    final _$actionInfo =
        _$_AppStateActionController.startAction(name: '_AppState.register');
    try {
      return super.register(email: email, password: password);
    } finally {
      _$_AppStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<bool> login({required String email, required String password}) {
    final _$actionInfo =
        _$_AppStateActionController.startAction(name: '_AppState.login');
    try {
      return super.login(email: email, password: password);
    } finally {
      _$_AppStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentScreen: ${currentScreen},
isLoading: ${isLoading},
authError: ${authError},
entries: ${entries},
sortedEntries: ${sortedEntries}
    ''';
  }
}
