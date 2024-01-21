import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/common/arch/view_model_widget_state.dart';
import 'package:rent_checklist/src/common/utils/extensions.dart';
import 'package:rent_checklist/src/common/widgets/load_utils.dart';
import 'package:rent_checklist/src/common/widgets/loader.dart';
import 'package:rent_checklist/src/detail/flat_detail_screen.dart';
import 'package:rent_checklist/src/flat/flats_state.dart';
import 'package:rent_checklist/src/flat/flats_view_model.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';
import 'package:rent_checklist/src/res/strings.dart';

class FlatList extends StatefulWidget {
  const FlatList({super.key});

  @override
  State<StatefulWidget> createState() => _FlatListState();
}

class _FlatListState extends ViewModelWidgetState<
  FlatList,
  FlatsState,
  FlatsEvent,
  FlatsViewModel
> {
  @override
  void initState() {
    super.initState();
    withProviderOnFrame<FlatsViewModel>(context, (viewModel) => viewModel.load());
  }

  @override
  void handleEvent(FlatsEvent event) {}

  @override
  Widget render(FlatsState state) => switch (state) {
    FlatsStateLoading _ => const Loader(),
    FlatsStateLoaded state => _buildList(state.flats),
    FlatsStateError state => Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          child: Text(
            state.error.toString(),
            textAlign: TextAlign.center,
          )
      ),
    ),
  };

  Widget _buildList(Map<int, FlatModel> flats) {
    final flatList = flats.values.toList();

    if (flatList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            Strings.flatListEmptyMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: flats.length,
      itemBuilder: (context, index) {
        final flat = flatList[index];

        final title = flat.title.takeIfNotBlank() ?? flat.address;

        var isThreeLine = false;
        String? subtitle;
        if (flat.title?.isNotEmpty == true && flat.description?.isNotEmpty == true) {
          isThreeLine = true;
          subtitle = "${flat.address}\n${flat.description}";
        } else if (flat.title?.isNotEmpty == true) {
          subtitle = flat.address;
        } else if (flat.description?.isNotEmpty == true) {
          subtitle = flat.description;
        }

        return ListTile(
          title: Text(title),
          subtitle: subtitle?.let((it) => Text(it)),
          isThreeLine: isThreeLine,
          onTap: () => _navigateToFlatDetail(context, flat),
          onLongPress: () => _openContextMenu(title, flat),
        );
      },
    );
  }

  void _openContextMenu(String title, FlatModel flat) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Center(child: Text(title)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
            ),
            child: Column(
              children: [
                TextButton(
                  onPressed: () => _deleteFlat(flat),
                  child: _contextMenuButton(Strings.flatContextMenuDelete)
                ),
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _contextMenuButton(String text) {
    return Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ]
    );
  }

  void _navigateToFlatDetail(BuildContext context, FlatModel flat) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => FlatDetailScreen(flat: flat))
    );
  }

  Future<void> _deleteFlat(FlatModel flat) async {
    await Provider.of<FlatsViewModel>(context, listen: false).deleteFlat(flat);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
