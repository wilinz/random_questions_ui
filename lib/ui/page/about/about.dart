import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('images/my.png'),
            ),
            SizedBox(height: 20),
            Text(
              "随机抽题系统",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '作者：wilinz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildLinkButton(
              context,
              'https://github.com/wilinz/',
              'GitHub主页',
            ),
            SizedBox(height: 10),
            _buildLinkButton(
              context,
              'https://github.com/wilinz/random_questions_ui',
              '本项目前端GitHub地址',
            ),
            SizedBox(height: 10),
            _buildLinkButton(
              context,
              'https://github.com/wilinz/cpp-random-questions',
              '本项目后端GitHub地址',
            ),
            SizedBox(height: 10),
            _buildLinkButton(
              context,
              'https://home.wilinz.com:9992/share/idbaSO_E',
              'App下载地址',
            ),
            SizedBox(height: 10),
            _buildLinkButton(
              context,
              'https://home.wilinz.com:9996',
              '网页版地址',
            ),
          ],
        ),
      ),
    );
  }

  // 创建可点击跳转的按钮
  Widget _buildLinkButton(BuildContext context, String url, String label) {
    return ElevatedButton(
      onPressed: () {
        _launchURL(context, url);
      },
      child: Text(label),
    );
  }

  // 启动浏览器并跳转到指定URL
  void _launchURL(BuildContext context, String url) async {
    launcher.launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
