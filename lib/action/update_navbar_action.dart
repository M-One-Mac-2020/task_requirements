import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:task_requirements/state/navbar/navbar_state.dart';

class UpdateNavbarAction extends Action<NavbarState> {
  final int newIndex;

  UpdateNavbarAction({required this.newIndex});

  @override
  NavbarState reduce() {
    return state.rebuild((b) => b.currentIndex = newIndex);
  }
}
