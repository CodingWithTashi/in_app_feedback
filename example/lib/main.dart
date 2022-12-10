import 'package:flutter/material.dart';
import 'package:flutter_app_feedback/flutter_feedback.dart';

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
                emailConfig: EmailConfig(
                  toMail: 'developer.kharag@gmail.com',
                  sendGridToken: 'send_grid_key',
                ),
                gitHubConfig: GitHubConfig(
                  accessToken: 'access_token',
                  githubUserName: 'github_user_name',
                  repositoryName: 'github_repo_name',
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
