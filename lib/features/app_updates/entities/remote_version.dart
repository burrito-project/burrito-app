class RemoteAppVersionInfo {
  String semver;
  bool isMandatory;
  DateTime releaseDate;
  String releaseNotes;
  String? bannerUrl;

  RemoteAppVersionInfo({
    required this.semver,
    required this.isMandatory,
    required this.releaseDate,
    required this.releaseNotes,
    required this.bannerUrl,
  });

  factory RemoteAppVersionInfo.fromJson(Map<String, dynamic> json) {
    return RemoteAppVersionInfo(
      semver: json['semver'],
      isMandatory: json['is_mandatory'],
      releaseDate: DateTime.parse(json['release_date']),
      releaseNotes: json['release_notes'],
      bannerUrl: json['banner_url'],
    );
  }
}
