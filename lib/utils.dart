import 'package:permission_handler/permission_handler.dart';

Future<bool> checkWithRequestPermission(PermissionGroup pg) async =>
    (await PermissionHandler().requestPermissions([pg]))[pg] ==
    PermissionStatus.granted;

Future<bool> checkPermission(PermissionGroup pg) async => (await PermissionHandler().checkPermissionStatus(pg)) == PermissionStatus.granted;