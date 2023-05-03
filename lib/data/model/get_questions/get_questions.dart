import 'package:json_annotation/json_annotation.dart';

part 'get_questions.g.dart';

@JsonSerializable(explicitToJson: true)
class GetQuestions {
  GetQuestions(
      {required this.code,
      required this.data,
      required this.msg});

  @JsonKey(name: "code", defaultValue: 0)
  int code;
  @JsonKey(name: "data", defaultValue: [])
  List<String> data;
  @JsonKey(name: "msg", defaultValue: "")
  String msg;

  factory GetQuestions.fromJson(Map<String, dynamic> json) => _$GetQuestionsFromJson(json);

  Map<String, dynamic> toJson() => _$GetQuestionsToJson(this);
}


