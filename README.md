# Aplikacja LOTR Flutter

Aplikacja we Flutterze wyświetlająca postacie z Władcy Pierścieni przy użyciu [The One API](https://the-one-api.dev/).

## Funkcje
- **Lista Postaci**: Przeglądanie wszystkich postaci z uniwersum LOTR.
- **Wyszukiwanie**: Filtrowanie postaci po nazwie.
- **Szczegóły**: Wyświetlanie szczegółowych informacji (Rasa, Płeć, Królestwo itp.) oraz cytatów dla każdej postaci.
- **Tryb Offline**: Postacie są zapisywane lokalnie przy użyciu Hive, co umożliwia dostęp bez internetu.
- **Integracja Firebase**: Wsparcie dla Analytics i Crashlytics (wymaga konfiguracji).

## Konfiguracja i Uruchomienie

1.  **Wymagania**: Zainstalowane Flutter SDK.
2.  **Pobierz zależności**:
    ```bash
    flutter pub get
    ```
3.  **Uruchom aplikację**:
    ```bash
    flutter run
    ```
4.  **Konfiguracja Firebase**:
    - Umieść `google-services.json` (Android) w `android/app/`.
    - Umieść `GoogleService-Info.plist` (iOS) w `ios/Runner/`.

## Platformy
- Android
- iOS

## Architektura
Aplikacja korzysta ze wzorca MVVM (Model-View-ViewModel):
- **Warstwa Danych**: `ApiService` (Dio), `LocalStorageService` (Hive), `CharacterRepository`.
- **Warstwa Logiki**: `CharacterListViewModel`, `CharacterDetailViewModel` (Provider).
- **Warstwa Interfejsu**: `HomeScreen`, `DetailScreen`, `CharacterCard`.

## API
Użyte API: [The One API](https://the-one-api.dev/)

## Demo
Zobacz folder `demo`, aby zobaczyć zrzuty ekranu i wideo z działania aplikacji.
