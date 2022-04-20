import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

typedef FutureCallback = Future Function();

/// Class for handling contact permissions.
class PermissionsManager {
  /// ask for permission
  /// [grantCallback] to perform a call back when permission is granted
  Future<bool> askPermissions(
      {FutureCallback? grantCallback,
      required BuildContext context}) async {
    PermissionStatus permissionStatus = await getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      await grantCallback?.call();
    } else {
      handleInvalidPermissions(
          permissionStatus: permissionStatus, context: context);
    }
    return true;
  }

  /// Retrieves the contact permission status
  Future<PermissionStatus> getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  /// Handles [PermissionStatus] when it is denied by showing a snackbar.
  void handleInvalidPermissions(
      {required PermissionStatus permissionStatus,
      required BuildContext context}) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
