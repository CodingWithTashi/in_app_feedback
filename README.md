# flutter_app_feedback
flutter_app_feedback is a simple feedback package that let user to provide feedback and raise issue in application
## Demo

## Features

* Create issue in GitHub
* Send feedback via mail
* Add record in firebase [WIP]

## Getting started   
```dart
flutter_app_feedback: ^0.0.1

```

## Usage

```dart
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
```

## Additional information

Feel free to fork and send pull request

If you have any questions, feedback or ideas, feel free to [create an
issue](https://github.com/CodingWithTashi/flutter_app_feedback/issues/new). If you enjoy this
project, I'd appreciate your [🌟 on GitHub](https://github.com/CodingWithTashi/flutter_app_feedback/).

## You can also buy me a cup of coffee
<a href="https://www.buymeacoffee.com/codingwithtashi"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" width=200px></a>
