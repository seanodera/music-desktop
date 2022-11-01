import 'dart:ui';

import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  final List<SideBarItem> items;
  final double width, widgetWidth;

  const SideBar(
      {Key? key,
      required this.items,
      required this.width,
      required this.widgetWidth})
      : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  List<Widget> widgets = [];
  int index = 0;
  Widget activeWidget = Container();

  @override
  void initState() {
    int count = 0;
    for (var element in widget.items) {
      widgets.add(SideBarButton(
          active: (count == index),
          icon: element.icon,
          text: element.text,
          onTap: () {
            setState(() {
              index = count;
              activeWidget = element.widget;
            });
          }));
      count++;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 65;
    return ClipRect(
      child: Container(
          width: widget.width,
          height: height,
          color: Theme.of(context).colorScheme.surface,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 200, sigmaX: 200),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface,
                      image: const DecorationImage(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const Text(
                    'Menu',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2),
                  ),
                  ...widgets,
                  const Divider()
                ]),
          )),
    );
  }
}

class SideBarItem {
  IconData icon;
  String text;
  Widget widget;

  SideBarItem({required this.widget, required this.text, required this.icon});
}

class SideBarButton extends StatelessWidget {
  final bool active;
  final IconData icon;
  final String text;
  final Function() onTap;

  const SideBarButton({
    Key? key,
    required this.active,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 40,
                width: 5,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: (active)
                      ? theme.colorScheme.secondary
                      : Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  icon,
                  color: (active) ? theme.colorScheme.secondary : null,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: (active) ? theme.colorScheme.secondary : null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
