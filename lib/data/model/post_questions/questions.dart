import 'package:json_annotation/json_annotation.dart';

part 'questions.g.dart';

@JsonSerializable(explicitToJson: true)
class Questions {
  Questions(
      {required this.password,
      required this.questions});

  @JsonKey(name: "password", defaultValue: "")
  String password;
  @JsonKey(name: "questions", defaultValue: [])
  List<String> questions;

  factory Questions.fromJson(Map<String, dynamic> json) => _$QuestionsFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionsToJson(this);
}


