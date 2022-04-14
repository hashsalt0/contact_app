import 'package:contact_app/src/repo/contact_repository.dart';
import 'package:logger/logger.dart';

class ServiceLocator {
  final contactsRepository = ContactsRepository();
  final logger = Logger();

  ServiceLocator._();

  static ServiceLocator? _instance;

  static ServiceLocator get instance {
     _instance ??= ServiceLocator._();
     return _instance!;
  }

}