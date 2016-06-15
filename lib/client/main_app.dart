// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('main_app.html')
library dartalog.client.main_app;

import 'dart:async';
import 'dart:html';

import 'package:dartalog/tools.dart';
import 'package:option/option.dart';
import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as commons;
import 'package:dartalog/client/api/dartalog.dart' as api;
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/paper_toast_queue/paper_toast_queue.dart';
import 'package:dartalog/client/controls/user_auth/user_auth_control.dart';
import 'package:dartalog/client/pages/field_admin/field_admin_page.dart';
import 'package:dartalog/client/pages/item/item_page.dart';
import 'package:dartalog/client/pages/item_add/item_add_page.dart';
import 'package:dartalog/client/pages/item_browse/item_browse_page.dart';
import 'package:dartalog/client/pages/item_edit/item_edit_page.dart';
import 'package:dartalog/client/pages/collections/collections_page.dart';
import 'package:dartalog/client/pages/checkout/checkout_page.dart';
import 'package:dartalog/client/pages/item_import/item_import_page.dart';
import 'package:dartalog/client/pages/user_admin/user_admin_page.dart';
import 'package:dartalog/client/pages/item_type_admin/item_type_admin_page.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/browser_logging_handlers.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/iron_pages.dart';
import 'package:polymer_elements/paper_drawer_panel.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_badge.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_toast.dart';
import 'package:polymer_elements/paper_progress.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:route_hierarchical/client.dart';
import 'package:web_components/web_components.dart';
import 'package:path/path.dart';
import 'package:dartalog/client/controls/controls.dart';

/// Uses [PaperInput]
@PolymerRegister('main-app')
class MainApp extends PolymerElement {
  static final Logger _log = new Logger("MainApp");

  @property
  String visiblePage = "item_browse";

  @property
  int cartCount = 0;
  @property
  bool cartEmpty = true;

  @property
  bool userLoggedIn = false;
  @property
  User get currentUserProperty => currentUser.getOrElse(() => new User());
  set currentUserProperty(User user) {
    if(user==null)
      this.currentUser = new None();
    else
      this.currentUser = new Some(user);
  }
  Option<User> currentUser = new None();

  @property
  bool userIsAdmin = false;
  @property
  bool userCanCheckout = false;
  @property
  bool userCanAdd = false;
  @property
  bool userCanBorrow = false;

  @property
  bool loading = true;

  @property
  bool showRefresh = false;
  @property
  bool showSearch = true; // True initially so that it can be found on page load
  @property
  bool showAdd = false;
  @property
  bool showEdit = false;
  @property
  bool showSave = false;
  @property
  bool showDelete = false;

  @property
  bool showBack = false;


  final Router router = new Router(useFragment: true);

  static api.DartalogApi _api;

  @Property(notify: true)
  APage currentPage = null;

