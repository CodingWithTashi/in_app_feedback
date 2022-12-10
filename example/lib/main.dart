import 'package:flutter/material.dart';
import 'package:flutter_app_feedback/flutter_feedback.dart';

import '.env.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Feedback Example'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              FlutterFeedback.showFeedback(
                context: context,
                // emailConfig: EmailConfig(
                //   toMailList: ['khakontas33@gmail.com'],
                //   fromMail: 'developer.kharag@gmail.com',
                //   sendGridToken: kSendGridKey,
                // ),
                gitHubConfig: GitHubConfig(
                  accessToken: kGithubToken,
                  githubUserName: 'codingwithtashi',
                  repositoryName: 'tibetan_proverb',
                ),
                feedbackCallback: (FeedbackData data) {
                  if (data.error == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Feedback Sent")));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(data.error!)));
                  }
                },
              );
            },
            child: const Text('Send Feedback')),
      ),
    );
  }
}
