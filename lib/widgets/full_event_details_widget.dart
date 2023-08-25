import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_care_app/utils/colors.dart';

class FullEventDetailsWidget extends StatelessWidget {
  final DateTime firstDate;
  final DateTime? secondDate;
  final String firstText;
  final String? secondText;
  Function(BuildContext)? onRemove;
  final IconButton editIcon;
  final Color color;
  FullEventDetailsWidget(
      {super.key,
      required this.firstDate,
      this.secondDate,
      required this.firstText,
      this.secondText,
      required this.editIcon,
      required this.onRemove,
      required this.color});

  @override
  Widget build(BuildContext context) {
    String formattedFirstDate = formatDate(firstDate, [dd, '/', mm, '/', yyyy]);
    String formattedSecondDate = '';
    if (secondDate != null) {
      formattedSecondDate = formatDate(secondDate!, [dd, '/', mm, '/', yyyy]);
    }
    return Slidable(
      direction: Axis.horizontal,
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        SlidableAction(
          foregroundColor: kOffWhite,
          onPressed: onRemove,
          icon: Icons.delete,
          backgroundColor: Colors.transparent,
          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(14), topRight: Radius.circular(14)),
        ),
      ]),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12, right: 12),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(32),
            ),
            color: color,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 26, left: 16, right: 16, bottom: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18),
                        ),
                        color: kPaynesGrey.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const ImageIcon(
                            AssetImage('images/event_date.png'),
                            size: 22,
                            color: kOffWhite,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formattedFirstDate,
                            style: const TextStyle(
                              fontSize: 22,
                              color: kOffWhite,
                              fontFamily: 'PTRoot',
                              //letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18),
                        ),
                        color: kPaynesGrey.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const ImageIcon(
                            AssetImage('images/event_name.png'),
                            size: 22,
                            color: kOffWhite,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Container(
                              child: Text(
                                firstText,
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: kOffWhite,
                                  fontFamily: 'PTRoot',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    secondText == null
                        ? Container()
                        : Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(18),
                                  ),
                                  color: kPaynesGrey.withOpacity(0.1),
                                ),
                                child: Row(
                                  children: [
                                    const ImageIcon(
                                      AssetImage('images/event_curative_name.png'),
                                      size: 22,
                                      color: kOffWhite,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Container(
                                        child: Text(
                                          secondText!,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            color: kOffWhite,
                                            fontFamily: 'PTRoot',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    secondDate == null
                        ? Container()
                        : Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(18),
                                  ),
                                  color: kPaynesGrey.withOpacity(0.1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const ImageIcon(
                                      AssetImage('images/event_next_time.png'),
                                      size: 22,
                                      color: kOffWhite,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      formattedSecondDate,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: kOffWhite,
                                        fontFamily: 'PTRoot',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 26 - 10),
                    Center(child: editIcon)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
