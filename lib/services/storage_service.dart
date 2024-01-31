import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'api_service.dart';
enum StorageStatus { ideal, loading, success, failed }

class StorageProvider extends ChangeNotifier {
  StorageStatus? status = StorageStatus.ideal;
  static StorageProvider instance = StorageProvider();

  Future<String> uploadProfileImage(File file, int userId) async {
    status = StorageStatus.loading;
    notifyListeners();
    String path =
        '$userId/profileImane/${file.path.split(Platform.pathSeparator).last}';
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask? uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadLink = await snapshot.ref.getDownloadURL();
    status = StorageStatus.success;
    notifyListeners();
    return downloadLink;
  }

  Future<UserModel?> uploadKycImage(File aadhaarFront, File aadhaarBack,
      File pan, UserModel? userModel) async {
    status = StorageStatus.loading;
    notifyListeners();
    String path =
        '${userModel?.id}/kyc/aadhaarFront.${aadhaarFront.path.split('.').last}';
    var ref = FirebaseStorage.instance.ref().child(path);
    UploadTask? uploadTask = ref.putFile(aadhaarFront);
    var snapshot = await uploadTask.whenComplete(() {});
    var downloadLink = await snapshot.ref.getDownloadURL();
    userModel?.aadharFront = downloadLink;

    path =
        '${userModel?.id}/kyc/aadhaarBack.${aadhaarBack.path.split('.').last}';
    ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(aadhaarBack);
    snapshot = await uploadTask.whenComplete(() {});
    downloadLink = await snapshot.ref.getDownloadURL();
    userModel?.aadharBack = downloadLink;

    path = '${userModel?.id}/kyc/pan.${pan.path.split('.').last}';
    ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(pan);
    snapshot = await uploadTask.whenComplete(() {});
    downloadLink = await snapshot.ref.getDownloadURL();
    userModel?.pan = downloadLink;

    await ApiProvider.instance
        .updateUser(userModel?.toMap() ?? {}, userModel?.id ?? -1);
    status = StorageStatus.success;
    notifyListeners();
    return userModel;
  }

  Future<String> uploadPropertyImage(File file, String mediaType) async {
    status = StorageStatus.loading;
    notifyListeners();
    String path =
        'property/$mediaType/${file.path.split(Platform.pathSeparator).last}';
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask? uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadLink = await snapshot.ref.getDownloadURL();
    status = StorageStatus.success;
    notifyListeners();
    return downloadLink;
  }

   Future<String> uploadPropertyThumbnail(File file) async {
    status = StorageStatus.loading;
    notifyListeners();
    String path =
        'property/thumbnail/${file.path.split(Platform.pathSeparator).last}';
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask? uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadLink = await snapshot.ref.getDownloadURL();
    status = StorageStatus.success;
    notifyListeners();
    return downloadLink;
  }
}
