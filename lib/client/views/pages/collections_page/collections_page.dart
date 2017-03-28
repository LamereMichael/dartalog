import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/client/api/api.dart' as api;
import 'package:logging/logging.dart';
import '../src/a_page.dart';
import 'package:dartalog/client/views/controls/common_controls.dart';
import 'package:angular2/router.dart';

@Component(
    selector: 'collections-page',
    directives: const [materialDirectives, commonControls],
    providers: const [materialProviders],
    styleUrls: const ["../../shared.css", "collections_page.css"],
    templateUrl: 'collections_page.html')
class CollectionsPage extends APage implements OnInit, OnDestroy {
  static final Logger _log = new Logger("CollectionsPage");

  @ViewChild("editForm")
  NgForm form;

  api.IdNamePair selectedUser;

  bool userAuthorized = false;

  List<IdNamePair> items = <IdNamePair>[];

  IdNamePair selectedItem;
  api.Collection model = new api.Collection();

  bool editVisible = false;

  @Output()
  EventEmitter<bool> visibleChange = new EventEmitter<bool>();

  StreamSubscription<PageActions> _pageActionSubscription;

  final PageControlService _pageControl;

  final ApiService _api;

  CollectionsPage(
      this._pageControl, this._api, AuthenticationService _auth, Router router)
      : super(_pageControl, _auth, router) {
    _pageControl.setPageTitle("Collections");
    _pageControl.setAvailablePageActions(
        <PageActions>[PageActions.Refresh, PageActions.Add]);
    _pageActionSubscription =
        _pageControl.pageActionRequested.listen(onPageActionRequested);
  }
  @override
  Logger get loggerImpl => _log;

  bool get isNewItem => selectedItem == null;

  bool get noItemsFound => items.isEmpty;

  List<api.IdNamePair> users = <api.IdNamePair>[];

  @override
  void ngOnDestroy() {
    _pageActionSubscription.cancel();
    _pageControl.reset();
  }

  void authorizationChanged(bool value) {
    this.userAuthorized = value;
    if (value) {
      refresh();
    } else {
      clear();
    }
  }

  @override
  void ngOnInit() {
    //refresh();
  }

  Future<Null> selectItem(IdNamePair item) async {
    await performApiCall(() async {
      reset();
      if (item != null) {
        model = await _api.collections.getByUuid(item.uuid);
      }
      users = await _api.users.getAllIdsAndNames();
      selectedItem = item;
      editVisible = true;
    });
  }

  void onPageActionRequested(PageActions action) {
    try {
      switch (action) {
        case PageActions.Refresh:
          this.refresh();
          break;
        case PageActions.Add:
          selectItem(null);
          break;
        default:
          throw new Exception(
              action.toString() + " not implemented for this page");
      }
    } catch (e, st) {
      handleException(e, st);
    }
  }

  Future<Null> onSubmit() async {
    await performApiCall(() async {
      if (isNewItem) {
        await _api.collections.create(model);
      } else {
        await _api.collections.update(model, selectedItem.uuid);
      }
      editVisible = false;
      await this.refresh();
    }, form: form);
  }

  Future<Null> refresh() async {
    await performApiCall(() async {
      editVisible = false;
      items.clear();
      final ListOfIdNamePair data = await _api.collections.getAllIdsAndNames();
      items.addAll(data);
    });
  }

  void clear() {
    reset();
    items.clear();
  }

  void reset() {
    model = new api.Collection();
    model.curatorUuids = <String>[];
    model.browserUuids = <String>[];
    selectedItem = null;
    selectedUser = null;
    showDeleteConfirmation = false;
    errorMessage = "";
  }

  void removeCurator(String userUuid) {
    if (model != null && model.curatorUuids.contains(userUuid)) {
      model.curatorUuids.remove(userUuid);
    }
  }

  void removeBrowser(String userUuid) {
    if (model != null && model.browserUuids.contains(userUuid)) {
      model.browserUuids.remove(userUuid);
    }
  }

  void addCurator() {
    if (selectedUser != null && this.model != null) {
      if (this.model.curatorUuids == null) this.model.curatorUuids = <String>[];
      if (!this.model.curatorUuids.contains(selectedUser.uuid)) {
        this.model.curatorUuids.add(selectedUser.uuid);
      }
    }
  }

  void addBrowser() {
    if (selectedUser != null && this.model != null) {
      if (this.model.browserUuids == null) this.model.browserUuids = <String>[];
      if (!this.model.browserUuids.contains(selectedUser.uuid)) {
        this.model.browserUuids.add(selectedUser.uuid);
      }
    }
  }

  Future<Null> deleteClicked() async {
    showDeleteConfirmation = true;
  }

  bool showDeleteConfirmation = false;

  Future<Null> deleteConfirmClicked() async {
    await performApiCall(() async {
      await _api.collections.delete(selectedItem.uuid);
      editVisible = false;
      await refresh();
    });
  }
}
