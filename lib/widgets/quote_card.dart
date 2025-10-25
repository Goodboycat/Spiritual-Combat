import 'package:flutter/material.dart';
import 'package:combate_espiritual/generated/l10n/app_localizations.dart';
import '../models/quote_model.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;

  const QuoteCard({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.brightness == Brightness.dark
                ? [
                    Colors.deepPurple.shade800,
                    Colors.deepPurple.shade900,
                  ]
                : [
                    Colors.white,
                    Colors.purple.shade50,
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.format_quote,
                  color: Colors.deepPurple.shade300,
                  size: 32,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getCategoryName(l10n, quote.category),
                    style: TextStyle(
                      color: Colors.deepPurple.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              quote.text,
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                fontStyle: FontStyle.italic,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.auto_stories,
                  color: Colors.deepPurple.shade300,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Lorenzo Scúpoli',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple.shade400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(AppLocalizations l10n, String category) {
    switch (category) {
      case 'warfare':
        return l10n.warfare;
      case 'humility':
        return l10n.humility;
      case 'trust':
        return l10n.trust;
      case 'perseverance':
        return l10n.perseverance;
      case 'prayer':
        return l10n.prayer;
      case 'temptation':
        return l10n.temptation;
      case 'vigilance':
        return l10n.vigilance;
      case 'peace':
        return l10n.peace;
      case 'obedience':
        return l10n.obedience;
      case 'patience':
        return l10n.patience;
      case 'love':
        return l10n.love;
      case 'faithfulness':
        return l10n.faithfulness;
      case 'meditation':
        return l10n.meditation;
      case 'devotion':
        return l10n.devotion;
      case 'examination':
        return l10n.examination;
      case 'silence':
        return l10n.silence;
      case 'purity':
        return l10n.purity;
      case 'charity':
        return l10n.charity;
      case 'suffering':
        return l10n.suffering;
      case 'virtue':
        return l10n.virtue;
      case 'faith':
        return l10n.faith;
      default:
        return category;
    }
  }
}
