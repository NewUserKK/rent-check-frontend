import 'dart:convert';

import 'package:rent_checklist/src/common/experiments/features.dart';
import 'package:rent_checklist/src/common/network/api_utils.dart';
import 'package:rent_checklist/src/common/network/client.dart';
import 'package:rent_checklist/src/common/utils/extensions.dart';
import 'package:rent_checklist/src/details/group/group_model.dart';

abstract interface class GroupApi {
  Future<Map<int, GroupModel>> getGroupsByIds(List<int> ids);
  Future<GroupModel> createGroup(GroupModel group);
}

class GroupApiFactory {
  static GroupApi create() {
    return Features.useFakeApi.isEnabled ? FakeGroupApi() : NetworkGroupApi();
  }
}

class NetworkGroupApi implements GroupApi {
  @override
  Future<Map<int, GroupModel>> getGroupsByIds(List<int> ids) async {
    final json = await requestAndDecodeToList(() => kClient.get(
      'groups',
      queryParameters: {'ids': ids.join(',')}
    ));
    final list = json.map((v) => GroupModel.fromJson(v)).toList();
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
}

class FakeGroupApi implements GroupApi {
  final _groups = ["Ванная", "Кухня", "Гостиная", "Спальня"];

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
    print(response.data);
    final json = await requestAndDecode(() => Future.value(response));
    return GroupModel.fromJson(json);
  }
}
