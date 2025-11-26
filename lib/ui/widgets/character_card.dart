import 'package:flutter/material.dart';
import '../../data/models/character.dart';
import '../screens/detail_screen.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(character: character),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  border: Border.all(color: theme.colorScheme.secondary, width: 1),
                ),
                child: Center(
                  child: Icon(
                    _getRaceIcon(character.race),
                    color: theme.primaryColor,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                character.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 12,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                character.race ?? "Nieznana",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
