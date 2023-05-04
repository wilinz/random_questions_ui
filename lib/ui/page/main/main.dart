import 'package:flutter/material.dart';
import 'package:random_questions/data/model/get_questions/get_questions.dart';
import 'package:random_questions/ui/route.dart';

import '../../../data/network.dart';
import 'home/home.dart';
import 'profile/profile.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _MainPage();
  }
}

class _MainPage extends StatefulWidget {
  const _MainPage({Key? key}) : super(key: key);

  @override
  State<_MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  @override
  Widget build(BuildContext context) {
    return const RandomQuestionPage();
  }
}

class RandomQuestionPage extends StatefulWidget {
  const RandomQuestionPage({super.key});

  @override
  _RandomQuestionPageState createState() => _RandomQuestionPageState();
}

class _RandomQuestionPageState extends State<RandomQuestionPage> {
  String? _studentId; // Store the selected student ID
  List<String> _questions = []; // Store the imported questions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('随机选题系统'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'import_questions') {
                Navigator.pushNamed(context, AppRoute.importQuestionsPage);
              } else if (value == 'about') {
                Navigator.pushNamed(context, AppRoute.aboutPage);
              }
            },
            itemBuilder: (BuildContext context) {
              return const[
                 PopupMenuItem<String>(
                  value: 'import_questions',
                  child: Text('导入题目'),
                ),
                 PopupMenuItem<String>(
                  value: 'about',
                  child: Text('关于'),
                )
              ];
            },
          ),
        ],
      ),
      body: CustomScrollView(slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '输入学号：',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  decoration: const InputDecoration(
                      labelText: "学号",
                      hintText: "您的学号",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                  onChanged: (value) {
                    _studentId = value.trim();
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _selectRandomQuestion();
                  },
                  child: Text('根据学号随机选择题目'),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '或随机选择6道题目：',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _selectRandomQuestions();
                  },
                  child: const Text('随机选择6道题目'),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: _questions.length, (_, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SelectableText(
                    '${index + 1}. ${_questions[index]}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
            );
          })),
        )
      ]),
    );
  }

  Future<void> _selectRandomQuestion() async {
    if (_studentId == null || _studentId!.isEmpty) {
      _showError('请输入有效的学号。');
      return;
    }
    try {
      final dio = await AppNetwork.getDio();
      final resp = await dio
          .get("/question", queryParameters: {"student_id": _studentId});
      final questions = GetQuestions.fromJson(resp.data);
      setState(() {
        _questions = questions.data;
      });
      if (questions.code == 200) {
        _showMsg("抽取成功");
      } else {
        _showMsg("抽取失败：${questions.msg}");
      }
    } catch (e) {
      print(e);
      _showMsg("出错了：${e}");
    }
  }

  Future<void> _selectRandomQuestions() async {
    try {
      final dio = await AppNetwork.getDio();
      final resp =
          await dio.get("/questions/random", queryParameters: {"limit": 6});
      final questions = GetQuestions.fromJson(resp.data);
      if (resp.statusCode == 200) {
        if (questions.data.isEmpty) {
          _showMsg("题库内没有题目哦，请先导入");
        } else {
          setState(() {
            _questions = questions.data;
          });
          _showMsg("抽取成功");
        }
      } else {
        _showMsg("抽取失败：${questions.msg}");
      }
    } catch (e) {
      print(e);
      _showMsg("出错了：${e}");
    }
  }

  void _showError(String message) {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _showMsg(String message) {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
