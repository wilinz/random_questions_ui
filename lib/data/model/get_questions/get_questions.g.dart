// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_questions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetQuestions _$GetQuestionsFromJson(Map<String, dynamic> json) => GetQuestions(
      code: json['code'] as int? ?? 0,
      data:
          (json['data'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      msg: json['msg'] as String? ?? '',
    );

Map<String, dynamic> _$GetQuestionsToJson(GetQuestions instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
    };
