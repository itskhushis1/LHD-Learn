import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePicturePage extends StatefulWidget {
  const TakePicturePage({
    Key key,
  }) : super(key: key);

  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      final firstCamera = cameras.first;
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
      );
      setState(() {
        _initializeControllerFuture = _controller.initialize();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt, color: Colors.white, size: 32),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            XFile file = await _controller.takePicture();
            Navigator.pop(context, file.path);
          } catch (e) {}
        },
      ),
    );
  }
}
