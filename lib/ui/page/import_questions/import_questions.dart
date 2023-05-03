import 'package:flutter/material.dart';
import 'package:flutter_template/data/model/post_questions/questions.dart';
import 'package:flutter_template/data/network.dart';

class ImportQuestionsPage extends StatefulWidget {
  @override
  _ImportQuestionsPageState createState() => _ImportQuestionsPageState();
}

class _ImportQuestionsPageState extends State<ImportQuestionsPage> {
  final _formKey = GlobalKey<FormState>();
  String _adminPassword = "";
  List<String> _questionsToAdd = [];
  final _questionsTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _questionsTextController
      ..addListener(() {
        final text = _questionsTextController.text;
        final newText = text.replaceAll('\r\n', '\n');
        if (text != newText) {
          print("object");
          // 如果存在CRLF换行符，则替换为LF并重新设置文本
          _questionsTextController.value =
              _questionsTextController.value.copyWith(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
          );
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('导入题目'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '输入管理员密码:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "密码",
                    hintText: "请输入管理员密码",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '密码不能为空.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _adminPassword = value.trim();
                },
              ),
              SizedBox(height: 32.0),
              Text(
                '粘贴题目，每道题之间间隔3行:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: TextFormField(
                  controller: _questionsTextController,
                  maxLines: null,
                  // 允许多行输入
                  expands: true,
                  // 启用自动扩展
                  decoration: InputDecoration(
                      labelText: "题目",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: '每道题之间间隔3行'),
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '题目不能为空.';
                    }
                    _questionsToAdd = value
                        .trim()
                        .split('\n\n\n')
                        .map((e) => e.trim())
                        .toList();
                    if (_questionsToAdd.isEmpty) {
                      return '题目不能为空.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                // width: double.infinity,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 300),
                  child: ElevatedButton(
                    onPressed: () {
                      _importQuestions();
                    },
                    child: Text('导入题目'),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  void _importQuestions() {
    if (!_formKey.currentState!.validate()) {
      _showMsg("请检查输入");
      return;
    }

    if (_questionsToAdd.isNotEmpty) {
      List<String> questions = _questionsToAdd;

      int importedCount = questions.length;

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('确认导入'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('您确定要导入下列 ${importedCount.toString()} 道题目吗？\n'),
                    Text(questions.join('\n')),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('确认'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    postQuestions(_adminPassword, questions).then((value) {
                      _showMsg("导入成功");
                    }).onError((e, st) {
                      _showMsg("导入失败：${e}");
                    });
                  },
                ),
              ],
            );
          });
    }
  }

  Future<void> postQuestions(String password, List<String> questions) async {
    final dio = await AppNetwork.getDio();
    final data = Questions(password: password, questions: questions);
    final resp = await dio.post("/questions", data: data.toJson());
    if (resp.statusCode == 200) {
      _showMsg("导入成功");
    } else if (resp.statusCode == 401) {
      throw Exception("密码错误");
    } else {
      throw Exception("密码错误");
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
