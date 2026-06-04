import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/city.dart';
import '../../providers/fighter_provider.dart';

class AddFighterScreen extends StatefulWidget {
  final City city;

  const AddFighterScreen({super.key, required this.city});

  @override
  State<AddFighterScreen> createState() => _AddFighterScreenState();
}

class _AddFighterScreenState extends State<AddFighterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _notesController = TextEditingController();
  final _houseRentController = TextEditingController();

  String _maritalStatus = 'متأهل';
  bool _isMartyr = false;
  int _numberOfWives = 1;
  int _totalChildren = 0;
  int _childrenUnder5 = 0;
  int _children5to15 = 0;
  int _childrenAbove15 = 0;
  int _schoolChildren = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('افزودن مبارز جدید')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('اطلاعات شخصی'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'نام کامل *'),
                textDirection: TextDirection.rtl,
                validator: (v) =>
                    v?.isEmpty == true ? 'نام الزامی است' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fatherNameController,
                decoration: const InputDecoration(labelText: 'نام پدر'),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _maritalStatus,
                decoration: const InputDecoration(labelText: 'وضعیت'),
                items: const [
                  DropdownMenuItem(value: 'مجرد', child: Text('مجرد')),
                  DropdownMenuItem(value: 'متأهل', child: Text('متأهل')),
                ],
                onChanged: (value) {
                  setState(() {
                    _maritalStatus = value!;
                    if (_maritalStatus == 'مجرد') _numberOfWives = 0;
                  });
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('شهید'),
                value: _isMartyr,
                onChanged: (value) => setState(() => _isMartyr = value),
              ),
              const Divider(height: 32),
              _buildSectionTitle('اطلاعات خانواده'),
              const SizedBox(height: 12),
              if (_maritalStatus == 'متأهل') ...[
                _buildNumberField('تعداد همسران', _numberOfWives,
                    (v) => setState(() => _numberOfWives = v)),
                const SizedBox(height: 12),
              ],
              _buildNumberField('تعداد کل فرزندان', _totalChildren,
                  (v) => setState(() => _totalChildren = v)),
              const SizedBox(height: 12),
              _buildNumberField('فرزندان زیر ۵ سال', _childrenUnder5,
                  (v) => setState(() => _childrenUnder5 = v)),
              const SizedBox(height: 12),
              _buildNumberField('فرزندان ۵ تا ۱۵ سال', _children5to15,
                  (v) => setState(() => _children5to15 = v)),
              const SizedBox(height: 12),
              _buildNumberField('فرزندان بالای ۱۵ سال', _childrenAbove15,
                  (v) => setState(() => _childrenAbove15 = v)),
              const SizedBox(height: 12),
              _buildNumberField('فرزندان محصل', _schoolChildren,
                  (v) => setState(() => _schoolChildren = v)),
              const Divider(height: 32),
              _buildSectionTitle('اطلاعات مالی'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _houseRentController,
                decoration: const InputDecoration(
                  labelText: 'کرایه خانه (روپیه)',
                  suffixText: 'روپیه',
                ),
                keyboardType: TextInputType.number,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'توضیحات'),
                textDirection: TextDirection.rtl,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('ثبت مبارز',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor));
  }

  Widget _buildNumberField(
      String label, int value, Function(int) onChanged) {
    return Row(
      children: [
        Expanded(
            child: Text(label, style: const TextStyle(fontSize: 14))),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: value > 0 ? () => onChanged(value - 1) : null,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value.toString(),
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => onChanged(value + 1),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final success = await context.read<FighterProvider>().addFighter(
            cityId: widget.city.id,
            fullName: _nameController.text.trim(),
            fatherName: _fatherNameController.text.trim().isEmpty
                ? null
                : _fatherNameController.text.trim(),
            maritalStatus: _maritalStatus,
            numberOfWives: _numberOfWives,
            totalChildren: _totalChildren,
            childrenUnder5: _childrenUnder5,
            children5to15: _children5to15,
            childrenAbove15: _childrenAbove15,
            schoolChildren: _schoolChildren,
            houseRent: double.tryParse(_houseRentController.text) ?? 0,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
            isMartyr: _isMartyr,
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('مبارز با موفقیت ثبت شد'),
              backgroundColor: AppTheme.successColor),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _notesController.dispose();
    _houseRentController.dispose();
    super.dispose();
  }
}
