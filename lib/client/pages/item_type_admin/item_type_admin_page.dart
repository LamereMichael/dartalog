// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_type_admin_page.html")
library dartalog.client.pages.template_admin_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/iron_flex_layout.dart';

import 'package:dartalog/global.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/controls/combo_list/combo_list_control.dart';
import 'package:dartalog/client/controls/auth_wrapper/auth_wrapper_control.dart';
import 'package:dartalog/client/api/api.dart' as API;

@PolymerRegister('item-type-admin-page')
class ItemTypeAdminPage extends APage with ARefreshablePage, ACollectionPage {
  static final Logger _log = new Logger("ItemTypeAdminPage");
  Logger get loggerImpl => _log;

  ItemTypeAdminPage.created() : super.created("Item Types");

  @Property(notify: true)
  List<IdNamePair> itemTypes = new List<IdNamePair>();

  @Property(notify: true)
  List<IdNamePair> fields = new List<IdNamePair>();

  @property
  ItemType currentItemType = new ItemType();
  String currentItemId = "";

  @property
  String selectedField = "";

  PaperDialog get editDialog => this.querySelector('#editDialog');

  @override
  void setGeneralErrorMessage(String message) => set("errorMessage", message);
  @Property(notify: true)
  String errorMessage = "";

  @property
  bool userHasAccess = false;

  AuthWrapperControl get authWrapper =>
      this.querySelector("auth-wrapper-control");

  attached() {
    super.attached();
    refresh();
  }

  Future refresh() async {
    await handleApiExceptions(() async {
      try {
        this.startLoading();

        bool authed = await authWrapper.evaluatePageAuthentication();
        this.showRefreshButton = authed;
        this.showAddButton = authed;
        if (!authed) return;

        this.reset();

        await _loadAvailableFields();
        await _loadItemTypes();
      } finally {
        this.stopLoading();
        this.evaluatePage();
      }
    });
  }

  Future _loadAvailableFields() async {
    clear("fields");

    API.ListOfIdNamePair data = await API.item.fields.getAllIdsAndNames();

    set("fields", IdNamePair.copyList(data));
  }

  Future _loadItemTypes() async {
    clear("itemTypes");
    API.ListOfIdNamePair data = await API.item.itemTypes.getAllIdsAndNames();
    set("itemTypes", IdNamePair.copyList(data));
  }

  void reset() {
    set("currentItemType", new ItemType());
    currentItemId = "";
    clearValidation();
  }

  @override
  Future newItem() async {
    try {
      this.reset();
      openDialog(editDialog);
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e, st);
    }
  }

  @reflectable
  cancelClicked(event, [_]) {
    editDialog.cancel(event);
    this.reset();
  }

  @reflectable
  itemTypeClicked(event, [_]) async {
    await handleApiExceptions(() async {
      String id = event.target.dataset["id"];
      API.ItemType itemType = await API.item.itemTypes.getById(id);

      if (itemType == null) return;

      currentItemId = id;
      set("currentItemType", new ItemType.copy(itemType));
      openDialog(editDialog);
    });
  }

  @reflectable
  saveClicked(event, [_]) async {
    await handleApiExceptions(() async {
      API.ItemType itemType = new API.ItemType();
      this.currentItemType.copyTo(itemType);

      if (StringTools.isNullOrWhitespace(this.currentItemId)) {
        await API.item.itemTypes.create(itemType);
      } else {
        await API.item.itemTypes.update(itemType, this.currentItemId);
      }
      this.refresh();
      this.editDialog.close();
    });
  }
}
