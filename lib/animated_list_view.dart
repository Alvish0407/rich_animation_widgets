import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _articleCardHeight = 300.0;
const _articleCardWidth = 300.0;

class AnimatedListView extends StatefulWidget {
  const AnimatedListView({super.key});

  @override
  State<AnimatedListView> createState() => _AnimatedListViewState();
}

class _AnimatedListViewState extends State<AnimatedListView> {
  final articles = [
    Article(
      publisher: "Alicja Ogonowska",
      publishedAt: DateTime(2023, 12, 8),
      title: "Flutter Deep Linking: The Ultimate Guide",
      tags: ["dart", "flutter", "go_router", "navigation"],
    ),
    Article(
      publisher: "Mariia Romaniuk",
      publishedAt: DateTime(2023, 6, 21),
      title: "System Design: Chat Application",
      tags: ["system design", "architecture", "chat"],
    ),
    Article(
      publisher: "Vyacheslav Egorov",
      publishedAt: DateTime(2022, 10, 6),
      title: "Introduction to Dart VM",
      tags: ["dart", "vm"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff262626),
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text(
          'Animated List View',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SizedBox(
        height: 400,
        child: ListView.builder(
          itemCount: articles.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(32),
          itemBuilder: (context, index) {
            final article = articles[index];

            return Align(
              alignment: Alignment.centerRight,
              widthFactor: index == 0 ? 1 : 0.67,
              child: _ArticleCard(article: article),
            );
          },
        ),
      ),
      // body: Stack(
      //   children: articles.map((article) {
      //     final index = articles.indexOf(article);

      //     return Positioned(
      //       top: 0,
      //       bottom: 0,
      //       left: _articleCardWidth + (index * (_articleCardWidth / 1.67)),
      //       child: UnconstrainedBox(child: _ArticleCard(article: article)),
      //     );
      //   }).toList(),
      // ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Shadow behind the card
        Container(
          width: _articleCardWidth / 2,
          height: _articleCardHeight / 1.3,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 50,
                spreadRadius: 20,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        Container(
          width: _articleCardWidth,
          height: _articleCardHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(colors: [Color(0xff434343), Color(0xff262626)]),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: Color(0xffd4d4d4)),
                  children: [
                    const TextSpan(text: "Article "),
                    TextSpan(
                      text: 'on ${DateFormat("MMM dd, yyyy").format(article.publishedAt)}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 21,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                children: [
                  ...List.generate(article.tags.length, (index) {
                    return Text(
                      article.tags[index].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xffff7a18),
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const CircleAvatar(radius: 18),
                  const SizedBox(width: 8),
                  Text(
                    article.publisher,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Article {
  const Article({
    required this.title,
    required this.tags,
    required this.publisher,
    required this.publishedAt,
  });

  final String title;
  final String publisher;
  final List<String> tags;
  final DateTime publishedAt;
}
