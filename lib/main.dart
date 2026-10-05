import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const LearningDashboardApp());
}

class LearningDashboardApp extends StatelessWidget {
  const LearningDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LearningDashboardPage(),
    );
  }
}

class LearningDashboardPage extends StatefulWidget {
  const LearningDashboardPage({super.key});

  @override
  State<LearningDashboardPage> createState() =>
      _LearningDashboardPageState();
}

class _LearningDashboardPageState extends State<LearningDashboardPage> {
  // ============================================================
  // IDENTITAS
  // ============================================================

  String studentName = 'Wayan Muizul Rozzak';
  String studentId = '2415051111';

  // ============================================================
  // DATA
  // ============================================================

  late Future<Map<String, dynamic>> studentDataFuture;

  List<Map<String, dynamic>> courses = [];

  // ============================================================
  // TAHAP 10 & 11
  // NavigationBar + NavigationRail
  // ============================================================

  int currentIndex = 0;

  // ============================================================
  // TAHAP 12
  // Interaction
  // ============================================================

  bool isDemoFavorite = false;

  // ============================================================
  // TAHAP 13
  // Form Validation
  // ============================================================

  final formKey = GlobalKey<FormState>();

  String savedName = '';
  String savedNim = '';
  String savedComment = '';
  String feedbackResult = '';

  // ============================================================
  // TAHAP 14
  // Loading
  // ============================================================

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    studentDataFuture = loadStudentData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ============================================================
  // LOAD JSON
  // ============================================================

  Future<Map<String, dynamic>> loadStudentData() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/student_data.json');

      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      studentName = data['name'] ?? studentName;
      studentId = data['nim'] ?? studentId;

      if (data['courses'] is List) {
        courses = List<Map<String, dynamic>>.from(
          (data['courses'] as List).map(
            (course) => Map<String, dynamic>.from(course),
          ),
        );
      }

