import 'package:flutter/material.dart';

import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:task_requirements/action/update_navbar_action.dart';
import 'package:task_requirements/core/service/product_service.dart';
import 'package:task_requirements/screens/product_details_screen.dart';
import 'package:task_requirements/screens/products_screen.dart';
import 'package:task_requirements/state/navbar/navbar_state.dart';
import 'package:task_requirements/path_file.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  late Store<NavbarState> store;


  @override
  void initState() {
    store = Store<NavbarState>(initialState: NavbarState.initial());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<NavbarState>(
      store: store,
      child: StoreConnector<NavbarState, NavbarViewModel>(
        converter: (store) => NavbarViewModel.fromStore(store),

        builder: (context, vm) {
          return Scaffold(
            body: [ProductsScreen(navbarViewModel: vm), ProductDetailsScreen()][vm.currentIndex],

            bottomNavigationBar: BottomNavigationBar(
              currentIndex: vm.currentIndex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'News Screen'),
                BottomNavigationBarItem(icon: Icon(Icons.description), label: 'News Details'),
              ],

              // On tap, dispatch the action to update the state
              onTap: (index) {

                vm.dispatch(UpdateNavbarAction(newIndex: index));
              },
              selectedItemColor: Colors.deepPurple,
              unselectedItemColor: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}

class NavbarViewModel {
  final int currentIndex;

  // The dispatch function is generic over the state type: NavbarState
  final Function(ReduxAction<NavbarState> action) dispatch;

  NavbarViewModel({required this.currentIndex, required this.dispatch});

  factory NavbarViewModel.fromStore(Store<NavbarState> store) {
    return NavbarViewModel(currentIndex: store.state.currentIndex, dispatch: store.dispatch);
  }
}
