// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('user_admin_page.html')
library dartalog.client.pages.field_admin_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/iron_flex_layout.dart';

import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;

/// A Polymer `<field-admin-page>` element.
@PolymerRegister('field-admin-page')
class FieldAdminPage extends APage with ARefreshablePage, ACollectionPage {
  static final Logger _log = new Logger("FieldAdminPage");
  Logger get loggerImpl => _log;


  @property
  List<IdNamePair> fields = new List<IdNamePair>();

  String currentId = "";
  @property Field currentField = new Field();

  /// Constructor used to create instance of MainApp.
  FieldAdminPage.created() : super.created("Field Admin");

  @Property(notify: true) Iterable get FIELD_TYPE_KEYS => dartalog.FIELD_TYPES.keys;
  @reflectable String getFieldType(String key) => dartalog.FIELD_TYPES[key];

  PaperDialog get editDialog =>  $['editDialog'];

  Future activateInternal(Map args) async {
    await this.refresh();
  }

  @override
  void clearValidation() {
    $['output_field_error'].text = "";
    super.clearValidation();
  }

  @reflectable
  Future refresh() async {
    try {
      this.reset();
      clear("fields");

      API.ListOfIdNamePair data = await api.fields.getAllIdsAndNames();

      for(API.IdNamePair pair  in data) {
        add("fields", new IdNamePair.copy(pair));
      }
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }


  @reflectable
  void reset() {
    clearValidation();
    currentId = "";
    set('currentField', new Field());
  }

  showModal(event, [_]) {
    //String uuid = target.dataset['uuid'];
  }

  @override
  Future newItem() async {
    try {
      this.reset();
      editDialog.open();
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

  @reflectable
  fieldClicked(event, [_]) async {
    try {
      String id = event.target.dataset["id"];
      if(id==null)
        return;

      API.Field field = await api.fields.getById(id);

      if(field==null)
        throw new Exception("Selected field not found");

      currentId = id;

      set("currentField", new Field.copy(field));

      editDialog.open();
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

  @reflectable
  validateField(event, [_]) {
    _log.info("Validating");
  }

  @reflectable
  cancelClicked(event, [_]) {
    editDialog.cancel();
    this.reset();
  }

  @reflectable
  saveClicked(event, [_]) async {
    try {
      API.Field field = new API.Field();
      currentField.copyTo(field);
      if (isNullOrWhitespace(this.currentId)) {
        await this.api.fields.create(field);
      } else {
        await this.api.fields.update(field, this.currentId);
      }

      refresh();
      editDialog.close();
      showMessage("Field saved");
    } on API.DetailedApiRequestError catch  ( e, st) {
      try {
        handleApiError(e, generalErrorField: "output_field_error");
      } catch (e, st) {
        _log.severe(e, st);
        this.handleException(e,st);
      }
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    } finally {
    }
  }

}