  /// Constructor used to create instance of MainApp.
  MainApp.created() : super.created() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogPrintHandler());

    _api = new api.DartalogApi(
        new DartalogHttpClient(),
        rootUrl: getServerRoot(),
        servicePath: "api/dartalog/0.1/");
    // Set up the routes for all the pages.

    router.root
      ..addRoute(
          name: BROWSE_ROUTE_NAME,
          path: "items",
          defaultRoute: true,
          enter: enterRoute)
      ..addRoute(
          name: SEARCH_ROUTE_NAME,
          path: "search/:${ROUTE_ARG_SEARCH_QUERY_NAME}",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: ITEM_VIEW_ROUTE_NAME,
          path: "view/:${ROUTE_ARG_ITEM_ID_NAME}",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: ITEM_EDIT_ROUTE_NAME,
          path: "edit/:${ROUTE_ARG_ITEM_ID_NAME}",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: ITEM_ADD_ROUTE_NAME,
          path: "new/:${ROUTE_ARG_ITEM_TYPE_ID_NAME}",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: ITEM_IMPORT_ROUTE_NAME,
          path: "import",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: "field_admin",
          path: "fields",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: "collections",
          path: "collections",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: "item_type_admin",
          path: "item_types",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: "user_admin",
          path: "users",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: CHECKOUT_ROUTE_NAME,
          path: "checkout",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: "logging_output",
          path: "logging_output",
          defaultRoute: false,
          enter: enterRoute);

    startApp();
  }

  @reflectable
  Future searchKeypress(event, [_]) async {
    if(event.original.charCode==13) {
      if (currentPage is ASearchablePage) {
        ASearchablePage page = currentPage as ASearchablePage;
        page.search(event.target.value);
      }
    }
  }

  Future startApp() async {
    await evaluateAuthentication();
    router.listen();
  }

  void addToCart(ItemCopy itemCopy) {
    CheckoutPage cp = $['checkout'];
    cp.addToCart(itemCopy);
    refreshCartInfo();
  }

  void refreshCartInfo() {
    CheckoutPage cp = $['checkout'];
    set("cartCount", cp.cart.length);
    set("cartEmpty", cp.cart.length == 0);
  }

  @reflectable
  void cartClicked(event, [_]) {
    this.activateRoute(CHECKOUT_ROUTE_PATH);
  }

  void stopLoading() {
    set("loading", false);
  }

  void startLoading() {
    set("loading", true);
  }

  Future promptForAuthentication() async {
    UserAuthControl ele = $['userAuthElement'];
    ele.activateDialog();
  }

  setUserObject(User user) {
    if(user==null) {
      set("currentUserProperty.name", "");
      set("currentUserProperty", null);
      AControl.currentUserStatic = this.currentUser;
    } else {
      set("currentUserProperty.name", user.name);
      set("currentUserProperty", user);
      AControl.currentUserStatic = this.currentUser;
    }
  }

  Future clearAuthentication() async {
    setUserObject(null);
    await clearAuthCache();
    DartalogHttpClient.setAuthKey("");
  }

  @reflectable
  void clearSearch(event, [_]) {
    set("searchText", "");
    this.refreshClicked(event,[_]);
  }

  Future evaluateAuthentication() async {
    bool authed = false;
    try {
      await DartalogHttpClient.primer();

      api.User apiUser = await _api.users.getMe();

      setUserObject(new User.copy(apiUser));

      set("userCanCheckout", userHasPrivilege(USER_PRIVILEGE_CHECKOUT));
      set("userIsAdmin", userHasPrivilege(USER_PRIVILEGE_ADMIN));
      set("userCanAdd", userHasPrivilege(USER_PRIVILEGE_CREATE));
      set("userCanBorrow", userHasPrivilege(USER_PRIVILEGE_BORROW));

      authed = true;

      if(userLoggedIn!=authed&&this.currentPage!=null) {
        this.currentPage.reActivate();
      }

    } on api.DetailedApiRequestError catch (e, st) {
      if (e.status >= 400 && e.status < 500) {
        // Not authenticated, nothing to see here
        await clearAuthentication();
      } else {
        _log.severe("evaluateAuthentication", e, st);
        handleException(e, st);
      }
    } catch (e, st) {
      _log.severe("evaluateAuthentication", e, st);
      handleException(e, st);
    }

    set("userLoggedIn", authed);

  }

  bool userHasPrivilege(String privilege) {
    return this.currentUser.any((User user) {
      return user.privileges.contains(privilege)||user.privileges.contains(USER_PRIVILEGE_ADMIN);
    });
  }

  PaperDrawerPanel get drawerPanel => $["drawerPanel"];
  FieldAdminPage get fieldAdmin => $['field_admin'];
//  TemplateAdminPage get templateAdmin=> $['item_type_admin'];
  ItemAddPage get itemAddAdmin => $['item_add'];
