import 'package:flutter/foundation.dart';

/// Service to store and retrieve the transporter profile image
class ProfileImageService {
  static final ProfileImageService _instance = ProfileImageService._internal();
  
  factory ProfileImageService() => _instance;
  
  ProfileImageService._internal();

  Uint8List? _profileImageBytes;
  String? _profileImageName;

  /// Set the profile image
  void setProfileImage(Uint8List? bytes, String? name) {
    _profileImageBytes = bytes;
    _profileImageName = name;
  }

  /// Get the profile image bytes
  Uint8List? get profileImageBytes => _profileImageBytes;

  /// Get the profile image name
  String? get profileImageName => _profileImageName;

  /// Check if profile image is set
  bool get hasProfileImage => _profileImageBytes != null;

  /// Clear the profile image
  void clearProfileImage() {
    _profileImageBytes = null;
    _profileImageName = null;
  }
}
