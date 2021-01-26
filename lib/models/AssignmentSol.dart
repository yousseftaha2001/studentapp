import 'dart:convert';

class SolutionModel {
  final String studentName;
  final String notes;
  final DateTime hendItTime;
  final String attachments;
  SolutionModel({
    this.studentName,
    this.notes,
    this.hendItTime,
    this.attachments,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentName': studentName,
      'notes': notes,
      'hendItTime': hendItTime?.millisecondsSinceEpoch,
      'attachments': attachments,
    };
  }

  factory SolutionModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SolutionModel(
      studentName: map['studentName'],
      notes: map['notes'],
      hendItTime: DateTime.fromMillisecondsSinceEpoch(map['hendItTime']),
      attachments: map['attachments'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SolutionModel.fromJson(String source) => SolutionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SolutionModel(studentName: $studentName, notes: $notes, hendItTime: $hendItTime, attachments: $attachments)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SolutionModel &&
      o.studentName == studentName &&
      o.notes == notes &&
      o.hendItTime == hendItTime &&
      o.attachments == attachments;
  }

  @override
  int get hashCode {
    return studentName.hashCode ^
      notes.hashCode ^
      hendItTime.hashCode ^
      attachments.hashCode;
  }
}
