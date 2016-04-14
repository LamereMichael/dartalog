// This is a generated file (see the discoveryapis_generator project).

library dartalog.dartalog.D0_1;

import 'dart:core' as core;
import 'dart:collection' as collection;
import 'dart:async' as async;
import 'dart:convert' as convert;

import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as commons;
import 'package:http/http.dart' as http;

export 'package:_discoveryapis_commons/_discoveryapis_commons.dart' show
    ApiRequestError, DetailedApiRequestError;

const core.String USER_AGENT = 'dart-api-client dartalog/0.1';

/** Dartalog REST API */
class DartalogApi {

  final commons.ApiRequester _requester;

  FieldsResourceApi get fields => new FieldsResourceApi(_requester);
  ItemsResourceApi get items => new ItemsResourceApi(_requester);
  TemplatesResourceApi get templates => new TemplatesResourceApi(_requester);

  DartalogApi(http.Client client, {core.String rootUrl: "http://localhost:8080/", core.String servicePath: "dartalog/0.1/"}) :
      _requester = new commons.ApiRequester(client, rootUrl, servicePath, USER_AGENT);
}


class FieldsResourceApi {
  final commons.ApiRequester _requester;

  FieldsResourceApi(commons.ApiRequester client) : 
      _requester = client;

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future create(Field request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _downloadOptions = null;

    _url = 'fields/';

    var _response = _requester.request(_url,
                                       "POST",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

  /**
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [Field].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<Field> get(core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _url = 'fields/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new Field.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * Completes with a [MapOfField].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<MapOfField> getAll() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'fields/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new MapOfField.fromJson(data));
  }

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future update(Field request, core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }
    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _downloadOptions = null;

    _url = 'fields/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

}


class ItemsResourceApi {
  final commons.ApiRequester _requester;

  ItemsResourceApi(commons.ApiRequester client) : 
      _requester = client;

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future create(Item request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _downloadOptions = null;

    _url = 'items/';

    var _response = _requester.request(_url,
                                       "POST",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

  /**
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [ItemResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ItemResponse> get(core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _url = 'items/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new ItemResponse.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * Completes with a [MapOfItem].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<MapOfItem> getAll() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'items/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new MapOfItem.fromJson(data));
  }

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future update(Item request, core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }
    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _downloadOptions = null;

    _url = 'items/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

}


class TemplatesResourceApi {
  final commons.ApiRequester _requester;

  TemplatesResourceApi(commons.ApiRequester client) : 
      _requester = client;

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future create(Template request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _downloadOptions = null;

    _url = 'presets/';

    var _response = _requester.request(_url,
                                       "POST",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

  /**
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [TemplateResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<TemplateResponse> get(core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _url = 'presets/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new TemplateResponse.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * Completes with a [MapOfTemplate].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<MapOfTemplate> getAll() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'presets/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new MapOfTemplate.fromJson(data));
  }

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future update(Template request, core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }
    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _downloadOptions = null;

    _url = 'presets/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

}



class Field {
  core.String format;
  core.String name;
  core.String type;

  Field();

  Field.fromJson(core.Map _json) {
    if (_json.containsKey("format")) {
      format = _json["format"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("type")) {
      type = _json["type"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (format != null) {
      _json["format"] = format;
    }
    if (name != null) {
      _json["name"] = name;
    }
    if (type != null) {
      _json["type"] = type;
    }
    return _json;
  }
}

class Item {
  core.Map<core.String, core.String> fieldValues;
  core.String template;

  Item();

  Item.fromJson(core.Map _json) {
    if (_json.containsKey("fieldValues")) {
      fieldValues = _json["fieldValues"];
    }
    if (_json.containsKey("template")) {
      template = _json["template"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (fieldValues != null) {
      _json["fieldValues"] = fieldValues;
    }
    if (template != null) {
      _json["template"] = template;
    }
    return _json;
  }
}

class ItemResponse {
  core.Map<core.String, Field> fields;
  Item item;
  Template template;

  ItemResponse();

  ItemResponse.fromJson(core.Map _json) {
    if (_json.containsKey("fields")) {
      fields = commons.mapMap(_json["fields"], (item) => new Field.fromJson(item));
    }
    if (_json.containsKey("item")) {
      item = new Item.fromJson(_json["item"]);
    }
    if (_json.containsKey("template")) {
      template = new Template.fromJson(_json["template"]);
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (fields != null) {
      _json["fields"] = commons.mapMap(fields, (item) => (item).toJson());
    }
    if (item != null) {
      _json["item"] = (item).toJson();
    }
    if (template != null) {
      _json["template"] = (template).toJson();
    }
    return _json;
  }
}

class MapOfField
    extends collection.MapBase<core.String, Field> {
  final core.Map _innerMap = {};

  MapOfField();

  MapOfField.fromJson(core.Map _json) {
    _json.forEach((core.String key, value) {
      this[key] = new Field.fromJson(value);
    });
  }

  core.Map toJson() {
    var _json = {};
    this.forEach((core.String key, value) {
      _json[key] = (value).toJson();
    });
    return _json;
  }

  Field operator [](core.Object key)
      => _innerMap[key];

  operator []=(core.String key, Field value) {
    _innerMap[key] = value;
  }

  void clear() {
    _innerMap.clear();
  }

  core.Iterable<core.String> get keys => _innerMap.keys;

  Field remove(core.Object key) => _innerMap.remove(key);
}

class MapOfItem
    extends collection.MapBase<core.String, Item> {
  final core.Map _innerMap = {};

  MapOfItem();

  MapOfItem.fromJson(core.Map _json) {
    _json.forEach((core.String key, value) {
      this[key] = new Item.fromJson(value);
    });
  }

  core.Map toJson() {
    var _json = {};
    this.forEach((core.String key, value) {
      _json[key] = (value).toJson();
    });
    return _json;
  }

  Item operator [](core.Object key)
      => _innerMap[key];

  operator []=(core.String key, Item value) {
    _innerMap[key] = value;
  }

  void clear() {
    _innerMap.clear();
  }

  core.Iterable<core.String> get keys => _innerMap.keys;

  Item remove(core.Object key) => _innerMap.remove(key);
}

class MapOfTemplate
    extends collection.MapBase<core.String, Template> {
  final core.Map _innerMap = {};

  MapOfTemplate();

  MapOfTemplate.fromJson(core.Map _json) {
    _json.forEach((core.String key, value) {
      this[key] = new Template.fromJson(value);
    });
  }

  core.Map toJson() {
    var _json = {};
    this.forEach((core.String key, value) {
      _json[key] = (value).toJson();
    });
    return _json;
  }

  Template operator [](core.Object key)
      => _innerMap[key];

  operator []=(core.String key, Template value) {
    _innerMap[key] = value;
  }

  void clear() {
    _innerMap.clear();
  }

  core.Iterable<core.String> get keys => _innerMap.keys;

  Template remove(core.Object key) => _innerMap.remove(key);
}

class Template {
  core.List<core.String> fields;
  core.String name;

  Template();

  Template.fromJson(core.Map _json) {
    if (_json.containsKey("fields")) {
      fields = _json["fields"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (fields != null) {
      _json["fields"] = fields;
    }
    if (name != null) {
      _json["name"] = name;
    }
    return _json;
  }
}

class TemplateResponse {
  core.Map<core.String, Field> fields;
  Template template;

  TemplateResponse();

  TemplateResponse.fromJson(core.Map _json) {
    if (_json.containsKey("fields")) {
      fields = commons.mapMap(_json["fields"], (item) => new Field.fromJson(item));
    }
    if (_json.containsKey("template")) {
      template = new Template.fromJson(_json["template"]);
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (fields != null) {
      _json["fields"] = commons.mapMap(fields, (item) => (item).toJson());
    }
    if (template != null) {
      _json["template"] = (template).toJson();
    }
    return _json;
  }
}
