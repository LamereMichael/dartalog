part of api;

class ItemTypeResource extends AResource {
  static final Logger _log = new Logger('ItemTypeResource');

  Logger _GetLogger() {
    return _log;
  }

  @ApiMethod(path: 'item_types/')
  Future<Map<String,ItemType>> getAll() async {
    try {
      Map<String,ItemType> output = await model.itemTypes.getAll();
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: 'item_types/{uuid}/')
  Future<ItemTypeResponse> get(String uuid) async {
    try {
      ItemTypeResponse output = new ItemTypeResponse();
      output.itemType = await model.itemTypes.get(uuid);
      output.fields = await model.fields.getAllForIDs(output.itemType.fields);
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'POST', path: 'item_types/')
  Future<VoidMessage> create(ItemType template) async {
    try {
      template.validate();
      await model.itemTypes.write(template);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'PUT', path: 'item_types/{uuid}/')
  Future<VoidMessage> update(String uuid, ItemType template) async {
    try {
      template.validate();
      String output = await model.itemTypes.write(template, uuid);
      //return new UuidResponse.fromUuid(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }
}