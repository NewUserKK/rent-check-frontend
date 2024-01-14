import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/common/arch/view_model_widget_state.dart';
import 'package:rent_checklist/src/common/widgets/load_utils.dart';
import 'package:rent_checklist/src/common/widgets/loader.dart';
import 'package:rent_checklist/src/common/widgets/snackbar.dart';
import 'package:rent_checklist/src/detail/flat_detail_view_model.dart';
import 'package:rent_checklist/src/detail/item/add/item_search_list_state.dart';
import 'package:rent_checklist/src/detail/item/add/item_search_list_view_model.dart';
import 'package:rent_checklist/src/detail/item/item_model.dart';

class ItemSearchList extends StatefulWidget {
  final int groupId;

  const ItemSearchList({super.key, required this.groupId});

  @override
  State<StatefulWidget> createState() => _ItemSearchListState();
}

class _ItemSearchListState extends ViewModelWidgetState<
    ItemSearchList,
    ItemSearchListState,
    ItemSearchListViewEvent,
    ItemSearchListViewModel
> {
  @override
  void initState() {
    super.initState();
    withProviderOnFrame<ItemSearchListViewModel>(context, (it) => it.load());
  }

  @override
  void handleEvent(ItemSearchListViewEvent event) {}

  @override
  Widget render(ItemSearchListState state) => switch (state) {
    ItemSearchListLoading _ => const Loader(),
    ItemSearchListError err => Text('$err'),
    ItemSearchListLoaded _ => _buildList(state)
  };

  Widget _buildList(ItemSearchListLoaded state) {
    final sliverList = SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = state.items[index];
            return ListTile(
              title: Text(item.title),
              onTap: () => onItemTap(item),
            );
          },
          childCount: state.items.length,
        )
    );

    return Expanded(
        child: CustomScrollView(
          slivers: [sliverList],
        )
    );
  }

  void onItemTap(ItemModel item) async {
    try {
      await Provider.of<FlatDetailViewModel>(context, listen: false)
          .addItem(widget.groupId, item);
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "Failed to add item: $e");
      }
    } finally {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
