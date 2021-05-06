import 'package:flutter/material.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class NavigationList extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final int itemsLength;
  final Widget Function(int index) createSingleNavButton;
  final double horizontalPadding;
  final bool scrollIsAllwaysShown;
  final ScrollController scrollController;
  BuildContext context;

  NavigationList({
    @required this.itemsLength,
    @required this.createSingleNavButton,
    this.horizontalPadding = 0,
    this.scrollIsAllwaysShown = false
  }):
    scrollController = new ScrollController()
    ;

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

  List<Widget> createButtonItems(){
    final List<Widget> items = [];
    for(int i = 0; i < itemsLength; i++){
      items.add( createSingleNavButton(i) );
    }
    return items;
  }
}