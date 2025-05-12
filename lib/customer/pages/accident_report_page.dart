import 'package:flutter/material.dart';
import 'package:flutter_project/models/accident.dart';
import 'package:flutter_project/models/accident_provider.dart';
import 'package:flutter_project/models/vehicle.dart';
import 'package:flutter_project/utils.dart';
import 'package:provider/provider.dart';

class AccidentReportPage extends StatefulWidget {
  Vehicle vehicle;

  AccidentReportPage({super.key, required this.vehicle});

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
      double threshold = widget.vehicle.carPriceNow() * 0.4;
      double consumptionRate = repairCost > threshold ? 0.15 : 0.10;
      widget.vehicle.newCarValue =
          widget.vehicle.carPriceNow() * (1 - consumptionRate);

      Accident accident = Accident(
        vehicleId: widget.vehicle.id,
        accidentDate: DateTime.parse(_dateController.text),
        damagedParts: _damagePartsController.text,
        repairCost: repairCost,
        consumptionRate: consumptionRate,
      );

      context.read<AccidentProvider>().addAccident(accident);

      String resultMessage =
          'Accident recorded.\nConsumption ratio: ${consumptionRate * 100}%\nNew car value: ${widget.vehicle.carPriceNow().toStringAsFixed(2)} BD';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultMessage),
          backgroundColor: Colors.green,
        ),
      );
      clearFields();
    }
  }

  void clearFields() {
    _dateController.clear();
    _damagePartsController.clear();
    _repairCostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<Accident> accidentList =
        context.watch<AccidentProvider>().accidentList;

    if (context.read<AccidentProvider>().isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final filtered =
        accidentList.where((a) => a.vehicleId == widget.vehicle.id).toList();

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUnfocus,
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
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        _dateController.text =
                            pickedDate.toLocal().toString().split(' ')[0];
                      }
                    },
                    validator: (value) => value!.isEmpty
                        ? 'Please enter the accident date'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _damagePartsController,
                    decoration: const InputDecoration(
                      labelText: 'Damaged Parts',
                      prefixIcon: Icon(Icons.car_repair),
                    ),
                    validator: (value) => value!.isEmpty
                        ? 'Please enter the damaged parts'
                        : null,
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
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
                                backgroundColor:
                                    Color.fromARGB(255, 191, 89, 6),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                          ),
                          child: const Text('Clear'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Past Accidents',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              Accident accident = filtered[i];

              return Card(
                child: ListTile(
                  title: Text(
                    'Accident Date: ${dateToString(accident.accidentDate)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Damaged Parts: ${accident.damagedParts}'),
                      Text('Repair Cost: ${accident.repairCost} BHD'),
                      Text(
                          'Consumption Rate: ${accident.consumptionRate * 100}%'),
                    ],
                  ),
                ),
              );
            })
      ],
    );
  }
}
