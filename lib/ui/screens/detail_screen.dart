import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/character.dart';
import '../../viewmodels/character_detail_viewmodel.dart';

class DetailScreen extends StatefulWidget {
  final Character character;

  const DetailScreen({super.key, required this.character});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<CharacterDetailViewModel>(context, listen: false)
            .loadQuotes(widget.character.id);
      }
    });
  }

  IconData _getRaceIcon(String? race) {
    if (race == null) return Icons.person_outline;
    final lowerRace = race.toLowerCase();
    if (lowerRace.contains('elf')) return Icons.star;
    if (lowerRace.contains('hobbit')) return Icons.eco;
    if (lowerRace.contains('human') || lowerRace.contains('men')) return Icons.shield;
    if (lowerRace.contains('dwarf')) return Icons.diamond;
    if (lowerRace.contains('maiar') || lowerRace.contains('wizard')) return Icons.auto_fix_high;
    if (lowerRace.contains('orc') || lowerRace.contains('goblin')) return Icons.flash_on;
    return Icons.person_outline;
  }

  Widget _buildInfoChip(BuildContext context, String label, String? value, IconData icon) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: theme.colorScheme.secondary),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.secondary.withOpacity(0.1),
                border: Border.all(color: theme.colorScheme.secondary, width: 2),
              ),
              child: Center(
                child: Icon(
                  _getRaceIcon(character.race),
                  size: 60,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              character.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              character.race?.toUpperCase() ?? "NIEZNANA RASA",
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2.0,
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            
            Divider(color: theme.colorScheme.secondary.withOpacity(0.3), indent: 40, endIndent: 40),
            const SizedBox(height: 32),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                if (character.gender != null) _buildInfoChip(context, 'Płeć', character.gender, Icons.transgender),
                if (character.birth != null) _buildInfoChip(context, 'Urodzenie', character.birth, Icons.cake_outlined),
                if (character.death != null) _buildInfoChip(context, 'Śmierć', character.death, Icons.sentiment_dissatisfied),
                if (character.realm != null) _buildInfoChip(context, 'Królestwo', character.realm, Icons.map_outlined),
              ],
            ),
            
            const SizedBox(height: 48),

            Text(
              'Słowa',
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Consumer<CharacterDetailViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (viewModel.quotes.isEmpty) {
                  return Text(
                    'Milczenie jest złotem...',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[500],
                    ),
                  );
                }
                return Column(
                  children: viewModel.quotes.map((quote) => Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.03),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                      border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.format_quote, size: 32, color: theme.colorScheme.secondary.withOpacity(0.4)),
                        const SizedBox(height: 12),
                        Text(
                          quote,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: theme.primaryColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
