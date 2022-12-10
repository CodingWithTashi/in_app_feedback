library flutter_app_feedback;

import 'package:flutter/material.dart';
import 'package:flutter_app_feedback/feedback_data.dart';
import 'package:flutter_app_feedback/model/email_config.dart';
import 'package:flutter_app_feedback/widget/feedback_bottom_sheet.dart';

import 'model/github_config.dart';

export 'package:flutter_app_feedback/feedback_data.dart';
export 'package:flutter_app_feedback/flutter_feedback.dart';
export 'package:flutter_app_feedback/model/email_config.dart';
export 'package:flutter_app_feedback/model/github_config.dart';

class FlutterFeedback {
  static void showFeedback({
    required BuildContext context,
    EmailConfig? emailConfig,
    GitHubConfig? gitHubConfig,
    required Function(FeedbackData) feedbackCallback,
  }) async {
    assert(emailConfig != null || gitHubConfig != null);

    /// Display bottom sheet with feedback content
    FeedbackData result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: FeedbackBottomSheet(
            emailConfig: emailConfig,
            gitHubConfig: gitHubConfig,
            feedbackCallback: (feedback) {
              Navigator.pop(context, feedback);
            },
          ),
        );
      },
    );

    /// return feedback receive data back to the application
    feedbackCallback(result);
  }
}
