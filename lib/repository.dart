import 'package:bftracker/addEntry.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class TrackersRepository extends ChangeNotifier {
  final List<Tracker> _list = [];
  late LazyBox box;

  TrackersRepository() {
    _startRepository();
  }

  void _startRepository() async {
    await _openBox();
    await _readTrackers();
  }

  _openBox() async {
    Hive.registerAdapter(TrackerHiveAdapter());
    box = await Hive.openLazyBox<Tracker>('trackers');
  }

  _readTrackers() {
    box.keys.forEach((tracker) async {
      final t = await box.get(tracker);
      _list.add(t);
      notifyListeners();
    });
  }

  addToTracker() {
    notifyListeners();
  }

  removeFromTracker(Tracker tracker) {
    notifyListeners();
  }
}

class TrackerHiveAdapter extends TypeAdapter<Tracker> {
  @override
  Tracker read(BinaryReader reader) {
    return Tracker(type: Trackers.values[reader.readInt()]);
  }

  @override
  final typeId = 0;

  @override
  void write(BinaryWriter writer, Tracker obj) {
    writer.writeInt(obj.type.index);
  }
}
