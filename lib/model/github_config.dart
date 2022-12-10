class GitHubConfig {
  /// GitHub access token generated token from GitHub account
  /// follow this link to see how to generate one
  final String accessToken;

  /// GitHub Username for the repository
  final String githubUserName;

  /// Github Repository name
  final String repositoryName;

  GitHubConfig(
      {required this.accessToken,
      required this.githubUserName,
      required this.repositoryName});
}
