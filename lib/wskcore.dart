// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The wsk_material library.
///
/// This is an awesome library. More dartdocs go here.
library wskcore;

import 'dart:html' as html;
import 'dart:collection';
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

part "src/WskComponentHandler.dart";
part "src/WskConfig.dart";
part "src/WskComponent.dart";

/// !!! Postponed !!!! - waiting for mature mirror system...
///
/// Component-Annotation
/// Sample:
///   @WskCssClass("wsk-button")
///   class MaterialButton { ... }
///
///class WskCssClass {  final String name; const WskCssClass(this.name); }
