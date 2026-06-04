import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/city_provider.dart';
import '../../providers/auth_provider.dart';

class CitiesListScreen extends StatefulWidget {
  const CitiesListScreen({super.key});

  @override
  State<CitiesListScreen> createState() => _CitiesListScreenState();
}

class _CitiesListScreenState extends State<CitiesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CityProvider>().loadCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cityProvider = context.watch<CityProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت شهرها'),
        actions: [
          if (authProvider.isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddCityDialog(),
            ),
        ],
      ),
      body: cityProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cityProvider.cities.isEmpty
              ? const Center(
                  child: Text('هیچ شهری ثبت نشده است',
                      style: TextStyle(
                          fontSize: 16, color: AppTheme.textSecondary)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cityProvider.cities.length,
                  itemBuilder: (context, index) {
                    final city = cityProvider.cities[index];
                    return _buildCityCard(city);
                  },
                ),
    );
  }

  Widget _buildCityCard(city) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.location_city, color: AppTheme.primaryColor),
        ),
        title: Text(city.name,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: city.description != null
            ? Text(city.description!, style: const TextStyle(fontSize: 12))
            : null,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('ویرایش')),
            const PopupMenuItem(value: 'archive', child: Text('بایگانی')),
          ],
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditCityDialog(city);
                break;
              case 'archive':
                context.read<CityProvider>().archiveCity(city.id);
                break;
            }
          },
        ),
      ),
    );
  }

  void _showAddCityDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('افزودن شهر جدید'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'نام شهر'),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'توضیحات (اختیاری)'),
              textDirection: TextDirection.rtl,
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('انصراف')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                await context.read<CityProvider>().addCity(
                      nameController.text.trim(),
                      description: descController.text.trim().isEmpty
                          ? null
                          : descController.text.trim(),
                    );
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('افزودن'),
          ),
        ],
      ),
    );
  }

  void _showEditCityDialog(city) {
    final nameController = TextEditingController(text: city.name);
    final descController =
        TextEditingController(text: city.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ویرایش شهر'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'نام شهر'),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'توضیحات'),
              textDirection: TextDirection.rtl,
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('انصراف')),
          ElevatedButton(
            onPressed: () async {
              await context.read<CityProvider>().updateCity(
                    city.id,
                    nameController.text.trim(),
                    description: descController.text.trim(),
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('ذخیره'),
          ),
        ],
      ),
    );
  }
}
