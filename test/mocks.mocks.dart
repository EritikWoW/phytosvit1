// Mocks generated by Mockito 5.4.4 from annotations
// in phytosvit/test/mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;

import 'package:mockito/mockito.dart' as _i1;
import 'package:phytosvit/database/doc_type_dao.dart' as _i5;
import 'package:phytosvit/database/subdivision_dao.dart' as _i6;
import 'package:phytosvit/database/unit_dao.dart' as _i4;
import 'package:phytosvit/database/user_dao.dart' as _i2;
import 'package:phytosvit/models/user.dart' as _i9;
import 'package:phytosvit/services/doc_type_sync_service.dart' as _i11;
import 'package:phytosvit/services/settings_service.dart' as _i3;
import 'package:phytosvit/services/subdivision_sync_service.dart' as _i12;
import 'package:phytosvit/services/unit_sync_service.dart' as _i10;
import 'package:phytosvit/services/user_sync_service.dart' as _i7;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeUserDao_0 extends _i1.SmartFake implements _i2.UserDao {
  _FakeUserDao_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSettingsService_1 extends _i1.SmartFake
    implements _i3.SettingsService {
  _FakeSettingsService_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUnitDao_2 extends _i1.SmartFake implements _i4.UnitDao {
  _FakeUnitDao_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDocTypeDao_3 extends _i1.SmartFake implements _i5.DocTypeDao {
  _FakeDocTypeDao_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSubdivisionDao_4 extends _i1.SmartFake
    implements _i6.SubdivisionDao {
  _FakeSubdivisionDao_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [UserSyncService].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserSyncService extends _i1.Mock implements _i7.UserSyncService {
  MockUserSyncService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserDao get userDao => (super.noSuchMethod(
        Invocation.getter(#userDao),
        returnValue: _FakeUserDao_0(
          this,
          Invocation.getter(#userDao),
        ),
      ) as _i2.UserDao);

  @override
  _i3.SettingsService get settingsService => (super.noSuchMethod(
        Invocation.getter(#settingsService),
        returnValue: _FakeSettingsService_1(
          this,
          Invocation.getter(#settingsService),
        ),
      ) as _i3.SettingsService);

  @override
  _i8.Future<bool> isServerAvailable() => (super.noSuchMethod(
        Invocation.method(
          #isServerAvailable,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);

  @override
  _i8.Future<void> syncUsers() => (super.noSuchMethod(
        Invocation.method(
          #syncUsers,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<_i9.User?> getUserByEmail(String? email) => (super.noSuchMethod(
        Invocation.method(
          #getUserByEmail,
          [email],
        ),
        returnValue: _i8.Future<_i9.User?>.value(),
      ) as _i8.Future<_i9.User?>);
}

/// A class which mocks [UnitSyncService].
///
/// See the documentation for Mockito's code generation for more information.
class MockUnitSyncService extends _i1.Mock implements _i10.UnitSyncService {
  MockUnitSyncService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.UnitDao get unitDao => (super.noSuchMethod(
        Invocation.getter(#unitDao),
        returnValue: _FakeUnitDao_2(
          this,
          Invocation.getter(#unitDao),
        ),
      ) as _i4.UnitDao);

  @override
  _i8.Future<bool> isServerAvailable() => (super.noSuchMethod(
        Invocation.method(
          #isServerAvailable,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);

  @override
  _i8.Future<void> syncUnits() => (super.noSuchMethod(
        Invocation.method(
          #syncUnits,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}

/// A class which mocks [DocTypeSyncService].
///
/// See the documentation for Mockito's code generation for more information.
class MockDocTypeSyncService extends _i1.Mock
    implements _i11.DocTypeSyncService {
  MockDocTypeSyncService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.DocTypeDao get docTypeDao => (super.noSuchMethod(
        Invocation.getter(#docTypeDao),
        returnValue: _FakeDocTypeDao_3(
          this,
          Invocation.getter(#docTypeDao),
        ),
      ) as _i5.DocTypeDao);

  @override
  _i8.Future<bool> isServerAvailable() => (super.noSuchMethod(
        Invocation.method(
          #isServerAvailable,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);

  @override
  _i8.Future<void> syncDocTypes() => (super.noSuchMethod(
        Invocation.method(
          #syncDocTypes,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}

/// A class which mocks [SubdivisionSyncService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSubdivisionSyncService extends _i1.Mock
    implements _i12.SubdivisionSyncService {
  MockSubdivisionSyncService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.SubdivisionDao get subdivisionDao => (super.noSuchMethod(
        Invocation.getter(#subdivisionDao),
        returnValue: _FakeSubdivisionDao_4(
          this,
          Invocation.getter(#subdivisionDao),
        ),
      ) as _i6.SubdivisionDao);

  @override
  _i8.Future<bool> isServerAvailable() => (super.noSuchMethod(
        Invocation.method(
          #isServerAvailable,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);

  @override
  _i8.Future<void> syncSubdivisions() => (super.noSuchMethod(
        Invocation.method(
          #syncSubdivisions,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}
