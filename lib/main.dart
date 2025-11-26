import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/services/api_service.dart';
import 'data/services/local_storage_service.dart';
import 'core/services/firebase_service.dart';
import 'data/repositories/character_repository.dart';
import 'viewmodels/character_list_viewmodel.dart';
import 'viewmodels/character_detail_viewmodel.dart';
import 'ui/screens/home_screen.dart';
import 'core/theme.dart';
import 'ui/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SetupApp());
}

class SetupApp extends StatefulWidget {
  const SetupApp({super.key});

  @override
  State<SetupApp> createState() => _SetupAppState();
}

class _SetupAppState extends State<SetupApp> {
  bool _isInitialized = false;
  String? _error;
  
  late final LocalStorageService _localStorageService;
  late final ApiService _apiService;
  late final FirebaseService _firebaseService;
  late final CharacterRepository _repository;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      try {
        bool shouldInitFirebase = false;
        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
          shouldInitFirebase = true;
        }
        
        if (shouldInitFirebase) {
          await Firebase.initializeApp();
          FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
          PlatformDispatcher.instance.onError = (error, stack) {
            FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
            return true;
          };
        } else {
          print('Pominięto inicjalizację Firebase.');
        }
      } catch (e) {
        throw Exception('Inicjalizacja Firebase nie powiodła się: $e');
      }

      _localStorageService = LocalStorageService();
      await _localStorageService.init();

      _apiService = ApiService();
      _firebaseService = FirebaseService();
      _repository = CharacterRepository(_apiService, _localStorageService, _firebaseService);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Błąd inicjalizacji:\n$_error', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        Provider.value(value: _repository),
        Provider.value(value: _firebaseService),
        ChangeNotifierProvider(create: (_) => CharacterListViewModel(_repository, _firebaseService)),
        ChangeNotifierProvider(create: (_) => CharacterDetailViewModel(_repository, _firebaseService)),
      ],
      child: const MyApp(),
    );
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOTR App',
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}
