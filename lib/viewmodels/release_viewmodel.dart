import 'package:realm/realm.dart';

import '../realm/schemas.dart';

class ReleaseViewmodel {
  final ObjectId id;
  final String barcode;
  final String title;
  final Realm realm;
  final Release release;

  ReleaseViewmodel._(
      this.realm, this.release, this.id, this.barcode, this.title);
  ReleaseViewmodel(Realm realm, Release release)
      : this._(realm, release, release.id, release.barcode, release.title);

  static ReleaseViewmodel create(Realm realm, Release release) {
    final itemInRealm = realm.write<Release>(() => realm.add<Release>(release));
    return ReleaseViewmodel(realm, itemInRealm);
  }
}
