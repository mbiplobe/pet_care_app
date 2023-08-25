import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class LastEventFromCategoryWidget extends StatelessWidget {
  final DateTime eventDetailDate;
  final String eventDetailName;
  final VoidCallback onClick;
  final Color color;
  final Color textColor;

  final String imageName;
  const LastEventFromCategoryWidget(
      {super.key,
      required this.eventDetailDate,
      required this.eventDetailName,
      required this.imageName,
      required this.onClick,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    String date = formatDate(eventDetailDate, [dd, '/', mm, '/', yyyy]);

    return InkWell(
      onTap: onClick,
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.all(12),
          width: MediaQuery.of(context).size.width * 0.42,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(
              Radius.circular(38),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ImageIcon(
                      AssetImage(imageName),
                      color: textColor,
                      size: 46,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                eventDetailDate != DateTime(0)
                    ? Text(
                        date,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      )
                    : Container(),
                const SizedBox(height: 5),
                Text(
                  eventDetailName.toUpperCase(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: Icon(
            IconlyLight.arrow_right,
            color: textColor,
            size: 32,
          ),
        ),
      ]),
    );
  }
}
