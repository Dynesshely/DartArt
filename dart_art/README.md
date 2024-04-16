![banner](https://raw.githubusercontent.com/Dynesshely/DartArt/main/art/banner.png)

# Overview

`DartArt` is a collection of useful dart utils for all dart developers.

# Features

- `BinarySize` class, to convert bytes to human readable format

## Usage

1. Add the dependency to your `pubspec.yaml` file  
   Recommend to use command line:

   With Flutter
   ```shell
   flutter pub add dart_art
   ```

   With Dart
   ```shell
   dart pub add dart_art
   ```

2. Import library

   ```dart
   import 'package:dart_art/dart_art.dart';
   ```

3. Use like examples

   `BinarySize`:

   ```dart
   var size = BinarySize()..bytesCount = 1024;

   print(size.displayText); // 1.00 KB
   ```

# Contributors

[![Contributors](https://contrib.rocks/image?repo=Dynesshely/DartArt)](https://github.com/Dynesshely/DartArt/graphs/contributors)

# Star History

[![Star History Chart](https://starchart.cc/Dynesshely/DartArt.svg?variant=adaptive)](https://starchart.cc/Dynesshely/DartArt)