//  ItemBrowsePage get itemBrowse=> $['browse'];
//  ItemPage get itemPage=> $['item'];

  ItemTypeAdminPage get itemTypeAdmin => $['item_type_admin'];

  activateRoute(String route, {Map<String, String> arguments}) {
    if (arguments == null) arguments = new Map<String, String>();
    router.go(route, arguments);
  }

  @reflectable
  toggleDrawerClicked(event, [_]) {
    PaperDrawerPanel pdp = $['drawerPanel'];
    pdp.togglePanel();
  }

  @reflectable
  addClicked(event, [_]) async {
    if (currentPage is ACollectionPage) {
      ACollectionPage page = currentPage as ACollectionPage;
      page.newItem();
    }
  }

  @reflectable
  backClicked(event, [_]) async {
    if (currentPage is ASubPage) {
      ASubPage page = currentPage as ASubPage;
      page.goBack();
    }
  }

  @reflectable
  deleteClicked(event, [_]) async {
    if (currentPage is ADeletablePage) {
      dynamic page = currentPage;
      page.delete();
    }
  }

  @reflectable
  drawerItemClicked(event, [_]) async {
    try {
      Element ele = getParentElement(event.target, "paper-item");
      if (ele != null) {
        String route = ele.dataset["route"];
        if (route == "log_in") {
          promptForAuthentication();
        } else {
          activateRoute(route);
        }
      }
    } catch (e, st) {
      _log.severe("drawerItemClicked", e, st);
      handleException(e, st);
    }
  }

  @reflectable
  editClicked(event, [_]) async {
    if (currentPage is AEditablePage) {
      AEditablePage page = currentPage as AEditablePage;
      page.edit();
    }
  }

  Future enterRoute(RouteEvent e) async {
    try {
      startLoading();

      String pageName;
      set("showBack", (router.activePath.length > 1));

      switch(e.route.name) {
        case SEARCH_ROUTE_NAME:
          pageName = BROWSE_ROUTE_NAME;
          break;
        default:
          pageName = e.route.name;
          break;
      }
      dynamic page = $[pageName];
      set("visiblePage", pageName);

      if (page == null) {
        throw new Exception("Page not found: ${this.visiblePage}");
      }

      if (!(page is APage)) {
        throw new Exception(
            "Unknown element type: ${page.runtimeType.toString()}");
      }

      set("currentPage", page);
      evaluatePage();
      await this.currentPage.activate(_api, e.parameters);
      evaluatePage();
    } catch (e, st) {
      window.alert(e.toString());
    } finally {
      stopLoading();
    }
  }

  void evaluatePage() {
    set("currentPage.title", currentPage.title);

    set("showBack", currentPage is ASubPage);

    set("showRefresh", currentPage is ARefreshablePage);

    set("showAdd", currentPage is ACollectionPage);

    set("showSearch", currentPage is ASearchablePage);

    set("showDelete", currentPage is ADeletablePage);

    set("showEdit", currentPage is AEditablePage);

    set(
        "showSave",
        currentPage is ASaveablePage &&
            (currentPage as ASaveablePage).showSaveButton);
  }

  @property
  String searchText = "";

  void handleException(e, st) {
    if(e is api.DetailedApiRequestError) {
      api.DetailedApiRequestError dare = e as api.DetailedApiRequestError;
      StringBuffer message = new StringBuffer();
      message.writeln(dare.message);
      for(commons.ApiRequestErrorDetail det in e.errors) {
        message.write(det.location);
        message.write(": ");
        message.writeln(det.message);
      }
      showMessage(message.toString(), "error", st.toString());
    } else {
      showMessage(e.toString(), "error", st.toString());
    }
  }

  @reflectable
  refreshClicked(event, [_]) async {
    startLoading();
    try {
      if (currentPage is ARefreshablePage) {
        dynamic page = currentPage;
        await page.refresh();
      }
    } finally {
      stopLoading();
    }
  }

  void routeChanged() {
    if (visiblePage is! String) return;
    router.go("field_admin", {});
  }

  @reflectable
  saveClicked(event, [_]) async {
    if (currentPage is ASaveablePage) {
      ASaveablePage page = currentPage as ASaveablePage;
      page.save();
    }
  }

  void showMessage(String message, [String severity, String details]) {
    PaperToast toastElement = $['global_toast'];

    if (toastElement == null) return;

    if (toastElement.opened) toastElement.opened = false;

    new Timer(new Duration(milliseconds: 300), () {
      if (severity == "error") {
        toastElement.classes.add("error");
      } else {
        toastElement.classes.remove("error");
      }

      if (isNullOrWhitespace(details))
        toastElement.text = "$message";
      else
        toastElement.innerHtml =
            "<details><summary>${message}</summary><pre>${details}</pre></details>";

      toastElement.show();
    });
  }

  // Optional lifecycle methods - uncomment if needed.

//  /// Called when an instance of main-app is inserted into the DOM.
//  attached() {
//    super.attached();
//  }

//  /// Called when an instance of main-app is removed from the DOM.
//  detached() {
//    super.detached();
//  }

//  /// Called when an attribute (such as a class) of an instance of
//  /// main-app is added, changed, or removed.
//  attributeChanged(String name, String oldValue, String newValue) {
//    super.attributeChanged(name, oldValue, newValue);
//  }

//  /// Called when main-app has been fully prepared (Shadow DOM created,
//  /// property observers set up, event listeners attached).
//  ready() {
//  }
}
