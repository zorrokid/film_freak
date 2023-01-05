import 'package:realm/realm.dart';

part 'schemas.g.dart';

@RealmModel()
class _Item {
  @MapTo('_id')
  @PrimaryKey()
  late ObjectId id;
  bool isComplete = false;
  late String summary;
  @MapTo('owner_id')
  late String ownerId;
  late int? priority;
}

@RealmModel()
class _Release {
  @MapTo('_id')
  @PrimaryKey()
  late ObjectId id;
  late String barcode;
  late String title;
  @MapTo('owner_id')
  late String ownerId;
}
