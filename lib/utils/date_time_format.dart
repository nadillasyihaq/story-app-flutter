import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/provider/localizations_provider.dart';

String dateTimeFormat(DateTime dateTime, BuildContext context) {
  final provider = Provider.of<LocalizationProvider>(context);

  if (provider.locale == const Locale('en')) {
    return DateFormat('EEEE, MMMM dd, yyyy', 'en_US').format(dateTime);
  } else if (provider.locale == const Locale('de')) {
    return DateFormat('EEEE, dd. MMMM yyyy', 'de_DE').format(dateTime);
  } else {
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateTime);
  }
}
