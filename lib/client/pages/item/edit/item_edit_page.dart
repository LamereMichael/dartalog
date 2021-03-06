// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_edit_page.html")
library dartalog.client.pages.item_edit_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/controls/item_edit/item_edit_control.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;
import 'package:dartalog/client/controls/auth_wrapper/auth_wrapper_control.dart';

@PolymerRegister('item-edit-page')
class ItemEditPage extends APage with ASaveablePage {
  static final Logger _log = new Logger("ItemEditPage");
  Logger get loggerImpl => _log;

  /// Constructor used to create instance of MainApp.
  ItemEditPage.created() : super.created("Item Edit");

  String currentItemId;

  ItemEditControl get itemEditControl => $['itemEditPageItemEditControl'];

  AuthWrapperControl get authWrapper => this.querySelector("auth-wrapper-control");


  attached() {
    super.attached();
    _loadPage();
  }

  Future _loadPage() async {
    bool authed = await authWrapper.evaluatePageAuthentication();
    this.showSaveButton = authed;
    this.evaluatePage();
  }


  @override
  Future save() async {
    String id = await itemEditControl.save();
    if(!isNullOrWhitespace(id)) {
      showMessage("Item saved");
      window.location.hash = "item/${id}";
    }
  }
}
