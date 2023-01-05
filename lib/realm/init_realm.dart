import 'package:flutter_todo/viewmodels/item_viewmodel.dart';
import 'package:realm/realm.dart';
import 'package:flutter_todo/realm/schemas.dart';

Realm initRealm(User currentUser) {
  Configuration config = Configuration.flexibleSync(
    currentUser,
    [Item.schema, Release.schema],
  );
  Realm realm = Realm(config);

  // TODO: Releases will not be later user specific but in another db and not synced to device
  // Only those releases will be synced which user has collection items of

  // server-side rules ensure user only downloads own items
  final userReleaseSub = realm.subscriptions.findByName('getUserReleases');
  if (userReleaseSub == null) {
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(realm.all<Release>(), name: 'getUserReleases');
    });
  }

  final userItemSub = realm.subscriptions.findByName('getUserItems');
  final userItemSubWithPriority =
      realm.subscriptions.findByName('getUserItemsWithPriority');
  if (userItemSubWithPriority == null) {
    realm.subscriptions.update((mutableSubscriptions) {
      if (userItemSub != null) {
        mutableSubscriptions.remove(userItemSub);
        // server-side rules ensure user only downloads own items
        //mutableSubscriptions.add(realm.all<Item>(), name: 'getUserItems');
        mutableSubscriptions.add(
            realm.query<Item>(
              'priority <= \$0',
              [PriorityLevel.high],
            ),
            name: 'getUserItemsWithPriority');
      }
    });
  }
  return realm;
}
