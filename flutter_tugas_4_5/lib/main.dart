import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Lowongan Kerja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF8F9FB)),
      home: const JobSearchScreen(),
    );
  }
}

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final List<Map<String, dynamic>> jobs = [
    {
      'company': 'Facebook',
      'title': 'Full time UI Designer',
      'salary': '\$8k',
      'location': 'Tokyo, Japan',
      'time': '24h',
      'isSelected': false,
      'isSaved': false,
      'logoWidget': const Icon(
        Icons.facebook,
        color: Color(0xFF1877F2),
        size: 36,
      ),
    },
    {
      'company': 'Babbel',
      'title': 'UX Design lead',
      'salary': '\$6k',
      'location': 'Berlin, Germany',
      'time': '4d',
      'isSelected': false,
      'isSaved': false,
      'logoWidget': const Text(
        '+B',
        style: TextStyle(
          color: Color(0xFFFF8C00),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    },
    {
      'company': 'Amazon',
      'title': 'Sr Product Designer',
      'salary': '\$8k',
      'location': 'Berlin, Germany',
      'time': '6d',
      'isSelected': true,
      'isSaved': true,
      'logoWidget': const Text(
        'a',
        style: TextStyle(
          color: Color(0xFFFF9900),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    },
    {
      'company': 'BuzzFeed',
      'title': 'Product Designer',
      'salary': '\$8k',
      'location': 'New York, NY',
      'time': '24h',
      'isSelected': false,
      'isSaved': false,
      'logoWidget': Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        color: const Color(0xFFEE3322),
        child: const Text(
          'Buzz\nFeed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            height: 1.1,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    },
    {
      'company': 'Google',
      'title': 'User Experience Researcher',
      'salary': '\$10k',
      'location': 'California, USA',
      'time': '2w',
      'isSelected': false,
      'isSaved': false,
      'logoWidget': const Text(
        'G',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    },
    {
      'company': 'Apple',
      'title': 'Senior UI/UX Designer',
      'salary': '\$12k',
      'location': 'Cupertino, USA',
      'time': '3w',
      'isSelected': false,
      'isSaved': true,
      'logoWidget': const Icon(Icons.apple, color: Colors.black, size: 36),
    },
    {
      'company': 'Spotify',
      'title': 'Product Designer',
      'salary': '\$7k',
      'location': 'Stockholm, Sweden',
      'time': '1m',
      'isSelected': false,
      'isSaved': false,
      'logoWidget': const Icon(
        Icons.music_note,
        color: Color(0xFF1DB954),
        size: 36,
      ),
    },
    {
      'company': 'Netflix',
      'title': 'Lead Motion Designer',
      'salary': '\$9k',
      'location': 'Los Gatos, USA',
      'time': '1m',
      'isSelected': false,
      'isSaved': false,
      'logoWidget': const Text(
        'N',
        style: TextStyle(
          color: Color(0xFFE50914),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    },
    {
      'company': 'LinkedIn',
      'title': 'UI Designer',
      'salary': '\$6k',
      'location': 'Sunnyvale, USA',
      'time': '2m',
      'isSelected': false,
      'isSaved': true,
      'logoWidget': const Text(
        'in',
        style: TextStyle(
          color: Color(0xFF0A66C2),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    },
    {
      'company': 'Airbnb',
      'title': 'UX Researcher',
      'salary': '\$8k',
      'location': 'San Francisco, USA',
      'time': '2m',
      'isSelected': false,
      'isSaved': false,
      'logoWidget': const Text(
        'A',
        style: TextStyle(
          color: Color(0xFFFF5A5F),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () {},
                child: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "UI/UX Design",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1A34),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${jobs.length} Job Opportunity",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E294E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Most Relevant",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Most Recent",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                // Menambahkan BouncingScrollPhysics untuk menghilangkan efek stretch
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  return _buildJobCard(jobs[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    bool isSelected = job['isSelected'];

    Color bgColor = isSelected ? const Color(0xFF2E294E) : Colors.white;
    Color titleColor = isSelected ? Colors.white : const Color(0xFF1E1A34);
    Color subtitleColor = isSelected
        ? Colors.grey.shade400
        : Colors.grey.shade600;
    Color logoBgColor = isSelected ? Colors.white : const Color(0xFFF4F5F7);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF2E294E).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: logoBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: job['logoWidget'],
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['company'],
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  job['title'],
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${job['salary']} - ${job['location']}",
                  style: TextStyle(color: subtitleColor, fontSize: 13),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                job['isSaved'] ? Icons.favorite : Icons.favorite_border,
                color: job['isSaved']
                    ? const Color(0xFFFF6B6B)
                    : (isSelected ? Colors.white54 : Colors.grey.shade400),
                size: 22,
              ),
              const SizedBox(height: 30),
              Text(
                job['time'],
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
