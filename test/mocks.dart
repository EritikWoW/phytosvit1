// test/mocks.dart
import 'package:mockito/annotations.dart';
import 'package:phytosvit/services/user_sync_service.dart';
import 'package:phytosvit/services/unit_sync_service.dart';
import 'package:phytosvit/services/doc_type_sync_service.dart';
import 'package:phytosvit/services/subdivision_sync_service.dart';

// Аннотации, чтобы mockito мог сгенерировать mock-классы
@GenerateMocks([
  UserSyncService,
  UnitSyncService,
  DocTypeSyncService,
  SubdivisionSyncService,
])
void main() {
  // пустой main, генерация происходит через build_runner
}
