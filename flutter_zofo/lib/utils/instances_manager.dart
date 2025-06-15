// Project imports:
import 'package:flutter_zofo/contracts/late_initializable.dart';

class InstancesManager {
  static final InstancesManager _singleton = InstancesManager._internal();

  factory InstancesManager() {
    return _singleton;
  }

  InstancesManager._internal();

  final _pool = <String, dynamic>{};
  final _initTasks = <Function>[];

  InstancesManager register<T>(T instance, String name) {
    if (_pool.containsKey(name)) {
      throw Exception('Instance with name {$name} already exists.');
    }
    _pool[name] = instance;
    return this;
  }

  InstancesManager registerAll<T>(Map<String, T> instances, {bool catchException = false}) {
    for (var entry in instances.entries) {
      if (catchException) {
        try {
          register<T>(entry.value, entry.key);
        } catch (e) {
          /// Handle exception
        }
      } else {
        register<T>(entry.value, entry.key);
      }
    }
    return this;
  }

  InstancesManager registerBuilder<T>(T Function() instanceBuilder, String name) {
    if (_pool.containsKey(name)) {
      throw Exception('Instance with name {$name} already exists.');
    }
    _pool[name] = instanceBuilder();
    return this;
  }

  InstancesManager registerBuilders<T>(Map<String, T Function()> instanceBuilders, {bool catchException = false}) {
    for (var entry in instanceBuilders.entries) {
      if (catchException) {
        try {
          registerBuilder<T>(entry.value, entry.key);
        } catch (e) {
          /// Handle exception
        }
      } else {
        registerBuilder<T>(entry.value, entry.key);
      }
    }
    return this;
  }

  Future<InstancesManager> initializeAllAsync() async {
    for (var keyName in _pool.keys) {
      final instance = _pool[keyName];
      if (instance is LateInitializable) {
        await instance.initAsync();
      }
      if (instance is Future) {
        _pool[keyName] = await instance;
      }
    }
    return this;
  }

  T? get<T>(String name) {
    if (_pool.containsKey(name)) {
      return _pool[name] as T;
    }
    return null;
  }

  InstancesManager remove(String name) {
    if (_pool.containsKey(name)) {
      _pool.remove(name);
    }
    return this;
  }

  InstancesManager pushInitAction(Function action) {
    _initTasks.add(action);
    return this;
  }

  Future<void> initAsync() async {
    for (var action in _initTasks) {
      await action();
    }
  }
}

class DefaultInstances {
  static const appInfo = 'appInfo+';
  static const config = 'config+';
  static const connectivity = 'connectivity+';
  static const database = 'database+';
  static const dataCache = 'dataCache+';
  static const packageInfo = 'packageInfo+';
  static const theme = 'theme+';
  static const urlHandler = 'urlHandler+';
}

late final InstancesManager instances;
