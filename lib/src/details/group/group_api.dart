import 'dart:convert';

import 'package:rent_checklist/src/common/experiments/features.dart';
import 'package:rent_checklist/src/common/network/api_utils.dart';
import 'package:rent_checklist/src/common/network/client.dart';
import 'package:rent_checklist/src/details/group/group_model.dart';

abstract interface class GroupApi {
  Future<Map<int, GroupModel>> getGroupsByIds(List<int> ids);
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
      queryParameters: {'ids': ids}
    ));
    final list = json.map((v) => GroupModel.fromJson(v)).toList();
    return {
      for (var v in list)
        v.id: v
    };
  }
}

class FakeGroupApi implements GroupApi {
  @override
  Future<Map<int, GroupModel>> getGroupsByIds(List<int> ids) async {
    final values = ["Ванная", "Кухня", "Гостиная", "Спальня"];
    final response = fakeResponseOf(
      'groups',
      // ignore: prefer_interpolation_to_compose_strings
      '[' + 
        ids.map((id) => 
          json.encode(
            GroupModel(
                title: values[id % values.length],
                id: id
            ).toJson()
          )
        ).join(',') +
      ']'
    );
    final listRaw = await requestAndDecodeToList(() => Future.value(response));
    final list = listRaw.map((v) => GroupModel.fromJson(v)).toList();
    return {for (var v in list) v.id: v};
  }
}
