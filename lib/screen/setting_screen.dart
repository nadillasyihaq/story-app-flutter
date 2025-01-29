import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/common.dart';
import 'package:story_app_flutter/provider/auth_provider.dart';
import 'package:story_app_flutter/widget/lang_item.dart';

class SettingScreen extends StatelessWidget {
  final Function() onLogout;

  const SettingScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.settingTitle,
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.white,
            fontFamily: 'Product-Sans',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.chooseLanguange,
                style: const TextStyle(
                  fontFamily: 'Product-Sans',
                  color: Colors.black54,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 10.0),
              const LangItem(),
              const Divider(
                color: Colors.black12,
                thickness: 2,
                height: 30,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.pink],
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    final authRead = context.read<AuthProvider>();
                    final result = await authRead.logout();
                    if (result) onLogout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                  ),
                  child: SizedBox(
                    child: context.watch<AuthProvider>().isLoadingLogout
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(Icons.exit_to_app),
                              const SizedBox(width: 5.0),
                              Text(
                                AppLocalizations.of(context)!.logoutText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Product-Sans',
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
