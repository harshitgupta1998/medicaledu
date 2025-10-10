class ExamEntry {
  final String name;
  final DateTime date;

  ExamEntry({required this.name, required this.date});
}

class UserProfile {
  String name = '';
  String email = '';
  final List<ExamEntry> exams = [];

  UserProfile._privateConstructor();

  static final UserProfile instance = UserProfile._privateConstructor();

  void setBasicInfo({required String name, required String email, required String examName, required DateTime examDate}) {
    this.name = name;
    this.email = email;
    exams.clear();
    exams.add(ExamEntry(name: examName, date: examDate));
  }

  void addExam(String name, DateTime date) {
    exams.add(ExamEntry(name: name, date: date));
  }
}
