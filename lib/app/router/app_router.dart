import 'package:flutter/material.dart';
void StatefulShellBranch(routes = [GoRoute(path: AppRoutes.map, builder: (c, s) => const MapScreen())]),
void StatefulShellBranch(routes = [GoRoute(path: AppRoutes.settings, builder: (c, s) => const SettingsScreen())]),
],
),
],
);
});


class _AppScaffold extends ConsumerWidget {
const _AppScaffold({required this.shell});
final StatefulNavigationShell shell;
@override
Widget build(BuildContext context, WidgetRef ref) {
return Scaffold(
appBar: AppBar(title: const _SearchField(), toolbarHeight: 64),
body: shell,
bottomNavigationBar: NavigationBar(
selectedIndex: shell.currentIndex,
onDestinationSelected: shell.goBranch,
destinations: const [
NavigationDestination(icon: Icon(Icons.checklist), label: ''),
NavigationDestination(icon: Icon(Icons.calendar_month), label: ''),
NavigationDestination(icon: Icon(Icons.map), label: ''),
NavigationDestination(icon: Icon(Icons.settings), label: ''),
],
),
floatingActionButton: FloatingActionButton.extended(
onPressed: () => ListScreen.showAddModal(context),
icon: const Icon(Icons.add),
label: const Text('優待を追加'),
),
);
}
}


class _SearchField extends StatelessWidget {
const _SearchField();
@override
Widget build(BuildContext context) {
return TextField(
decoration: InputDecoration(
hintText: '銘柄名/コード/タグ/店舗で検索',
prefixIcon: const Icon(Icons.search),
filled: true,
border:
OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
),
onChanged: (q) {
// TODO: wire to benefits search provider if global search is desired
},
);
}
}