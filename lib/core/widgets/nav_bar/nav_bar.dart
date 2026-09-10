// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ossos_task/imports.dart';
//
// class NavBar extends StatefulWidget {
//   final Widget page;
//   final int initialPageIndex;
//   final GlobalKey<CurvedNavigationBarState> bottomNavigationKey;
//   const NavBar({
//     Key? key,
//     required this.page,
//     required this.bottomNavigationKey,
//     required this.initialPageIndex,
//   }) : super(key: key);
//
//   @override
//   State<NavBar> createState() => _NavBarState();
// }
//
// class _NavBarState extends State<NavBar> with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _offsetAnimation;
//   late Animation<double> _fadeAnimation;
//   final Duration animationDuration = Duration(seconds: 1);
//   late Image splashScreenImage;
//
//   void initiateSplashAnimation() {
//     _controller = AnimationController(duration: animationDuration, vsync: this);
//
//     _offsetAnimation = Tween<Offset>(
//       begin: const Offset(0, 0),
//       end: Offset(1, 0),
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//     _fadeAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//     _controller.forward();
//   }
//
//   void onTabNavBarItem(int index) {
//     if (index != 2) {
//       BlocProvider.of<LiveRadioBloc>(
//         context,
//       ).add(ChangeStickyStateEvent(stickyState: StickyState.radioSticky));
//     } else if (index == 2) {
//       BlocProvider.of<LiveRadioBloc>(
//         context,
//       ).add(ChangeStickyStateEvent(stickyState: StickyState.noneSticky));
//     }
//     switch (index) {
//       case 0:
//         Routes.navigateToScreen(
//           Routes.quranScreen,
//           NavigateType.goNamed,
//           context,
//         );
//       case 1:
//         Routes.navigateToScreen(
//           Routes.favoritesScreen,
//           NavigateType.goNamed,
//           context,
//         );
//       case 2:
//         {
//           Routes.navigateToScreen(
//             Routes.liveScreen,
//             NavigateType.goNamed,
//             context,
//           );
//         }
//       case 3:
//         Routes.navigateToScreen(
//           Routes.profileScreen,
//           NavigateType.goNamed,
//           context,
//         );
//       case 4:
//         Routes.navigateToScreen(
//           Routes.searchScreen,
//           NavigateType.goNamed,
//           context,
//         );
//     }
//   }
//
//   double _iconHeight = 35;
//
//   CurvedITem curvedItemsBuilder({
//     required Widget unselectedIcon,
//     required Widget selectedIcon,
//     required String title,
//   }) {
//     return CurvedITem(
//       unselectedIcon: Padding(
//         padding: EdgeInsets.all(8),
//         child: unselectedIcon,
//       ),
//       selectedIcon: Padding(
//         padding: EdgeInsets.all(10),
//         child: selectedIcon,
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontSize: AppFontSizes.small,
//           fontFamily: FontFamily.cairo,
//           color: Color(0xff2C3735),
//           fontWeight: AppFontWeights.regular,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     splashScreenImage = Assets.images.pictures.splashScreen.image(
//       fit: BoxFit.fill,
//     );
//     Assets.images.pictures.splashScreen.path;
//     initiateSplashAnimation();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<CurvedITem> navBarItems = <CurvedITem>[
//       curvedItemsBuilder(
//         unselectedIcon: Assets.images.icons.navBarUnselectedQuranIcon.svg(
//           height: _iconHeight,
//         ),
//         selectedIcon: Assets.images.icons.navBarSelectedQuran.svg(
//           height: _iconHeight,
//         ),
//         title: Localizer.tr(LKeys.navBarQuran, context),
//       ),
//       curvedItemsBuilder(
//         unselectedIcon: Assets.images.icons.navBarUnselectedFavoriteIcon.svg(
//           height: _iconHeight,
//         ),
//         selectedIcon: Assets.images.icons.navBarSelectedFavorite.svg(
//           height: _iconHeight,
//         ),
//         title: Localizer.tr(LKeys.navBarFavorites, context),
//       ),
//       curvedItemsBuilder(
//         unselectedIcon: Assets.images.icons.navBarRadioIcon.svg(
//           height: _iconHeight,
//         ),
//         selectedIcon: Assets.images.icons.navBarRadioIcon.svg(
//           height: _iconHeight,
//         ),
//         title: Localizer.tr(LKeys.navBarLive, context),
//       ),
//       curvedItemsBuilder(
//         unselectedIcon: Assets.images.icons.navBarUnselectedProfileIcon.svg(
//           height: _iconHeight,
//         ),
//         selectedIcon: Assets.images.icons.navBarSelectedProfile.svg(
//           height: _iconHeight,
//         ),
//         title: Localizer.tr(LKeys.navBarProfile, context),
//       ),
//       curvedItemsBuilder(
//         unselectedIcon: Assets.images.icons.navBarUnselectedSearchIcon.svg(
//           height: _iconHeight,
//         ),
//         selectedIcon: Assets.images.icons.navBarSelectedSearch.svg(
//           height: _iconHeight,
//         ),
//         title: Localizer.tr(LKeys.navBarSearch, context),
//       ),
//     ];
//     return Stack(
//       children: [
//         widgets.page,
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: CurvedNavigationBar(
//             // color: Colors.pink,
//             backgroundColor: Colors.black,
//             key: widgets.bottomNavigationKey,
//             height: 75,
//             index: widgets.initialPageIndex,
//             // widgets.bottomNavigationKey.currentState?.widgets.index ?? 2,
//             buttonBackgroundColor: StaticColors.green_230,
//             items: navBarItems,
//             onTap: onTabNavBarItem,
//           ),
//         ),
//         splashScreen(
//           offsetAnimation: _offsetAnimation,
//           fadeAnimation: _fadeAnimation,
//           splashScreenImage: splashScreenImage,
//         ),
//       ],
//     );
//   }
// }
