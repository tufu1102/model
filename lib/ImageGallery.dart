import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: ImageGallery()));

class ImageGallery extends StatelessWidget {
  final List<String> images = [
    'https://picsum.photos/200',
    'https://picsum.photos/201',
    'https://picsum.photos/202',
    'https://picsum.photos/203',
    'https://picsum.photos/204'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Gallery")),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: images.length,
        itemBuilder: (context, index) => Image.network(images[index], fit: BoxFit.cover),
      ),
    );
  }
}
