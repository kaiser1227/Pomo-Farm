import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'data/local/local_storage_service.dart';
import 'data/repositories/pomo_farm_repository.dart';
import 'ui/core/app_theme.dart';
import 'ui/features/dashboard/view_models/pact_dashboard_view_model.dart';
import 'ui/features/dashboard/views/pact_dashboard_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }
  
  // Initialize Local Storage
  final localStorage = await LocalStorageService.init();
  final repository = PomoFarmRepository(localStorage);

  runApp(PomoFarmApp(repository: repository));
}

class PomoFarmApp extends StatelessWidget {
  final PomoFarmRepository repository;

  const PomoFarmApp({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PactDashboardViewModel(repository),
        ),
      ],
      child: MaterialApp(
        title: 'Pomo Farm',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko'), // Korean
          Locale('en'), // English
        ],
        home: const PactDashboardView(),
      ),
    );
  }
}
