import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      imageUrl: "https://codewithandrea.com/img/avatars/alicia-avatar.png",
    ),
    Article(
      publisher: "Mariia Romaniuk",
      publishedAt: DateTime(2023, 6, 21),
      title: "System Design: Chat Application",
      tags: ["system design", "architecture", "chat"],
      imageUrl: "https://miro.medium.com/v2/1*kTb6SylLtgnjJB09imVMQw.jpeg",
    ),
    Article(
      publisher: "Matt Sullivan",
      publishedAt: DateTime(2019, 1, 4),
      tags: ["dart", "garbage collector"],
      title: "Flutter: Don’t Fear the Garbage Collector",
      imageUrl: "https://miro.medium.com/v2/0*cgL8XWJBpDSy2mHs.jpg",
    ),
    Article(
      tags: ["git"],
      publisher: "Martin Fowler",
      publishedAt: DateTime(2020, 5, 28),
      imageUrl: "https://martinfowler.com/mf.jpg",
      title: "Patterns for Managing Source Code Branches",
    ),
    Article(
      publisher: "Mangirdas Kazlauskas",
      publishedAt: DateTime(2019, 10, 8),
      tags: ["flutter", "Design Patterns"],
      title: "Flutter Design Patterns: Introduction",
      imageUrl: "https://pbs.twimg.com/profile_images/1670723606035267585/jO9wYBzP_400x400.jpg",
    ),
    Article(
      publisher: "Andrea Bizzotto",
      tags: ["security", "networking"],
      publishedAt: DateTime(2024, 7, 22),
      title: "How to Store API Keys in Flutter: --dart-define vs .env files",
      imageUrl: "https://codewithandrea.com/img/avatars/andrea-avatar-small.png",
    ),
  ];

  // represents the index of the card that is currently being hovered
  int? hoveredIndex;

  final defaultCurve = Curves.ease;
  final defaultDuration = Durations.short4;

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

            final widthFactor = index == hoveredIndex ? 1.0 : 0.6;
            final turns = index == hoveredIndex ? 0.01 : 0.0;
            final offset = Offset(0, index == hoveredIndex ? -0.05 : 0);

            return AnimatedAlign(
              curve: defaultCurve,
              widthFactor: widthFactor,
              duration: defaultDuration,
              alignment: Alignment.centerLeft,
              child: AnimatedSlide(
                offset: offset,
                curve: defaultCurve,
                duration: defaultDuration,
                child: AnimatedRotation(
                  turns: turns,
                  curve: defaultCurve,
                  duration: defaultDuration,
                  child: MouseRegion(
                    child: _ArticleCard(article: article),
                    onEnter: (event) => setState(() => hoveredIndex = index),
                    onExit: (event) => setState(() => hoveredIndex = null),
                  ),
                ),
              ),
            );
          },
        ),
      ),
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
                    TextSpan(
                      text: "Article ",
                      style: GoogleFonts.merriweather(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'on ${DateFormat("MMM dd, yyyy").format(article.publishedAt)}',
                      style: GoogleFonts.merriweather(fontSize: 14, color: const Color(0xff777777)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 21,
                  letterSpacing: -0.5,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                children: [
                  ...List.generate(article.tags.length, (index) {
                    return Text(
                      article.tags[index].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: -0.5,
                        color: Color(0xffff7a18),
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    foregroundImage: NetworkImage(article.imageUrl),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    article.publisher,
                    style: GoogleFonts.merriweather(
                      fontSize: 14,
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
    required this.tags,
    required this.title,
    required this.imageUrl,
    required this.publisher,
    required this.publishedAt,
  });

  final String title;
  final String imageUrl;
  final String publisher;
  final List<String> tags;
  final DateTime publishedAt;
}
