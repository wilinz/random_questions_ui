// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Questions _$QuestionsFromJson(Map<String, dynamic> json) => Questions(
      password: json['password'] as String? ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$QuestionsToJson(Questions instance) => <String, dynamic>{
      'password': instance.password,
      'questions': instance.questions,
    };
