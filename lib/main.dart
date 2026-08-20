import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'data/local/local_storage_service.dart';
import 'data/repositories/focus_pact_repository.dart';
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
  final repository = FocusPactRepository(localStorage);

  runApp(FocusPactApp(repository: repository));
}

class FocusPactApp extends StatelessWidget {
  final FocusPactRepository repository;

  const FocusPactApp({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PactDashboardViewModel(repository),
        ),
      ],
      child: MaterialApp(
        title: 'Focus Pact',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const PactDashboardView(),
      ),
    );
  }
}
