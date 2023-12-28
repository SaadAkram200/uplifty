import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uplifty/models/user_model.dart';
import 'package:uplifty/utils/functions.dart';

class FunctionsProvider with ChangeNotifier {
  //for bottom appbar
  int selectedPage = 0;
  onTabTapped(int index) {
    selectedPage = index;
    notifyListeners();
  }

  //for search friends
  List<UserModel?> foundUsers = [];
  void filterSearchResults(
      String query, UserModel currentUser, List<UserModel?> allUsers) {
    foundUsers = allUsers
        .where((user) =>
            user != null &&
            user.username.toLowerCase().contains(query.toLowerCase()) &&
            !currentUser.myfriends!.contains(user.id))
        .toList();
    notifyListeners();
    if (query == "") {
      foundUsers.clear();
    }
  }

  //for search list - used in search screen
  bool isempty = true;
  checking(TextEditingController searchController) {
    if (searchController.text != "") {
      isempty = false;
    } else {
      isempty = true;
    }
    notifyListeners();
  }

  List<UserModel> friendRequestList = [];
  getFriendRequests(UserModel? userData, List<UserModel?> allUsers) {
    friendRequestList = allUsers
        .where((user) =>
            user != null &&
            userData!.friendrequest != null &&
            userData.friendrequest!.contains(user.id))
        .map((user) => user as UserModel)
        .toList();
    notifyListeners();
  }

//for image picker
  XFile? _selectedImage;

  set selectedImage(XFile? selectedImage) {
    _selectedImage = selectedImage;
    notifyListeners();
  }

  XFile? get selectedImage => _selectedImage;

  imagePicker(bool fromGallery) async {
    ImagePicker imagePicker = ImagePicker();
    selectedImage = await imagePicker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
    );
    notifyListeners();
  }

//for video/image- mdeia picker
  XFile? _selectedVideo;

  set selectedVideo(XFile? selectedVideo) {
    _selectedVideo = selectedVideo;
    notifyListeners();
  }

  XFile? get selectedVideo => _selectedVideo;
  videoPicker() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['mp4']);
    if (result != null) {
      selectedVideo = XFile(result.files.single.path as String);
    }
  }

//for file picker
  XFile? _selectedFile;

  set selectedFile(XFile? selectedFile) {
    _selectedFile = selectedFile;
    notifyListeners();
  }

  XFile? get selectedFile => _selectedFile;
  filePicker() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      'pdf',
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
      'txt',
    ]);

    if (result != null) {
      selectedFile = XFile(result.files.single.path as String);
    }
  }

  //voice message work
  bool isRecording = false;
  late String? audioPath;
  final record = Record();

  Future<void> startRecording() async {
    try {
      // Check if permission is granted
      if (!(await Permission.microphone.isGranted)) {
        // Request permission if not granted
        var status = await Permission.microphone.request();
        // Start recording if permission is granted
        await record.start();
        isRecording = true;
        notifyListeners();

        if (status != PermissionStatus.granted) {
          Functions.showToast("Microphone permission not granted");
          return;
        }
      }
    } catch (e) {
      Functions.showToast("Error starting recording: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      audioPath = await record.stop();
      isRecording = false;
      notifyListeners();
    } catch (e) {
      Functions.showToast("error stop recording : $e");
    }
  }
}
