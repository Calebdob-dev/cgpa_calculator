import 'package:flutter/material.dart';

class CgpaScreen extends StatefulWidget {
  const CgpaScreen({super.key});

  @override
  State<CgpaScreen> createState() => _CgpaScreenState();
}

class _CgpaScreenState extends State<CgpaScreen> {
  final TextEditingController courseController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

  String selectedGrade = 'A';

  List<Map<String, dynamic>> courses = [];

  int totalUnits = 0;
  int totalGradePoints = 0;
  double cgpa = 0.0;

  int getGradePoint(String grade) {
    switch (grade) {
      case 'A':
        return 5;
      case 'B':
        return 4;
      case 'C':
        return 3;
      case 'D':
        return 2;
      case 'E':
        return 1;
      case 'F':
        return 0;
      default:
        return 0;
    }
  }

  void addCourse() {
    String courseName = courseController.text.trim();
    int? courseUnit = int.tryParse(unitController.text.trim());

    if (courseName.isEmpty || courseUnit == null || courseUnit <= 0) {
      return;
    }

    int gradePoint = getGradePoint(selectedGrade);
    int coursePoint = courseUnit * gradePoint;

    setState(() {
      courses.add({
        'name': courseName,
        'unit': courseUnit,
        'grade': selectedGrade,
        'points': coursePoint,
      });

      totalUnits += courseUnit;
      totalGradePoints += coursePoint;
      cgpa = totalGradePoints / totalUnits;

      courseController.clear();
      unitController.clear();
      selectedGrade = 'A';
    });
  }

  void resetAll() {
    setState(() {
      courses.clear();
      totalUnits = 0;
      totalGradePoints = 0;
      cgpa = 0.0;

      courseController.clear();
      unitController.clear();
      selectedGrade = 'A';
    });
  }

  void deleteCourse(int index) {
    setState(() {
      totalUnits -= courses[index]['unit'] as int;
      totalGradePoints -= courses[index]['points'] as int;

      courses.removeAt(index);

      if (totalUnits == 0) {
        cgpa = 0.0;
      } else {
        cgpa = totalGradePoints / totalUnits;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
            'Student CGPA Calculator',
            style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 35),

            TextField(
              controller: unitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Course Unit',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 35),

            DropdownButtonFormField<String>(
              value: selectedGrade,
              decoration: const InputDecoration(
                labelText: 'Select Grade',
                border: OutlineInputBorder(),
              ),
              items: ['A', 'B', 'C', 'D', 'E', 'F']
                .map(
                  (grade) => DropdownMenuItem(
                value: grade,
                child: Text(grade),
                ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedGrade = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: addCourse,
              child: const Text(
                'Add Course',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),

            const SizedBox(height: 70),

            if (courses.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];

                  return Card(
                    child: ListTile(
                      title: Text(course['name']),
                      subtitle: Text(
                        '${course['unit']} Units • Grade ${course['grade']}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteCourse(index),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 20),

            Text(
              'Total Units: $totalUnits',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              'Total Grade Points: $totalGradePoints',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              'CGPA: ${cgpa.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: resetAll,
              child: const Text(
                'Reset All',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}