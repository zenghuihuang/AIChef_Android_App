import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/tflite_model.dart';
import 'food_detail_screen.dart';


List<CameraDescription> cameras = [];
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  XFile? _imageFile;
  String? _foodItemName;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(firstCamera, ResolutionPreset.medium);
    try {
      await _controller!.initialize();
      setState(() {}); // Trigger a rebuild once the camera is initialized
    } catch (e) {
      print('Error intializing camera :$e');
    }
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('Controller is not initialized');
      return;
    }

    try {
      final image = await _controller!.takePicture();
      identifyFoodItem(File(image.path));
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        identifyFoodItem(File(pickedFile.path));
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }

  Future<void> identifyFoodItem(File imageFile) async {
    await MyModelService().loadModel();
    String? foodItem = await MyModelService().classifyImage(imageFile);

    if (foodItem != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FoodDetailsScreen(imageFile: imageFile, foodItemName: foodItem),
      ));
    } else {
      print('No food item identified.');
    }
  }


  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera View'),
      ),
      // Use a Column to layout the CameraPre gview and the rest of your UI
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: _imageFile == null
                ? FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && _controller != null) {
                  // Wrap CameraPreview with AspectRatio widget
                  return AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: CameraPreview(_controller!),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
                : Image.file(File(_imageFile!.path)),
          ),
          if (_imageFile == null) // Show capture button only if no image is captured
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _captureImage,
                    heroTag: 'camera',
                    child: const Icon(Icons.camera_alt),
                  ),
                  FloatingActionButton(
                    onPressed: _pickImageFromGallery,
                    heroTag: 'gallery',
                    child: const Icon(Icons.photo_library),
                  )
                ]
              )
            ),
          if (_foodItemName != null) Text('Identified: $_foodItemName')
        ],
      ),
    );
  }
}
