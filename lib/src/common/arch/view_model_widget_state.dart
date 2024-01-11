import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/common/arch/view_model.dart';
import 'package:rent_checklist/src/common/widgets/load_utils.dart';

abstract class ViewModelWidgetState<
  ViewWidget extends StatefulWidget,
  ViewState,
  ViewEvent,
  VM extends ViewModel<ViewState, ViewEvent>
> extends State<ViewWidget> {

  @override
  Widget build(BuildContext context) {
    return Consumer<VM>(
        builder: (context, model, _) {
          if (model.currentEvent != null) {
            doOnPostFrame(context, () => handleEvent(model.currentEvent!));
          }
          return render(model.state);
        }
    );
  }

  @protected
  Widget render(ViewState state);

  @protected
  void handleEvent(ViewEvent event);
}
