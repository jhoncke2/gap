import 'package:flutter/material.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/widgets/navigation_list/button/navigation_list_button.dart';
// ignore: must_be_immutable
class NavigationList extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final List<String> itemsNames;
  List<Function> itemsFunctions;
  final double horizontalPadding;
  final bool scrollIsAllwaysShown;
  final ScrollController scrollController = new ScrollController();
  BuildContext context;

  NavigationList({
    @required this.itemsNames,
    @required this.itemsFunctions,
    this.horizontalPadding = 0,
    this.scrollIsAllwaysShown = false
  });

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return createNavList();
  }

  @protected
  Widget createNavList(){
    final List<Widget> navItems = createButtonItems();
    return Expanded(
      child: Container(
        child: Scrollbar(
          isAlwaysShown: scrollIsAllwaysShown,
          showTrackOnHover: true,
          controller: scrollController,
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * horizontalPadding),
            children: navItems,
          ),
        ),
      ),
    );
  }

  @protected
  List<Widget> createButtonItems(){
    final List<Widget> items = [];
    for(int i = 0; i < itemsNames.length; i++){
      items.add(
        createNavButton(i)
      );
    }
    return items;
  }

  @protected
  Widget createNavButton(int itemIndex){
    return NavigationListButton(
      name: itemsNames[itemIndex],
      textColor: Theme.of(context).primaryColor,
      hasBottomBorder: true, 
      onTap: itemsFunctions[itemIndex]
    );
  }
}