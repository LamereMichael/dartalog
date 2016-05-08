// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_add_page.html")
library dartalog.client.pages.item_add_page;

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
import 'package:polymer_elements/iron_pages.dart';

import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/client.dart';

import '../../api/dartalog.dart' as API;

/// A Polymer `<template-admin-page>` element.
@PolymerRegister('item-add-page')
class ItemAddPage extends APage with ARefreshablePage  {
  static final Logger _log = new Logger("ItemAddPage");

  IronPages get pages => $['item_add_pages'];

  /// Constructor used to create instance of MainApp.
  ItemAddPage.created() : super.created("Item Add");

//  @observable Map itemTypes = new ObservableMap();
//
  @property String searchQuery;
  @property String templateId;



//
//  @observable Map<String,API.Field> itemTypeFields = new ObservableMap<String,API.Field>();
//  @observable Map<String,String> fieldValues = new ObservableMap<String,String>();

  void activateInternal(Map args) {
    this.refresh();
  }

  @override
  Future refresh() async {
    //this.clear();
    await loadTemplates();
  }

  Future loadTemplates() async {
    try {
//      itemTypes.clear();
//      itemTypeFields.clear();
//      API.MapOfItemType data = await api.itemTypes.getAll();
//      itemTypes.addAll(data);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  showModal(event, detail, target) {
    String uuid = target.dataset['uuid'];
  }


  templateClicked(event, detail, target) async {
//    try {
//      String id = target.dataset["id"];
//      API.ItemType template = await api.
//
//      this.itemTypes[id];
//      this.fieldValues.clear();
//      for(var field in template.fields) {
//        this.fieldValues[field] = ""; // SOme day, default values!
//      }
//      this.itemTypeFields.addAll(template.fields);
//      this.templateId = id;
//      pages.selected = "field_input";
//    } catch(e,st) {
//      _log.severe(e, st);
//      window.alert(e.toString());
//    }
  }

  saveClicked(event, detail, target) {
//    try {
//      if(this.templateId==null) {
//        throw new Exception("Template not selected");
//      }
//      API.Item item = new API.Item();
//      item.template = this.templateId;
//
//      item.fieldValues = this.fieldValues;
//
//      api.items.create(item);
//    } catch(e,st) {
//      _log.severe(e, st);
//      window.alert(e.toString());
//    }
  }

  @reflectable
  Future searchClicked(event, [_]) async {
    API.SearchResults results = await api.import.search("amazon", this.searchQuery);
    results.results
  }

  validateField(event, detail, target) {
    _log.info("Validating");
  }

  backClicked(event, detail, target) async {
    this.templateId = "";
    pages.selected = "type_select";
  }


}