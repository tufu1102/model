import 'package:flutter/material.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsListScreen(),
    );
  }
}

class NewsListScreen extends StatelessWidget {
  final List<Map<String, String>> news = [
    {'title': 'Flutter 3.0 Released', 'description': 'Flutter 3.0 comes with exciting new features and improvements.'},
    {'title': 'AI Advances in 2025', 'description': 'Artificial Intelligence is transforming industries worldwide.'},
    {'title': 'SpaceX Mars Mission', 'description': 'SpaceX announces plans to send humans to Mars by 2030.'},
    {'title': 'Climate Change Effects', 'description': 'Scientists warn about the increasing impacts of climate change.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Headlines')),
      body: ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(news[index]['title']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(news[index]['title']!, news[index]['description']!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String description;

  NewsDetailScreen(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          description,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}