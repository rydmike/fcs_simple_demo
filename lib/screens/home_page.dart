// The content of the HomePage below is not relevant for using FlexColorScheme
// based application theming. The critical parts are in the MaterialApp
// theme definitions. The HomePage just contains UI to visually show what the
// defined example looks like in an application and with commonly used Widgets.
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../widgets/about.dart';
import '../widgets/page_body.dart';
import '../widgets/show_theme_colors.dart';
import '../widgets/side_menu.dart';
import '../widgets/theme_showcase.dart';
import 'splash_page_one.dart';
import 'splash_page_two.dart';
import 'subpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // The reason why HomePage is using a stateful widget is that it holds the
  // state of the dummy side menu/rail locally.
  double currentSidePanelWidth = AppConst.expandWidth;
  bool isSidePanelExpanded = true;
  bool showSidePanel = true;
  // The state for the system navbar style and divider usage is local as it is
  // is only used by the AnnotatedRegion, not by FlexColorScheme.toTheme.
  // Used to control system navbar style via an AnnotatedRegion.
  FlexSystemNavBarStyle systemNavBarStyle = FlexSystemNavBarStyle.background;
  // Used to control if we have a top divider on the system navigation bar.
  bool useSysNavDivider = false;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double topPadding = media.padding.top;
    final double bottomPadding = media.padding.bottom;
    final bool menuAvailable = media.size.width > 650;
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle headline4 = textTheme.headline4!;
    final Color appBarColor = theme.appBarTheme.color ?? theme.primaryColor;

    // Give the width of the side panel some automatic adaptive behavior and
    // make it rail sized when there is not enough room for a menu, even if
    // menu size is requested.
    if (!menuAvailable && showSidePanel) {
      currentSidePanelWidth = AppConst.shrinkWidth;
    }
    if (menuAvailable && showSidePanel && !isSidePanelExpanded) {
      currentSidePanelWidth = AppConst.shrinkWidth;
    }
    if (menuAvailable && showSidePanel && isSidePanelExpanded) {
      currentSidePanelWidth = AppConst.expandWidth;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // FlexColorScheme contains a helper that can be use to theme
      // the system navigation bar using an AnnotatedRegion. Without this
      // page wrapper the system navigation bar in Android will not change
      // theme color as we change themes for the page. This is a
      // Flutter "feature", but with this annotated region we can have the
      // navigation bar follow desired background color and theme-mode,
      // which looks nicer and more as it should on an Android device.
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        systemNavBarStyle: systemNavBarStyle,
        useDivider: useSysNavDivider,
      ),
      child: Row(
        children: <Widget>[
          // Contains the demo menu and side rail.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConst.expandWidth),
            child: Material(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: currentSidePanelWidth,
                child: SideMenu(
                  isVisible: showSidePanel,
                  menuWidth: AppConst.expandWidth,
                ),
              ),
            ),
          ),
          // The actual page content is a normal Scaffold.
          Expanded(
            child: Scaffold(
              // For scrolling behind the app bar
              extendBodyBehindAppBar: true,
              // For scrolling behind the bottom nav bar, if there would be one.
              extendBody: true,
              appBar: AppBar(
                title: const Text('FlexColorScheme Simple Example'),
                actions: const <Widget>[AboutIconButton()],
                backgroundColor: Colors.transparent,
                // Gradient partially transparent AppBar, just because it looks
                // nice and we can see content scroll behind it.
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                    gradient: LinearGradient(
                      begin: AlignmentDirectional.centerStart,
                      end: AlignmentDirectional.centerEnd,
                      colors: <Color>[
                        appBarColor,
                        appBarColor.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),
              body: PageBody(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    AppConst.edgePadding,
                    topPadding + kToolbarHeight + AppConst.edgePadding,
                    AppConst.edgePadding,
                    AppConst.edgePadding + bottomPadding,
                  ),
                  children: <Widget>[
                    Text('Theme', style: headline4),
                    const Text(
                        'This example shows how you can use custom colors'
                        'with FlexColorScheme in light and dark mode, '
                        'just as defined values in stateless app.\n\n'
                        ''
                        'Using ThemeMode.system and device settings to toggle '
                        'between light and dark theme.\n\n'
                        ''
                        'The example also has place holders in the code '
                        'that you can toggle to test other FlexColorScheme '
                        'features easily.'),

                    const SizedBox(height: 8),
                    // Active theme color indicators.
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConst.edgePadding),
                      child: ShowThemeColors(),
                    ),
                    const SizedBox(height: 8),
                    // Open a sub-page
                    ListTile(
                      title: const Text('Open a demo subpage'),
                      subtitle: const Text(
                        'The subpage will use the same '
                        'color scheme based theme automatically.',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Subpage.show(context);
                      },
                    ),

                    const Divider(),
                    // Splash pages...
                    ListTile(
                      title: const Text('Splash page demo 1a'),
                      subtitle: const Text(
                        'No scrim and normal status icons.\n'
                        'Using themedSystemNavigationBar (noAppBar:true)',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        SplashPageOne.show(context, false);
                      },
                    ),
                    ListTile(
                      title: const Text('Splash page demo 1b'),
                      subtitle: const Text(
                        'No scrim and inverted status icons.\n'
                        'Using themedSystemNavigationBar (noAppBar:true, '
                        'invertStatusIcons:true)',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        SplashPageOne.show(context, true);
                      },
                    ),
                    ListTile(
                      title: const Text('Splash page demo 2'),
                      subtitle: const Text(
                        'No status icons or navigation bar.\n'
                        'Using setEnabledSystemUIOverlays([])',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        SplashPageTwo.show(context, true);
                      },
                    ),
                    const Divider(),
                    Text('Menu', style: headline4),
                    const Text(
                      'The menu is a just a demo to make a larger '
                      'area that uses the primary branded background color.',
                    ),
                    SwitchListTile.adaptive(
                      title: const Text('Turn ON to show the menu'),
                      subtitle: const Text('Turn OFF to hide the menu.'),
                      value: showSidePanel,
                      onChanged: (bool value) {
                        setState(() {
                          showSidePanel = value;
                          if (showSidePanel) {
                            if (isSidePanelExpanded) {
                              currentSidePanelWidth = AppConst.expandWidth;
                            } else {
                              currentSidePanelWidth = AppConst.shrinkWidth;
                            }
                          } else {
                            currentSidePanelWidth = 0.01;
                          }
                        });
                      },
                    ),
                    SwitchListTile.adaptive(
                      title: const Text('Turn ON for full sized menu'),
                      subtitle: const Text(
                        'Turn OFF for a rail sized menu. '
                        'The full size menu will only be shown when '
                        'screen width is above 650 dp and this toggle is ON.',
                      ),
                      value: isSidePanelExpanded,
                      onChanged: (bool value) {
                        setState(() {
                          isSidePanelExpanded = value;
                          if (showSidePanel) {
                            if (isSidePanelExpanded) {
                              currentSidePanelWidth = AppConst.expandWidth;
                            } else {
                              currentSidePanelWidth = AppConst.shrinkWidth;
                            }
                          } else {
                            currentSidePanelWidth = 0.01;
                          }
                        });
                      },
                    ),
                    const Divider(),
                    Text('Theme Showcase', style: headline4),
                    const ThemeShowcase(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
