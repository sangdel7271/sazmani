import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/city.dart';
import '../../providers/fighter_provider.dart';

class FightersListScreen extends StatefulWidget {
  final City city;

  const FightersListScreen({super.key, required this.city});

  @override
  State<FightersListScreen> createState() => _FightersListScreenState();
}

class _FightersListScreenState extends State<FightersListScreen> {
  bool _showArchived = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FighterProvider>().loadFighters(widget.city.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fighterProvider = context.watch<FighterProvider>();
    final fighters = _showArchived
        ? fighterProvider.archivedFighters
        : fighterProvider.fighters;

    return Scaffold(
      appBar: AppBar(
        title: Text('مبارزین ${widget.city.name}'),
        actions: [
          IconButton(
            icon: Icon(_showArchived ? Icons.list : Icons.archive),
            onPressed: () => setState(() => _showArchived = !_showArchived),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: fighterProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : fighters.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline,
                          size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text('هیچ مبارزی ثبت نشده است',
                          style: TextStyle(
                              fontSize: 16, color: AppTheme.textSecondary)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: fighters.length,
                  itemBuilder: (context, index) {
                    final fighter = fighters[index];
                    return _buildFighterCard(fighter);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFighterCard(fighter) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: fighter.isMartyr
              ? AppTheme.errorColor.withOpacity(0.1)
              : AppTheme.primaryColor.withOpacity(0.1),
          child: Icon(
            fighter.isMartyr ? Icons.shield : Icons.person,
            color: fighter.isMartyr
                ? AppTheme.errorColor
                : AppTheme.primaryColor,
          ),
        ),
        title: Text(fighter.fullName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            '${fighter.maritalStatus} | فرزندان: ${fighter.totalChildren}',
            style: const TextStyle(fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (fighter.houseRent > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                    'کرایه: ${fighter.houseRent.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 10)),
              ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'detail', child: Text('جزئیات')),
                const PopupMenuItem(
                    value: 'payment', child: Text('پرداخت حقوق')),
                const PopupMenuItem(value: 'debt', child: Text('ثبت بدهی')),
                const PopupMenuItem(value: 'edit', child: Text('ویرایش')),
                if (!_showArchived)
                  const PopupMenuItem(value: 'archive', child: Text('بایگانی')),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'archive':
                    context
                        .read<FighterProvider>()
                        .archiveFighter(fighter.id, widget.city.id);
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
