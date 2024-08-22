class RemoteAppVersionInfo {
  String semver;
  bool isMandatory;
  DateTime releaseDate;
  String releaseNotes;

  RemoteAppVersionInfo({
    required this.semver,
    required this.isMandatory,
    required this.releaseDate,
    required this.releaseNotes,
  });

  factory RemoteAppVersionInfo.fromJson(Map<String, dynamic> json) {
    return RemoteAppVersionInfo(
      semver: json['semver'],
      isMandatory: json['is_mandatory'],
      releaseDate: DateTime.parse(json['release_date']),
      releaseNotes: json['release_notes'],
    );
  }
}
