import 'package:contact_app/src/repo/contact_repository.dart';
import 'package:logger/logger.dart';

import 'utils/permissions_manager.dart';

/// Dependency injection using service locator pattern
class ServiceLocator {
  final contactsRepository = ContactsRepository();
  final logger = Logger();
  final permissionsManager = PermissionsManager();

  ServiceLocator._();

  static ServiceLocator? _instance;

  static ServiceLocator get instance {
    /// instantiating instance if it is null
    _instance ??= ServiceLocator._();
    return _instance!;
  }
}