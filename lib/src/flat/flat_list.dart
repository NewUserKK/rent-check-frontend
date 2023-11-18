import 'package:flutter/material.dart';
import 'package:rent_checklist/src/flat/flat_api.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';

class FlatList extends StatefulWidget {
  const FlatList({super.key});

  @override
  State<StatefulWidget> createState() => _FlatListState();
}

class _FlatListState extends State<FlatList> {
  late Future<List<FlatModel>> flats;

  final _api = FlatApi();

  @override
  void initState() {
    super.initState();
    flats = _api.getFlats();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: flats,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildList(snapshot.data as List<FlatModel>);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildList(List<FlatModel> flats) {
    return ListView.builder(
      itemCount: flats.length,
      itemBuilder: (context, index) {
        final flat = flats[index];
        return ListTile(
          title: Text(flat.title),
          subtitle: Text(flat.description),
        );
      },
    );
  }
}
