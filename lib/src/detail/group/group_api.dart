import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:rent_checklist/src/common/experiments/features.dart';
import 'package:rent_checklist/src/common/network/api_utils.dart';
import 'package:rent_checklist/src/common/network/client.dart';
import 'package:rent_checklist/src/common/utils/extensions.dart';
import 'package:rent_checklist/src/detail/group/group_model.dart';

abstract interface class GroupApi {
  Future<List<GroupModel>> getGroups();
  Future<Map<int, GroupModel>> getGroupsByIds(List<int> ids);
  Future<GroupModel> createGroup(GroupModel group);
  Future<void> addItemToGroup(int flatId, int groupId, int itemId);
}

class GroupApiFactory {
  static GroupApi create() {
    return Features.useFakeApi.isEnabled ? FakeGroupApi() : NetworkGroupApi();
  }
}

class NetworkGroupApi implements GroupApi {
  @override
  Future<List<GroupModel>> getGroups() async {
    final json = await requestAndDecodeToList(() => kClient.get('groups'));
    return json.map((v) => GroupModel.fromJson(v)).toList();
  }

  @override
  Future<Map<int, GroupModel>> getGroupsByIds(List<int> ids) async {
    final json = await requestAndDecodeToList(() => kClient.get(
      'groups',
      queryParameters: {'ids': ids.join(',')}
    ));
    final list = json.map((v) => GroupModel.fromJson(v));
    return {
      for (var v in list)
        v.id: v
    };
  }

  @override
  Future<GroupModel> createGroup(GroupModel group) async {
    final json = await requestAndDecode(() => kClient.post(
      'groups',
      data: group.toJson()
    ));
    return GroupModel.fromJson(json);
  }

  @override
  Future<void> addItemToGroup(int flatId, int groupId, int itemId) async {
    await request(() => kClient.post(
      'groups/$groupId/items',
      data: {
        'flatId': flatId,
        'itemId': itemId,
      }
    ));
  }
}

class FakeGroupApi implements GroupApi {
  final _groups = ["Ванная", "Кухня", "Гостиная", "Спальня"];

  @override
  Future<List<GroupModel>> getGroups() async {
    final response = fakeResponseOf(
      'groups',
      jsonEncode(
        _groups.mapIndexed((i, v) =>
          GroupModel(
              title: v,
              id: i + 1
          )
        ).toList()
      )
    );
    final listRaw = await requestAndDecodeToList(() => Future.value(response));
    final list = listRaw.map((v) => GroupModel.fromJson(v)).toList();
    return list;
  }

  @override
  Future<Map<int, GroupModel>> getGroupsByIds(List<int> ids) async {
    final response = fakeResponseOf(
      'groups',
      // ignore: prefer_interpolation_to_compose_strings
      jsonEncode(
        ids.map((id) => 
          GroupModel(
              title: _groups[id % _groups.length],
              id: id
          )
        ).toList()
      )
    );
    final listRaw = await requestAndDecodeToList(() => Future.value(response));
    final list = listRaw.map((v) => GroupModel.fromJson(v)).toList();
    return {for (var v in list) v.id: v};
  }

  @override
  Future<GroupModel> createGroup(GroupModel group) async {
    final response = fakeResponseOf(
      'groups',
      jsonEncode(group.toJson().also((v) => v..['id'] = _groups.length + 1))
    );
    final json = await requestAndDecode(() => Future.value(response));
    return GroupModel.fromJson(json);
  }

  @override
  Future<void> addItemToGroup(int flatId, int groupId, int itemId) async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }
}
