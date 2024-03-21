import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;


class MyModelService {
  late Interpreter _interpreter;
  bool _isModelLoaded = false;
  List<String>? _labels;


  Future<void> loadModel() async {
   // _interpreter = await Interpreter.fromAsset('assets/model_MobileNet.tflite');
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');
    await loadLabels();
    _isModelLoaded = true;

  }

  Future<void> loadLabels() async {
    final labelsString = await rootBundle.loadString('assets/labels.txt');
    _labels = labelsString.split(',');
  }

  Future<String?> classifyImage(File imageFile) async {
    if (!_isModelLoaded) await loadModel();

    // Prepare the image and get the input as a byte buffer
    Float32List inputImage = await _prepareImage(imageFile);

    //  Input shape of the model [1, 32, 32, 3] and output of [1, numOfClasses]
     var input = inputImage.reshape([1, 32, 32, 3]); //
    //var input = inputImage.reshape([1, 160, 160, 3]);
    var outputShape = _interpreter.getOutputTensor(0).shape;
    var outputLength = outputShape[1];


    // Adjusting the output buffer to match the model's output shape [1, 131]
    // Create a container for the model output with the correct shape
    var outputBuffer = List.filled(1, List<double>.filled(outputLength, 0));

    // Run inference
    _interpreter.run(input, outputBuffer);

    List<double> output = outputBuffer[0];

    double highestProb = 0;
    int classIndex = -1;
    for (int i = 0; i < outputLength; i++) {
      if (output[i] > highestProb) {
        highestProb = output[i];
        classIndex = i;
      }
    }

    String className = "Unknown";
    if (classIndex != -1 && _labels != null) {
      className = _labels![classIndex];
    }

    return className;
  }


  Future<Float32List> _prepareImage(File image) async {
    // Load the image file
    Uint8List imageBytes;
    imageBytes = await image.readAsBytes();

    // Decode the image to an Image object
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) throw Exception('Failed to decode image');

    // Resize the image
     img.Image resizedImage = img.copyResize(originalImage, width: 32, height: 32);
    //img.Image resizedImage = img.copyResize(originalImage, width: 160, height: 160);

    Float32List buffer = Float32List(32 * 32 * 3); // For an RGB model input of size 32x32
    int bufferIndex = 0;

    // Fill the buffer with normalized pixel values
    for (int y = 0; y < 32; y++) {
      for (int x = 0; x < 32; x++) {
        var pixel = resizedImage.getPixel(x, y);
        buffer[bufferIndex++] = pixel.r / 1.0; // Red
        buffer[bufferIndex++] = pixel.g / 1.0 ;  // Green
        buffer[bufferIndex++] = pixel.b / 1.0;  // Blue
      }
    }

    return buffer;
  }


}
