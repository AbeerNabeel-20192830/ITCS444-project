import 'package:flutter/material.dart';

class AccidentReportPage extends StatefulWidget {
  final double carValue;

  const AccidentReportPage({super.key, this.carValue = 5000.0});

  @override
  State<AccidentReportPage> createState() => _AccidentReportPageState();
}

class _AccidentReportPageState extends State<AccidentReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _damagePartsController = TextEditingController();
  final _repairCostController = TextEditingController();

  void submitReport() {
    if (_formKey.currentState!.validate()) {
      double repairCost = double.parse(_repairCostController.text);
      double threshold = widget.carValue * 0.4;
      double consumptionRate = repairCost > threshold ? 0.15 : 0.10;
      double newCarValue = widget.carValue * (1 - consumptionRate);

      String resultMessage =
          'Accident recorded.\nConsumption ratio: ${consumptionRate * 100}%\nNew car value: ${newCarValue.toStringAsFixed(2)} BD';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultMessage),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void clearFields() {
    _dateController.clear();
    _damagePartsController.clear();
    _repairCostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Accident Date',
              prefixIcon: const Icon(Icons.calendar_today),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                _dateController.text =
                    pickedDate.toLocal().toString().split(' ')[0];
              }
            },
            validator: (value) =>
                value!.isEmpty ? 'Please enter the accident date' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _damagePartsController,
            decoration: const InputDecoration(
              labelText: 'Damaged Parts',
              prefixIcon: Icon(Icons.car_repair),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Please enter the damaged parts' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _repairCostController,
            decoration: const InputDecoration(
              labelText: 'Repair Cost (BD)',
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the repair cost';
              }
              final cost = double.tryParse(value);
              if (cost == null || cost < 0) {
                return 'Enter a valid positive number';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: submitReport,
                  child: const Text('Send Report'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    clearFields();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fields cleared'),
                        backgroundColor: Color.fromARGB(255, 191, 89, 6),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Clear'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
