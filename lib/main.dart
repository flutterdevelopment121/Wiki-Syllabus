import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color seedColor = Colors.brown; // Default seed color is brown
  bool isDark = true; // Default mode is dark mode

  void updateSeedColor(Color newColor) {
    setState(() {
      seedColor = newColor;
    });
  }

  void toggleThemeMode() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiki Syllabus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(
        title: 'Wiki Syllabus',
        onChangeSeedColor: updateSeedColor,
        onToggleTheme: toggleThemeMode,
        isDark: isDark,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.onChangeSeedColor,
    required this.onToggleTheme,
    required this.isDark,
  });

  final String title;
  final void Function(Color) onChangeSeedColor;
  final VoidCallback onToggleTheme;
  final bool isDark;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _level;
  String? _university;
  String? _stream;
  String? _semester;

  static const Map<String, Map<String, List<String>>> subjectData = {
    'Computer Science': {
      'Semester 1': ['Mathematics I', 'Physics', 'Programming Basics'],
      'Semester 2': ['Mathematics II', 'Data Structures', 'Electronics'],
    },
    'Civil': {
      'Semester 1': ['Mathematics I', 'Engineering Mechanics', 'Chemistry'],
      'Semester 2': ['Mathematics II', 'Surveying', 'Building Materials'],
    },
    'Mechanical': {
      'Semester 1': ['Mathematics I', 'Physics', 'Engineering Graphics'],
      'Semester 2': ['Mathematics II', 'Thermodynamics', 'Workshop'],
    },
  };

  static const Map<String, List<String>> moduleData = {
    'Mathematics I': [
      'Module 1: Calculus',
      'Module 2: Algebra',
      'Module 3: Trigonometry',
    ],
    'Physics': ['Module 1: Mechanics', 'Module 2: Waves', 'Module 3: Optics'],
    'Programming Basics': [
      'Module 1: Introduction',
      'Module 2: Variables',
      'Module 3: Control Structures',
    ],
    'Mathematics II': [
      'Module 1: Differential Equations',
      'Module 2: Laplace Transforms',
      'Module 3: Vector Calculus',
    ],
    'Data Structures': [
      'Module 1: Arrays',
      'Module 2: Linked Lists',
      'Module 3: Trees',
    ],
    'Electronics': [
      'Module 1: Diodes',
      'Module 2: Transistors',
      'Module 3: Amplifiers',
    ],
    'Engineering Mechanics': [
      'Module 1: Statics',
      'Module 2: Dynamics',
      'Module 3: Friction',
    ],
    'Chemistry': [
      'Module 1: Atomic Structure',
      'Module 2: Chemical Bonding',
      'Module 3: Thermodynamics',
    ],
    'Surveying': [
      'Module 1: Chain Survey',
      'Module 2: Compass Survey',
      'Module 3: Leveling',
    ],
    'Building Materials': [
      'Module 1: Stones',
      'Module 2: Bricks',
      'Module 3: Cement',
    ],
    'Engineering Graphics': [
      'Module 1: Orthographic Projection',
      'Module 2: Isometric Drawing',
      'Module 3: Sectional Views',
    ],
    'Thermodynamics': [
      'Module 1: Laws of Thermodynamics',
      'Module 2: Entropy',
      'Module 3: Engines',
    ],
    'Workshop': [
      'Module 1: Carpentry',
      'Module 2: Fitting',
      'Module 3: Welding',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Widget content;
    if (_level == null) {
      content = _stepCard(
        context,
        title: 'Choose Education Level',
        options: ['College'],
        onSelected: (val) => setState(() => _level = val),
      );
    } else if (_level == 'College' && _university == null) {
      content = _stepCard(
        context,
        title: 'Select University',
        options: ['KTU', 'MG University', 'CUSAT'],
        onSelected: (val) => setState(() => _university = val),
        onBack: () => setState(() => _level = null),
      );
    } else if (_stream == null) {
      content = _stepCard(
        context,
        title: 'Select Stream',
        options: ['Computer Science', 'Civil', 'Mechanical'],
        onSelected: (val) => setState(() => _stream = val),
        onBack: () => setState(() => _university = null),
      );
    } else if (_semester == null) {
      content = _stepCard(
        context,
        title: 'Select Semester',
        options: List.generate(8, (i) => 'Semester ${i + 1}'),
        onSelected: (val) => setState(() => _semester = val),
        onBack: () => setState(() => _stream = null),
      );
    } else {
      content = _SubjectSearch(
        university: _university!,
        stream: _stream!,
        semester: _semester!,
        onBack: () => setState(() => _semester = null),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: size.height * 0.25,
                child: Center(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * 0.09,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              Expanded(child: content),
            ],
          ),
          // Floating color change and dark mode buttons at top right
          Positioned(
            top: 32,
            right: 24,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  onPressed: () async {
                    final Color? picked = await showDialog<Color>(
                      context: context,
                      builder: (context) => const _ColorPickerDialog(),
                    );
                    if (picked != null) {
                      widget.onChangeSeedColor(picked);
                    }
                  },
                  child: const Icon(Icons.color_lens),
                  tooltip: 'Change Theme Color',
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  onPressed: widget.onToggleTheme,
                  child: Icon(
                    widget.isDark ? Icons.dark_mode : Icons.light_mode,
                  ),
                  tooltip: 'Toggle Dark Mode',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepCard(
    BuildContext context, {
    required String title,
    required List<String> options,
    required void Function(String) onSelected,
    VoidCallback? onBack,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withOpacity(0.7),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (onBack != null)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: onBack,
                          tooltip: 'Back',
                        ),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 48),
                  ...options.map(
                    (option) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 110,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () => onSelected(option),
                          child: Text(option),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubjectSearch extends StatefulWidget {
  final String university;
  final String stream;
  final String semester;
  final VoidCallback onBack;

  const _SubjectSearch({
    required this.university,
    required this.stream,
    required this.semester,
    required this.onBack,
  });

  @override
  State<_SubjectSearch> createState() => _SubjectSearchState();
}

class _SubjectSearchState extends State<_SubjectSearch> {
  String? _selectedSubject;
  String? _selectedModule;

  // Track completed modules for each subject
  final Map<String, Set<String>> _completedModules = {};

  static const Map<String, Map<String, List<String>>> subjectData =
      _MyHomePageState.subjectData;
  static const Map<String, List<String>> moduleData =
      _MyHomePageState.moduleData;

  @override
  Widget build(BuildContext context) {
    final subjects = subjectData[widget.stream]?[widget.semester] ?? [];
    final size = MediaQuery.of(context).size;

    if (_selectedSubject == null) {
      // Use the same design as university selection for subjects
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: widget.onBack,
                          tooltip: 'Back',
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Select Subject',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    if (subjects.isEmpty)
                      const Text(
                        'No subjects found for this stream and semester.',
                      ),
                    ...subjects.map(
                      (subject) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 110,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedSubject = subject;
                                _selectedModule = null;
                              });
                            },
                            child: Text(subject),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      final modules = moduleData[_selectedSubject] ?? ['No modules found'];
      final completed = _completedModules[_selectedSubject] ?? {};
      final progress = '${completed.length}/${modules.length} done';
      final size = MediaQuery.of(context).size;

      return LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          // MOBILE: Show only modules or only content
          if (isMobile) {
            // Show modules list if no module selected
            if (_selectedModule == null) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Top bar with back and progress
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () =>
                              setState(() => _selectedSubject = null),
                          tooltip: 'Back',
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            progress,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.22),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                ...modules.map(
                                  (module) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 70,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          backgroundColor:
                                              module == _selectedModule
                                              ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.18)
                                              : Colors.white.withOpacity(0.12),
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedModule = module;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                module,
                                                style: TextStyle(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                completed.contains(module)
                                                    ? Icons.check_box
                                                    : Icons
                                                          .check_box_outline_blank,
                                                color:
                                                    completed.contains(module)
                                                    ? Colors.green
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  final set =
                                                      _completedModules[_selectedSubject] ??
                                                      <String>{};
                                                  if (set.contains(module)) {
                                                    set.remove(module);
                                                  } else {
                                                    set.add(module);
                                                  }
                                                  _completedModules[_selectedSubject!] =
                                                      set;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Bottom frosted button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            width: double.infinity,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.22),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Today's work uploaded!"),
                                    ),
                                  );
                                },
                                child: const Center(
                                  child: Text(
                                    "Upload Today's Work",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Show only content box with back icon
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () =>
                              setState(() => _selectedModule = null),
                          tooltip: 'Back to modules',
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedModule!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.22),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedModule!,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Content and tasks for $_selectedModule',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }

          // DESKTOP/TABLET: Show both boxes side by side with back icon
          return SingleChildScrollView(
            child: Column(
              children: [
                // Top bar with back and progress
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => setState(() => _selectedSubject = null),
                      tooltip: 'Back',
                    ),
                    const SizedBox(width: 8),
                    Text(
                      progress,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.55,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      // Left: Module names as buttons with tick
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.22),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...modules.map(
                                        (module) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12.0,
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 70,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                backgroundColor:
                                                    module == _selectedModule
                                                    ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                          .withOpacity(0.18)
                                                    : Colors.white.withOpacity(
                                                        0.12,
                                                      ),
                                                textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                    ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _selectedModule = module;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      module,
                                                      style: TextStyle(
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.onSurface,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      completed.contains(module)
                                                          ? Icons.check_box
                                                          : Icons
                                                                .check_box_outline_blank,
                                                      color:
                                                          completed.contains(
                                                            module,
                                                          )
                                                          ? Colors.green
                                                          : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        final set =
                                                            _completedModules[_selectedSubject] ??
                                                            <String>{};
                                                        if (set.contains(
                                                          module,
                                                        )) {
                                                          set.remove(module);
                                                        } else {
                                                          set.add(module);
                                                        }
                                                        _completedModules[_selectedSubject!] =
                                                            set;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Right: Module content, always same size as left
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.22),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: SizedBox.expand(
                                  child: _selectedModule == null
                                      ? Center(
                                          child: Text(
                                            'Select a module',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _selectedModule!,
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Content and tasks for $_selectedModule',
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Bottom frosted button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Today's work uploaded!"),
                                ),
                              );
                            },
                            child: const Center(
                              child: Text(
                                "Upload Today's Work",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}

class _ColorPickerDialog extends StatelessWidget {
  const _ColorPickerDialog();

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.deepPurple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.pink,
      Colors.teal,
      Colors.brown,
    ];
    return AlertDialog(
      title: const Text('Pick a theme color'),
      content: Wrap(
        spacing: 12,
        children: colors
            .map(
              (color) => GestureDetector(
                onTap: () => Navigator.of(context).pop(color),
                child: CircleAvatar(backgroundColor: color, radius: 22),
              ),
            )
            .toList(),
      ),
    );
  }
}
