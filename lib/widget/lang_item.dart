import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/common.dart';
import 'package:story_app_flutter/provider/localizations_provider.dart';
import 'package:story_app_flutter/utils/localization.dart';

class LangItem extends StatefulWidget {
  const LangItem({super.key});

  @override
  State<LangItem> createState() => _LangItemState();
}

class _LangItemState extends State<LangItem> {
  @override
  Widget build(BuildContext context) {
    const locales = AppLocalizations.supportedLocales;
    final provider = Provider.of<LocalizationProvider>(
      context,
      listen: false,
    );

    return ListView.separated(
      itemCount: locales.length,
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        final lang = Localization.getLocale(locales[index].languageCode);

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    lang.flag,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 15.0),
                  Text(
                    lang.country,
                    style:
                        const TextStyle(fontSize: 17, fontFamily: 'Quicksand'),
                  ),
                ],
              ),
              (locales[index] == provider.locale)
                  ? const Icon(
                      Icons.check,
                      size: 35,
                      color: Colors.blue,
                    )
                  : InkWell(
                      onTap: () {
                        setState(() {
                          provider.setLocale(lang.countryCode);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        );
      }),
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 8.0);
      },
    );
  }
}
