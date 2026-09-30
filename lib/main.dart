import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// ======================================================
// LOAD DATA JSON
// ======================================================

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

// ======================================================
// REUSABLE WIDGET - SUMMARY CARD
// ======================================================

Widget buildSummaryCard(
  String title,
  String value,
  IconData icon,
) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Icon(
              icon,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ======================================================
// REUSABLE WIDGET - COURSE CARD
// ======================================================

Widget buildCourseCard(
  Map<String, dynamic> course,
) {
  final String status =
      course['status']?.toString() ?? 'planned';

  IconData statusIcon;
  String statusText;

  if (status == 'done') {
    statusIcon = Icons.check_circle;
    statusText = 'Selesai';
  } else if (status == 'active') {
    statusIcon = Icons.play_circle_fill;
    statusText = 'Berjalan';
  } else {
    statusIcon = Icons.schedule;
    statusText = 'Direncanakan';
  }

  final String title =
      course['title']?.toString() ?? 'Tanpa judul';

  final String code =
      course['code']?.toString() ?? '-';

  final String credits =
      course['credits']?.toString() ?? '0';

  return Card(
    margin: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 5,
    ),
    child: ListTile(
      leading: Icon(
        statusIcon,
        size: 30,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '$code • $credits SKS',
      ),
      trailing: Text(
        statusText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// ======================================================
// MAIN
// ======================================================

void main() {
  runApp(const MyApp());
}

// ======================================================
// MY APP
// ======================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

// ======================================================
// DASHBOARD PAGE
// ======================================================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();

    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard'),
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: studentFuture,
          builder: (context, snapshot) {
            // ==================================================
            // LOADING STATE
            // ==================================================

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // ==================================================
            // ERROR STATE - KASUS C
            // ==================================================

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Gagal memuat data:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // ==================================================
            // DATA TIDAK ADA
            // ==================================================

            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'Data tidak tersedia',
                ),
              );
            }

            // ==================================================
            // AMBIL DATA JSON
            // ==================================================

            final Map<String, dynamic> data =
                snapshot.data!;

            final Map<String, dynamic> student =
                (data['student']
                        as Map<String, dynamic>?) ??
                    {};

            final List<dynamic> courses =
                (data['courses'] as List<dynamic>?) ??
                    [];

            // ==================================================
            // IDENTITAS MAHASISWA
            // ==================================================

            final String studentName =
                student['name']?.toString() ??
                    'Wayan Muizul Rozzak';

            final String studentId =
                student['nim']?.toString() ??
                    '2415051111';

            final String profilePath =
                student['profile']?.toString() ??
                    'assets/images/profile.jpg';

            // ==================================================
            // SUMMARY
            // ==================================================

            final int totalCourses =
                courses.length;

            final int completedCourses =
                courses.where((course) {
              if (course is Map<String, dynamic>) {
                return course['status'] == 'done';
              }

              return false;
            }).length;

            final int totalCredits =
                courses.fold<int>(
              0,
              (total, course) {
                if (course is Map<String, dynamic>) {
                  final dynamic credits =
                      course['credits'];

                  if (credits is int) {
                    return total + credits;
                  }
                }

                return total;
              },
            );

            // ==================================================
            // DASHBOARD
            // ==================================================

            return Column(
              children: [
                // ==================================================
                // PROFILE CARD
                // ==================================================

                Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage(profilePath),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                studentName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                studentId,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 4),

                              const Text(
                                'Mahasiswa Pemrograman Mobile',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // KASUS A - RENDERFLEX OVERFLOW
                // ==================================================
                //
                // Masalah awal:
                //
                // Row(
                //   children: [
                //     const Icon(Icons.info),
                //     const SizedBox(width: 8),
                //     Text('Teks sangat panjang...')
                //   ],
                // )
                //
                // Perbaikan:
                // Text dibungkus Expanded.
                // ==================================================

                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info,
                          size: 24,
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            '$studentId - $studentName - '
                            'Ini adalah teks yang sangat panjang '
                            'untuk menguji layout pada Flutter.',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // SUMMARY CARD
                // ==================================================

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      buildSummaryCard(
                        'Total Topik',
                        '$totalCourses',
                        Icons.menu_book,
                      ),

                      buildSummaryCard(
                        'Total SKS',
                        '$totalCredits',
                        Icons.school,
                      ),

                      buildSummaryCard(
                        'Selesai',
                        '$completedCourses',
                        Icons.check_circle,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ==================================================
                // JUDUL DAFTAR MATERI
                // ==================================================

                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Daftar Materi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // LIST MATERI
                // ==================================================

                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder:
                        (context, index) {
                      final Map<String, dynamic>
                          course =
                          courses[index]
                              as Map<String, dynamic>;

                      return buildCourseCard(
                        course,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}