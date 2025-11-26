import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/character_list_viewmodel.dart';
import '../widgets/character_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CharacterListViewModel>(context, listen: false).loadCharacters());

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      Provider.of<CharacterListViewModel>(context, listen: false).loadCharacters();
    }
  }

  void _onSearchChanged(String query) {
    final viewModel = Provider.of<CharacterListViewModel>(context, listen: false);
    if (query.isEmpty) {
      viewModel.clearSearch();
    } else {
      viewModel.search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Postacie z Władcy Pierścieni',
          style: TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Losuj postać',
            onPressed: () {
              final viewModel = Provider.of<CharacterListViewModel>(context, listen: false);
              final randomCharacter = viewModel.getRandomCharacter();
              if (randomCharacter != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(character: randomCharacter),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Brak postaci do wylosowania!')),
                );
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Szukaj postaci...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: Consumer<CharacterListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.characters.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null && viewModel.characters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Błąd: ${viewModel.errorMessage}'),
                  ElevatedButton(
                    onPressed: () => viewModel.loadCharacters(refresh: true),
                    child: const Text('Spróbuj ponownie.'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: viewModel.characters.length + (viewModel.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == viewModel.characters.length) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ));
              }
              return CharacterCard(character: viewModel.characters[index]);
            },
          );
        },
      ),
    );
  }
}
