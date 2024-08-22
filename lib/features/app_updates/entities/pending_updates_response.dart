import 'package:burrito/features/app_updates/entities/remote_version.dart';

class PendingUpdatesResponse {
  bool mustUpdate;
  List<RemoteAppVersionInfo> versions;

  PendingUpdatesResponse({
    required this.mustUpdate,
    required this.versions,
  });
  RemoteAppVersionInfo? get firstNotMandatory {
    for (final version in versions) {
      if (!version.isMandatory) return version;
    }
    return null;
  }

  factory PendingUpdatesResponse.fromJson(Map<String, dynamic> json) {
    return PendingUpdatesResponse(
      mustUpdate: json['must_update'],
      versions: List<RemoteAppVersionInfo>.from(
        json['versions'].map((x) => RemoteAppVersionInfo.fromJson(x)),
      ),
    );
  }
}
