import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:combate_espiritual/generated/l10n/app_localizations.dart';
import '../services/app_state.dart';
import '../widgets/quote_card.dart';

class QuotesListScreen extends StatefulWidget {
  const QuotesListScreen({super.key});

  @override
  State<QuotesListScreen> createState() => _QuotesListScreenState();
}

class _QuotesListScreenState extends State<QuotesListScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedCategory;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final quoteService = appState.quoteService;
    
    final categories = quoteService.getAllCategories();
    final quotes = _selectedCategory != null
        ? quoteService.getQuotesByCategory(_selectedCategory!)
        : quoteService.getAllQuotes();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.explore,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.brightness == Brightness.dark
            ? Colors.deepPurple.shade900
            : Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: theme.brightness == Brightness.dark
                ? [
                    Colors.deepPurple.shade900,
                    Colors.black,
                  ]
                : [
                    Colors.blue.shade50,
                    Colors.purple.shade50,
                  ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Container(
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildCategoryChip(
                        context,
                        l10n.categories,
                        null,
                        _selectedCategory == null,
                      );
                    }
                    final category = categories[index - 1];
                    return _buildCategoryChip(
                      context,
                      _getCategoryName(l10n, category),
                      category,
                      _selectedCategory == category,
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: QuoteCard(quote: quotes[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    String? category,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? category : null;
          });
        },
        backgroundColor: theme.brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.white,
        selectedColor: Colors.deepPurple.shade400,
        labelStyle: TextStyle(
          color: isSelected
              ? Colors.white
              : (theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.deepPurple),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        elevation: isSelected ? 8 : 2,
        shadowColor: Colors.deepPurple.withValues(alpha: 0.4),
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