      return data;
    } catch (e) {
      return {
        'name': studentName,
        'nim': studentId,
        'courses': courses,
      };
    }
  }

  // ============================================================
  // NAVIGATION BAR
  // TAHAP 10
  // ============================================================

  Widget buildNavigationBar() {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: 'Courses',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  // ============================================================
  // NAVIGATION RAIL
  // TAHAP 11
  // ============================================================

  Widget buildNavigationRail() {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: Text('Courses'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }

  // ============================================================
  // ADAPTIVE APP SHELL
  // TAHAP 11
  // ============================================================

  Widget buildAdaptiveShell() {
    final pages = [
      buildHomePage(),
      buildCoursesPage(),
      buildProfilePage(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Layar compact / medium
        if (constraints.maxWidth < 840) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Learning Dashboard'),
            ),
            body: pages[currentIndex],
            bottomNavigationBar: buildNavigationBar(),
          );
        }

        // Layar lebar
        return Scaffold(
          appBar: AppBar(
            title: const Text('Learning Dashboard'),
          ),
          body: Row(
            children: [
              buildNavigationRail(),
              const VerticalDivider(width: 1),
              Expanded(
                child: pages[currentIndex],
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // HOME PAGE
  // ============================================================

  Widget buildHomePage() {
    return FutureBuilder<Map<String, dynamic>>(
      future: studentDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Identitas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      child: Icon(Icons.person, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            studentName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text('NIM: $studentId'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Summary
            Row(
              children: [
                Expanded(
                  child: buildSummaryCard(
                    'Courses',
                    '${courses.length}',
                    Icons.school,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildSummaryCard(
                    'Tahap',
                    '14',
                    Icons.assignment,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            buildTahap12(),

            const SizedBox(height: 16),

            buildTahap13(),

            const SizedBox(height: 16),

            buildTahap14(),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tahap 14 - Catatan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'SnackBar digunakan untuk informasi singkat, '
                      'Dialog untuk konfirmasi atau keputusan penting, '
                      'sedangkan CircularProgressIndicator digunakan '
                      'untuk memberikan feedback ketika proses sedang berlangsung.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SUMMARY CARD
  // ============================================================

  Widget buildSummaryCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TAHAP 12
  // INTERACTION
  // ============================================================

  Widget buildTahap12() {
    return Card(
      child: InkWell(
        onTap: () {
          setState(() {
            isDemoFavorite = !isDemoFavorite;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isDemoFavorite
                    ? 'Course ditambahkan ke favorite'
                    : 'Course dihapus dari favorite',
              ),
            ),
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('Informasi Course'),
                content: Text(
                  'Long press digunakan untuk menampilkan informasi tambahan.',
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                isDemoFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: isDemoFavorite ? Colors.red : null,
                size: 32,
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interaksi Course Card',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tap untuk favorite, long press untuk informasi.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TAHAP 13
  // FORM INPUT & VALIDATION
  // ============================================================

  Widget buildTahap13() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tahap 13 - Feedback Form',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Nama
              TextFormField(
                initialValue: studentName,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
                onSaved: (value) {
                  savedName = value?.trim() ?? '';
                },
              ),

              const SizedBox(height: 12),

              // NIM
              TextFormField(
                initialValue: studentId,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIM wajib diisi';
                  }
                  return null;
                },
                onSaved: (value) {
                  savedNim = value?.trim() ?? '';
                },
              ),

              const SizedBox(height: 12),

              // Komentar
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                  hintText: 'Masukkan komentar minimal 5 karakter',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Komentar wajib diisi';
                  }

                  if (value.trim().length < 5) {
                    return 'Komentar minimal 5 karakter';
                  }

                  return null;
                },
                onSaved: (value) {
                  savedComment = value?.trim() ?? '';
                },
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : submitFeedback,
                  icon: const Icon(Icons.send),
                  label: const Text('Kirim Feedback'),
                ),
              ),

              if (feedbackResult.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(),
                  ),
                  child: Text(feedbackResult),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TAHAP 14
  // SUBMIT FORM
  // SnackBar + Loading
  // ============================================================

  Future<void> submitFeedback() async {
    final form = formKey.currentState;

    if (form == null) {
      return;
    }

    // Validasi Tahap 13
    if (!form.validate()) {
      return;
    }

    // Simpan data form
    form.save();

    // Tampilkan loading
    setState(() {
      isLoading = true;
      feedbackResult = '';
    });

    // Simulasi proses selama 1,5 detik
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = false;

      feedbackResult =
          'Feedback berhasil diproses.\n\n'
          'Nama: $savedName\n'
          'NIM: $savedNim\n'
          'Komentar: $savedComment';
    });

    // SnackBar setelah form valid dan selesai diproses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data berhasil disimpan'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // TAHAP 14
  // ALERT DIALOG
  // ============================================================

  Future<void> showConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text(
            'Apakah Anda yakin ingin melanjutkan proses?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Lanjutkan'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proses dilanjutkan'),
        ),
      );
    }
  }

  // ============================================================
  // TAHAP 14
  // DEMO SNACKBAR, DIALOG & LOADING
  // ============================================================

  Widget buildTahap14() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tahap 14 - Feedback',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'SnackBar untuk informasi singkat, '
              'Dialog untuk konfirmasi, dan '
              'Loading untuk menunjukkan proses berjalan.',
            ),

            const SizedBox(height: 16),

            // Tombol Dialog
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: showConfirmationDialog,
                icon: const Icon(Icons.help_outline),
                label: const Text('Tampilkan Konfirmasi'),
              ),
            ),

            const SizedBox(height: 8),

            // Tombol SnackBar
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Ini adalah contoh SnackBar',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications),
                label: const Text('Tampilkan SnackBar'),
              ),
            ),

            const SizedBox(height: 8),

            // Loading
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });

                        await Future.delayed(
                          const Duration(seconds: 2),
                        );

                        if (!mounted) {
                          return;
                        }

                        setState(() {
                          isLoading = false;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Loading selesai',
                            ),
                          ),
                        );
                      },
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.hourglass_top),
                label: Text(
                  isLoading
                      ? 'Sedang memproses...'
                      : 'Simulasi Loading',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // COURSES PAGE
  // TAHAP 8, 9, 12
  // ============================================================

  Widget buildCoursesPage() {
    if (courses.isEmpty) {
      return const Center(
        child: Text('Belum ada data course.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              openCourseDetail(course);
            },
            onLongPress: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Long press pada ${course['title'] ?? 'course'}',
                  ),
                ),
              );
            },
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.school),
              ),
              title: Text(
                course['title']?.toString() ?? 'Course',
              ),
              subtitle: Text(
                course['status']?.toString() ?? 'Status belum tersedia',
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // COURSE DETAIL
  // TAHAP 8, 9, 12
  // ============================================================

  Future<void> openCourseDetail(
    Map<String, dynamic> course,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailPage(
          course: course,
          studentName: studentName,
          studentId: studentId,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course berhasil ditambahkan ke favorite'),
        ),
      );
    }
  }

  // ============================================================
  // PROFILE PAGE
  // ============================================================

  Widget buildProfilePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(
          radius: 50,
          child: Icon(
            Icons.person,
            size: 50,
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Nama'),
            subtitle: Text(studentName),
          ),
        ),

        Card(
          child: ListTile(
            leading: const Icon(Icons.badge),
            title: const Text('NIM'),
            subtitle: Text(studentId),
          ),
        ),

        const SizedBox(height: 16),

        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Profile digunakan untuk menampilkan identitas mahasiswa.',
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return buildAdaptiveShell();
  }
}

// =================================================================
// COURSE DETAIL PAGE
// TAHAP 8, 9, 12
// =================================================================

class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> course;
  final String studentName;
  final String studentId;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.studentName,
    required this.studentId,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final title = widget.course['title']?.toString() ?? 'Course';
    final status =
        widget.course['status']?.toString() ?? 'Status belum tersedia';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: InkWell(
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Informasi tambahan: $title',
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.school,
                      size: 70,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),

                    const SizedBox(height: 8),

                    Text('Status: $status'),

                    const SizedBox(height: 16),

                    Text(
                      'Mahasiswa: ${widget.studentName}\n'
                      'NIM: ${widget.studentId}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Favorite
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            label: Text(
              isFavorite
                  ? 'Hapus dari Favorite'
                  : 'Tambah ke Favorite',
            ),
          ),

          const SizedBox(height: 12),

          // Return data
          FilledButton(
            onPressed: () {
              Navigator.pop(context, isFavorite);
            },
            child: const Text('Simpan & Kembali'),
          ),
        ],
      ),
    );
  }
}