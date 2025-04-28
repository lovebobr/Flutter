import 'dart:convert';

import 'package:flutter/foundation.dart';

class QuizDTO {
  QuizDTO({
    required this.code,
    required this.title,
    required this.answer,
    this.multiple = false,
    this.answers = const [],
  });

  factory QuizDTO.fromMap(Map<String, dynamic> map) {
    return QuizDTO(
      code: map['code'] as String,
      title: map['title'] as String,
      answer: map['answer'] as String,
      multiple: map['multiple'] as bool,
      answers: List<QuizDTOAnswer>.from(
        (map['answers'] as List<dynamic>).map<QuizDTOAnswer>(
          (x) => QuizDTOAnswer.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory QuizDTO.fromJson(String source) =>
      QuizDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  final String code;
  final String title;
  final String answer;
  final bool multiple;
  final List<QuizDTOAnswer> answers;

  QuizDTO copyWith({
    String? code,
    String? title,
    String? answer,
    bool? multiple,
    List<QuizDTOAnswer>? answers,
  }) {
    return QuizDTO(
      code: code ?? this.code,
      title: title ?? this.title,
      answer: answer ?? this.answer,
      multiple: multiple ?? this.multiple,
      answers: answers ?? this.answers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'title': title,
      'answer': answer,
      'multiple': multiple,
      'answers': answers.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'QuizDTO(code: $code, title: $title, answer: $answer, multiple: $multiple, answers: $answers)';
  }

  @override
  bool operator ==(covariant QuizDTO other) {
    if (identical(this, other)) return true;

    return other.code == code &&
        other.title == title &&
        other.answer == answer &&
        other.multiple == multiple &&
        listEquals(other.answers, answers);
  }

  @override
  int get hashCode {
    return code.hashCode ^
        title.hashCode ^
        answer.hashCode ^
        multiple.hashCode ^
        answers.hashCode;
  }
}

class QuizDTOAnswer {
  QuizDTOAnswer({
    required this.code,
    required this.title,
  });

  factory QuizDTOAnswer.fromMap(Map<String, dynamic> map) {
    return QuizDTOAnswer(
      code: map['code'] as String,
      title: map['title'] as String,
    );
  }

  factory QuizDTOAnswer.fromJson(String source) =>
      QuizDTOAnswer.fromMap(json.decode(source) as Map<String, dynamic>);

  final String code;
  final String title;

  QuizDTOAnswer copyWith({
    String? code,
    String? title,
  }) {
    return QuizDTOAnswer(
      code: code ?? this.code,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'title': title,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'QuizDTOAnswer(code: $code, title: $title)';

  @override
  bool operator ==(covariant QuizDTOAnswer other) {
    if (identical(this, other)) return true;

    return other.code == code && other.title == title;
  }

  @override
  int get hashCode => code.hashCode ^ title.hashCode;
}
