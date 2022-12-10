class GitHubConfig {
  /// GitHub access token generated token from GitHub account, it can be private or
  /// public. Issue can raise with both using access token
  /// follow this link to see how to generate one
  ///https://github.com/settings/tokens?type=beta
  final String _accessToken;

  /// GitHub Username for the repository
  final String _gitHubUserName;

  /// Github Repository name
  final String _repositoryName;

  GitHubConfig({
    required String accessToken,
    required String gitHubUserName,
    required String repositoryName,
  })  : _accessToken = accessToken,
        _gitHubUserName = gitHubUserName,
        _repositoryName = repositoryName;

  String get repositoryName => _repositoryName;

  String get gitHubUserName => _gitHubUserName;

  String get accessToken => _accessToken;
}
