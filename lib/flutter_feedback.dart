library in_app_feedback;

import 'package:flutter/material.dart';
import 'package:in_app_feedback/model/email_config.dart';
import 'package:in_app_feedback/model/feedback_data.dart';
import 'package:in_app_feedback/widget/feedback_bottom_sheet.dart';

import 'model/github_config.dart';

export 'package:in_app_feedback/flutter_feedback.dart';
export 'package:in_app_feedback/model/email_config.dart';
export 'package:in_app_feedback/model/feedback_data.dart';
export 'package:in_app_feedback/model/github_config.dart';

class FlutterFeedback {
  /// method accept email and github configuration
  /// check for EmailConfig class and GitHubConfig class for implementation
  static Future<void> showFeedbackBottomSheet({
    required BuildContext context,
    EmailConfig? emailConfig,
    GitHubConfig? gitHubConfig,
    required Function(FeedbackData) feedbackCallback,
    ShapeBorder? bottomSheetShape,
    Color? backgroundColor,
    bool isDismissible = false,
    String? title,
    String? subTitle,
  }) async {
    /// at least one config need to provide
    assert((emailConfig != null || gitHubConfig != null),
        'Either one or both configuration must be provided');

    /// Display bottom sheet with feedback content
    FeedbackData? result = await showModalBottomSheet(
      shape: bottomSheetShape,
      backgroundColor: backgroundColor,
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: FeedbackBottomSheet(
            emailConfig: emailConfig,
            gitHubConfig: gitHubConfig,
            title: title ?? 'Feedback & Issue',
            subTitle:
                subTitle ?? '"We would love to hear your feedback & issue',
            feedbackCallback: (feedback) {
              Navigator.pop(context, feedback);
            },
          ),
        );
      },
    );

    /// return feedback receive data back to the application
    if (result != null) feedbackCallback(result);
  }
}
