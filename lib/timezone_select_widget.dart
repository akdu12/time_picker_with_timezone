import 'package:flutter/material.dart';

// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneSelectWidget extends StatefulWidget {
  const TimezoneSelectWidget({super.key, required this.initTimezone, required this.searchController});

  final String initTimezone;
  final TextEditingController searchController;

  @override
  State<TimezoneSelectWidget> createState() => _TimezoneSelectWidgetState();
}

class _TimezoneSelectWidgetState extends State<TimezoneSelectWidget> {
  final visualDensity = const VisualDensity(horizontal: -4, vertical: -4);
  var searchText = "";

  void searchListener() {
    // print(widget.searchController.text);
    searchText = widget.searchController.text;
    setState(() {});
  }

  @override
  void initState() {
    tz.initializeTimeZones();
    widget.searchController.addListener(searchListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.searchController.removeListener(searchListener);
    widget.searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> timezoneListWidget = [];

    tz.timeZoneDatabase.locations.forEach((name, location) {

      if(searchText.isNotEmpty && !name.toLowerCase().contains(searchText.toLowerCase())) {
        return;
      }

      final offsetInSeconds = location.currentTimeZone.offset ~/ 1000;
      final offsetInHours = offsetInSeconds ~/ 3600;
      final isDst = location.currentTimeZone.isDst;
      final abbreviation = location.currentTimeZone.abbreviation;

      String offsetStr = "";
      if (offsetInHours >= 10) {
        offsetStr += "+$offsetInHours";
      } else if (offsetInHours >= 0) {
        offsetStr = "+0$offsetInHours";
      } else if (offsetInHours > -10) {
        offsetStr = "-0${-offsetInHours}";
      } else {
        offsetStr = "$offsetInHours";
      }

      offsetStr += ":00";

      timezoneListWidget.add(
        RadioListTile<String>(
          // title: Text("$name, UTC$offsetStr${isDst ? " DST" : ""}"),
          title: Text("$abbreviation, UTC$offsetStr${isDst ? " DST" : ""}"),
          subtitle: Text(
            name,
            style: const TextStyle(fontSize: 12),
          ),
          value: name,
          groupValue: "",
          visualDensity: visualDensity,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          onChanged: (String? value) {
            // setState(() {
            //   // _selectedOption = value!;
            // });
          },
        ),
      );
    });
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: 1000, //这样会被限制在最宽
      child: ListView(
        children: timezoneListWidget,
      ),
    );
    // return SingleChildScrollView(
    //   child: ListBody(
    //     children: timezoneListWidget,
    //   ),
    // );
  }
}
