import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const StudentInfoApp());

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF7F7FC),
      ),
      home: const StudentProfileScreen(),
    );
  }
}

/// This state owns both selections, so orientation changes do not reset them.
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  static const roles = ['Student', 'Developer', 'Designer'];
  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());
  String _selectedRole = roles.first;

  String get _dateLabel =>
      '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-'
      '${_selectedDate.day.toString().padLeft(2, '0')}';

  Future<void> _selectMaterialDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateUtils.dateOnly(DateTime.now()),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = DateUtils.dateOnly(picked));
    }
  }

  Future<void> _showCupertinoDatePicker() async {
    var draftDate = _selectedDate;
    final result = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (sheetContext) => PickerSheet(
        title: 'Select date',
        onDone: () => Navigator.pop(sheetContext, draftDate),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate,
          minimumDate: DateTime(1950),
          maximumDate: DateUtils.dateOnly(DateTime.now()),
          onDateTimeChanged: (date) => draftDate = DateUtils.dateOnly(date),
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() => _selectedDate = result);
    }
  }

  Future<void> _showCupertinoRolePicker() async {
    var draftRole = _selectedRole;
    final controller = FixedExtentScrollController(
      initialItem: roles.indexOf(_selectedRole),
    );
    try {
      final result = await showCupertinoModalPopup<String>(
        context: context,
        builder: (sheetContext) => PickerSheet(
          title: 'Select role',
          onDone: () => Navigator.pop(sheetContext, draftRole),
          child: CupertinoPicker(
            scrollController: controller,
            itemExtent: 40,
            onSelectedItemChanged: (index) => draftRole = roles[index],
            children: roles.map((role) => Center(child: Text(role))).toList(),
          ),
        ),
      );
      if (result != null && mounted) setState(() => _selectedRole = result);
    } finally {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return ListView(
                key: const ValueKey('portrait-layout'),
                padding: const EdgeInsets.all(16),
                children: [
                  const StudentDetailsSection(),
                  const SizedBox(height: 16),
                  ..._detailSections(),
                ],
              );
            }
            return Row(
              key: const ValueKey('landscape-layout'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: StudentDetailsSection(),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                    children: _detailSections(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _detailSections() => [
    const Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TitleSection(
            name: 'Oeschinen Lake',
            location: 'Kandersteg, Switzerland',
            starCount: 41,
          ),
          ImageSection(imagePath: 'assets/images/lake.jpg'),
        ],
      ),
    ),
    const SizedBox(height: 16),
    PickerSection(
      dateLabel: _dateLabel,
      selectedRole: _selectedRole,
      roles: roles,
      onMaterialDate: _selectMaterialDate,
      onCupertinoDate: _showCupertinoDatePicker,
      onRoleChanged: (role) {
        if (role != null) setState(() => _selectedRole = role);
      },
      onCupertinoRole: _showCupertinoRolePicker,
    ),
  ];
}

/// A reusable, immutable section retained from Lab 01.
class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/peigi_photo.jpg'),
            ),
            const SizedBox(height: 16),
            const Text(
              'PEIGI CHAI PEI YIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Student ID: BCS24090055',
              style: TextStyle(color: Color(0xFFE0E5FF)),
            ),
            const Divider(height: 28, color: Colors.white38),
            const Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '"Just a carefree little bear with a ridiculously big bank balance."',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  final String name;
  final String location;
  final int starCount;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(location, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Icon(Icons.star, color: Colors.red[500]),
        const SizedBox(width: 4),
        Text('$starCount'),
      ],
    ),
  );
}

class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        height: 170,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
  );
}

class PickerSection extends StatelessWidget {
  const PickerSection({
    super.key,
    required this.dateLabel,
    required this.selectedRole,
    required this.roles,
    required this.onMaterialDate,
    required this.onCupertinoDate,
    required this.onRoleChanged,
    required this.onCupertinoRole,
  });

  final String dateLabel;
  final String selectedRole;
  final List<String> roles;
  final VoidCallback onMaterialDate;
  final VoidCallback onCupertinoDate;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onCupertinoRole;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Interactive Pickers',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Material & Cupertino',
            style: TextStyle(color: Colors.indigo),
          ),
          const SizedBox(height: 16),
          Text(
            'Selected date: $dateLabel',
            key: const ValueKey('selected-date'),
          ),
          Text(
            'Selected role: $selectedRole',
            key: const ValueKey('selected-role'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                key: const ValueKey('material-date'),
                onPressed: onMaterialDate,
                icon: const Icon(Icons.calendar_month, size: 18),
                label: const Text('Material Date'),
              ),
              OutlinedButton.icon(
                key: const ValueKey('cupertino-date'),
                onPressed: onCupertinoDate,
                icon: const Icon(CupertinoIcons.calendar, size: 18),
                label: const Text('Cupertino Date'),
              ),
            ],
          ),
          const Divider(height: 28),
          const Text('Material Dropdown'),
          DropdownButton<String>(
            key: const ValueKey('material-role'),
            value: selectedRole,
            isExpanded: true,
            items: roles
                .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                .toList(),
            onChanged: onRoleChanged,
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            key: const ValueKey('cupertino-role'),
            onPressed: onCupertinoRole,
            icon: const Icon(CupertinoIcons.list_bullet, size: 18),
            label: const Text('Cupertino Role Wheel'),
          ),
        ],
      ),
    ),
  );
}

/// Both Cupertino pickers share a safe, bounded, dismissible bottom sheet.
class PickerSheet extends StatelessWidget {
  const PickerSheet({
    super.key,
    required this.title,
    required this.child,
    required this.onDone,
  });
  final String title;
  final Widget child;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: math.min(320, MediaQuery.sizeOf(context).height * .85),
    color: CupertinoColors.systemBackground.resolveFrom(context),
    child: SafeArea(
      top: false,
      child: Column(
        children: [
          SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(fontSize: 17)),
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onPressed: onDone,
                  child: const Text('Done', style: TextStyle(fontSize: 17)),
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    ),
  );
}
