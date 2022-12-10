import 'package:flutter/material.dart';
import 'package:flutter_app_feedback/model/email_config.dart';
import 'package:flutter_app_feedback/model/github_config.dart';

import '../feedback_date.dart';
import '../helper/send_grid_helper.dart';

typedef OnFeedbackCallback = void Function(FeedbackData);

class FeedbackBottomSheet extends StatelessWidget {
  final OnFeedbackCallback feedbackCallback;
  final EmailConfig? emailConfig;
  final GitHubConfig? gitHubConfig;
  const FeedbackBottomSheet({
    Key? key,
    required this.feedbackCallback,
    this.emailConfig,
    this.gitHubConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Feedback & Issue",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "We would love to help you with your feedback/issue",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text(
                'Enter title',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              label: Text(
                'Enter description',
              ),
            ),
            //maxLines: 4,
            minLines: null,
            maxLines: 5,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  //GitHubHelper.createIssue(gitHubConfig: gitHubConfig!);
                  SendGridHelper.sendMail(emailConfig: emailConfig!)
                      .then((result) {
                    feedbackCallback(result);
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Send'),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  //GitHubHelper.createIssue(gitHubConfig: gitHubConfig!);
                  SendGridHelper.sendMail(emailConfig: emailConfig!)
                      .then((result) {
                    feedbackCallback(result);
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Cancel'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
