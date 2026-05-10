import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final quoteProvider = Provider.of<QuoteProvider>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _buildContent(quoteProvider),
    );
  }

  Widget _buildContent(QuoteProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (provider.error != null || provider.quote == null) {
      return const Text(
        "Stay focused and keep pushing!",
        style: TextStyle(color: Colors.white),
      );
    }

    final quote = provider.quote!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.format_quote, color: Colors.white, size: 30),
        Text(
          quote.content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            "- ${quote.author}",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
