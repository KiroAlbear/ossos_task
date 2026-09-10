import 'package:geolocator/geolocator.dart' as geoLoc;
import 'package:location/location.dart' as loca;
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:ossos_task/core/models/enums.dart';
import 'package:ossos_task/imports.dart';

class RequestPermissionManager {
  /// Permission type to request permission from user
  PermissionType? _permissionType;

  /// callback when permission is denied by user
  Function()? _onPermissionDenied;

  /// callback when permission is granted by user
  Function()? _onPermissionGranted;

  /// callback when permission is permanently denied by user
  Function()? _onPermissionPermanentlyDenied;

  /// Check a [permission] and return a [Future] with the result
  RequestPermissionManager(PermissionType permissionType) {
    _permissionType = permissionType;
  }
  var locaa = loca.Location();

  /// Request a [permission] , onPermissionDenied method to handle when permission is denied
  RequestPermissionManager onPermissionDenied(Function()? onPermissionDenied) {
    _onPermissionDenied = onPermissionDenied;
    return this;
  }

  ///  Request a [permission] ,onPermissionGranted method to handle when permission is granted
  RequestPermissionManager onPermissionGranted(
    Function()? onPermissionGranted,
  ) {
    _onPermissionGranted = onPermissionGranted;

    return this;
  }

  ///  Request a [permission] ,onPermissionPermanentlyDenied method to handle when permission is permanently denied
  RequestPermissionManager onPermissionPermanentlyDenied(
    Function()? onPermissionPermanentlyDenied,
  ) {
    _onPermissionPermanentlyDenied = onPermissionPermanentlyDenied;

    return this;
  }

  /// get Permission from PermissionType enum value
  perm.Permission _getPermissionFromType(PermissionType permissionType) {
    switch (permissionType) {
      case PermissionType.camera:
        return perm.Permission.camera;
      case PermissionType.storage:
        return perm.Permission.storage;
      case PermissionType.recordAudio:
        return perm.Permission.microphone;
      case PermissionType.writeContacts:
        return perm.Permission.contacts;
      case PermissionType.readContacts:
        return perm.Permission.contacts;
      case PermissionType.whenInUseLocation:
        return perm.Permission.locationWhenInUse;
      case PermissionType.alwaysLocation:
        return perm.Permission.locationAlways;
      case PermissionType.notification:
        return perm.Permission.notification;
      case PermissionType.photos:
        return perm.Permission.photos;
      case PermissionType.location:
        return perm.Permission.location;
      default:
        throw Exception('Invalid permission type');
    }
  }

  /// execute request permission
  /// gets permission from PermissionType enum value and request permission
  /// handle permission status and call callback function
  /// if permission is granted, call onPermissionGranted callback
  /// if permission is denied, call onPermissionDenied callback
  /// if permission is permanently denied, call onPermissionPermanentlyDenied callback
  Future<void> execute(PermissionType permissionType) async {
    if (permissionType == PermissionType.location) {
      geoLoc.LocationPermission perm;
      checkIfGPSEnabled().then((value) async {
        if (value == true) {
          perm = await geoLoc.Geolocator.checkPermission();
          if (perm == geoLoc.LocationPermission.denied) {
            perm = await geoLoc.Geolocator.requestPermission();
            if (perm == geoLoc.LocationPermission.denied) {
              _onPermissionDenied!();
              return Future.error('Location permissions are denied');
            }
          }

          if (perm == geoLoc.LocationPermission.deniedForever) {
            // Permissions are denied forever, handle appropriately.
            return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.',
            );
            _onPermissionPermanentlyDenied!();
          }
          if (perm == geoLoc.LocationPermission.whileInUse ||
              perm == geoLoc.LocationPermission.always) {
            _onPermissionGranted!();
          }
        }
      });
    } else {
      perm.Permission permission = _getPermissionFromType(_permissionType!);

      if (permission == perm.Permission.locationWhenInUse ||
          permission == perm.Permission.locationAlways ||
          permission == perm.Permission.location) {
        print("****************************");
        await permission.shouldShowRequestRationale;
      }
      perm.PermissionStatus status = await permission.request();

      if (status.isGranted) {
        if (_onPermissionGranted != null) {
          _onPermissionGranted!();
        }
      } else if (status.isDenied) {
        if (_onPermissionDenied != null) {
          _onPermissionDenied!();
        }
      } else if (status.isPermanentlyDenied) {
        if (_onPermissionPermanentlyDenied != null) {
          _onPermissionPermanentlyDenied!();
        }
      }
    }
  }

  Future<bool?> checkIfGPSEnabled() async {
    bool serviceEnabled;
    serviceEnabled = await geoLoc.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await locaa.requestService();
      return Future.error('Location services are disabled.');
    } else {
      return serviceEnabled;
    }
  }
}
