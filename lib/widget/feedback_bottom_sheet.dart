import 'package:flutter/material.dart';
import 'package:in_app_feedback/model/email_config.dart';
import 'package:in_app_feedback/model/github_config.dart';

import '../helper/github_helper.dart';
import '../helper/send_grid_helper.dart';
import '../model/feedback_data.dart';

typedef OnFeedbackCallback = void Function(FeedbackData);

class FeedbackBottomSheet extends StatefulWidget {
  /// on feedback callback listener
  final OnFeedbackCallback feedbackCallback;

  /// email configuration
  final EmailConfig? emailConfig;

  /// GitHub issue configuration
  final GitHubConfig? gitHubConfig;

  /// Bottom Sheet Content Widget
  const FeedbackBottomSheet({
    Key? key,
    required this.feedbackCallback,
    this.emailConfig,
    this.gitHubConfig,
  }) : super(key: key);

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  /// title controller for feedback
  late TextEditingController titleController;

  /// description controller for feedback
  late TextEditingController descriptionController;
  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxHeight = 10.0;
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _feedbackLabel(),
          const SizedBox(height: sizedBoxHeight),
          _feedbackSubLabel(),
          _feedbackTitleField(),
          const SizedBox(height: sizedBoxHeight),
          _feedbackDescriptionField(),
          const SizedBox(height: sizedBoxHeight),
          _feedbackActionButton(),
        ],
      ),
    );
  }

  Widget _feedbackLabel() => Text(
        "Feedback & Issue",
        style: Theme.of(context).textTheme.titleLarge,
      );

  Widget _feedbackTitleField() => TextFormField(
        controller: titleController,
        decoration: const InputDecoration(
          label: Text(
            'Enter title',
          ),
        ),
      );

  Widget _feedbackDescriptionField() => TextFormField(
        controller: descriptionController,
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
      );

  Widget _feedbackSubLabel() => Text(
        "We would love to hear your feedback/issue",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      );

  Widget _feedbackActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => _sendFeedback(),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('Send'),
          ),
        ),
        OutlinedButton(
          onPressed: () => widget.feedbackCallback(FeedbackData(
            status: 499,
            error: "Feedback cancelled",
          )),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('Cancel'),
          ),
        ),
      ],
    );
  }

  Future<void> _sendFeedback() async {
    if (isValidData()) {
      if (widget.emailConfig != null && widget.gitHubConfig != null) {
        FeedbackData mailData = await SendGridHelper.sendMail(
          emailConfig: widget.emailConfig!,
          title: titleController.text,
          description: descriptionController.text,
        );

        await GitHubHelper.createIssue(
          gitHubConfig: widget.gitHubConfig!,
          title: titleController.text,
          description: descriptionController.text,
        );
        widget.feedbackCallback(mailData);
      } else {
        if (widget.emailConfig != null) {
          SendGridHelper.sendMail(
            emailConfig: widget.emailConfig!,
            title: titleController.text,
            description: descriptionController.text,
          ).then((result) => widget.feedbackCallback(result));
        }
        if (widget.gitHubConfig != null) {
          GitHubHelper.createIssue(
            gitHubConfig: widget.gitHubConfig!,
            title: titleController.text,
            description: descriptionController.text,
          ).then((result) => widget.feedbackCallback(result));
        }
      }
    }
  }

  bool isValidData() =>
      titleController.text.isNotEmpty && descriptionController.text.isNotEmpty;
}
