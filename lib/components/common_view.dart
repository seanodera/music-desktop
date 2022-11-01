import 'dart:ui';

import 'package:flutter/material.dart';


class CommonWidget extends StatefulWidget {
  final ImageProvider image;
  final String title, subtitle;
  const CommonWidget({Key? key, required this.image, required this.title, required this.subtitle}) : super(key: key);

  @override
  State<CommonWidget> createState() => _CommonWidgetState();
}

class _CommonWidgetState extends State<CommonWidget> {
  @override
  Widget build(BuildContext context) {

    return Container(
      width: 200,
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        image: DecorationImage(image: widget.image, fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 50, sigmaX: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: widget.image,
                  width: 200,
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis
                        ),
                      ),
                      Text(
                        widget.subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
