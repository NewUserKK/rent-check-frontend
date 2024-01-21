import 'package:rent_checklist/src/common/arch/view_model.dart';
import 'package:rent_checklist/src/common/utils/extensions.dart';
import 'package:rent_checklist/src/flat/flat_api.dart';
import 'package:rent_checklist/src/flat/flats_state.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';

sealed class FlatsEvent {}

class FlatsViewModel extends ViewModel<FlatsState, FlatsEvent> {
  final _flatApi = FlatApiFactory.create();

  @override
  FlatsState state = FlatsStateLoading();

  Future<void> load() async {
    setState(FlatsStateLoading());

    try {
      final flats = await _flatApi.getFlats();
      setState(FlatsStateLoaded(flats: flats.associateBy((it) => it.id)));
    } catch (e) {
      setState(FlatsStateError(error: e));
    }
  }

  Future<FlatModel> createFlat(FlatModel flat) async {
    if (this.state is! FlatsStateLoaded) {
      throw Exception('Flats are not loaded yet');
    }

    final state = this.state as FlatsStateLoaded;

    final newFlat = await _flatApi.createFlat(flat);

    setState(state.copyWith(
      flats: state.flats.set(newFlat.id, newFlat),
    ));

    return newFlat;
  }
}
