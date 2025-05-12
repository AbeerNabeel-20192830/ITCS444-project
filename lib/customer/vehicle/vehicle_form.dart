import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:flutter_project/components/custom_snackbar.dart';
import 'package:flutter_project/models/vehicle.dart';
import 'package:flutter_project/models/vehicle_provider.dart';
import 'package:flutter_project/utils.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

enum FormType { create, update }

class VehicleForm extends StatefulWidget {
  final FormType formType;
  final Vehicle? vehicle;

  const VehicleForm({super.key, required this.formType, this.vehicle});

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> vehicleForm = GlobalKey<FormState>();

  // form fields
  TextEditingController customerName = TextEditingController();
  TextEditingController carModel = TextEditingController();
  TextEditingController chassisNumber = TextEditingController();
  TextEditingController manuYear = TextEditingController();
  TextEditingController regNumber = TextEditingController();
  TextEditingController passengers = TextEditingController();
  TextEditingController driverBirth = TextEditingController();
  TextEditingController carPrice = TextEditingController();
  int? driverAge;

  // animation controllers
  late final Map<String, AnimationController> _controllers;
  late final Map<String, Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = {
      'name': AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
      'model': AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
      'chassis': AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
      'year': AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
      'reg': AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
      'passengers': AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
      'birth': AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
      'price': AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
    };

    _animations = {
      for (var key in _controllers.keys)
        key: Tween<double>(begin: 0, end: 10).animate(
          CurvedAnimation(parent: _controllers[key]!, curve: Curves.elasticIn),
        )..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controllers[key]!.reset();
            }
          }),
    };
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Widget buildAnimatedField(String key, Widget child) {
    return AnimatedBuilder(
      animation: _animations[key]!,
      builder: (context, _) {
        final offset = math.sin(_animations[key]!.value) * 6;
        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Vehicle? vehicle = widget.vehicle;

    if (widget.vehicle != null && widget.formType == FormType.update) {
      vehicle = widget.vehicle!;
      customerName.text = vehicle.customerName;
      carModel.text = vehicle.carModel;
      chassisNumber.text = vehicle.chassisNumber;
      manuYear.text = vehicle.manuYear.toString();
      regNumber.text = vehicle.regNumber;
      passengers.text = vehicle.passengers.toString();
      driverBirth.text = dateToString(vehicle.driverBirth);
      carPrice.text = vehicle.carPrice.toString();

      driverAge = vehicle.driverAge();
    }

    return Form(
      key: vehicleForm,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        spacing: 16,
        children: [
          // Customer Name
          buildAnimatedField(
            'name',
            TextFormField(
              controller: customerName,
              decoration: const InputDecoration(
                  labelText: 'Customer Name', icon: Icon(Icons.person)),
              validator: (value) {
                if (value!.isEmpty) {
                  _controllers['name']!.forward();
                  return 'Customer name is required';
                }
                if (!alphaRegex.hasMatch(value)) {
                  _controllers['name']!.forward();
                  return 'Customer name cannot contain numbers or special characters';
                }
                return null;
              },
            ),
          ),

          // Car Model
          buildAnimatedField(
            'model',
            TextFormField(
              controller: carModel,
              decoration: const InputDecoration(
                  labelText: 'Car Model', icon: Icon(Icons.directions_car)),
              validator: (value) {
                if (value!.isEmpty) {
                  _controllers['model']!.forward();
                  return 'Car model is required';
                }
                if (!alphanumericRegex.hasMatch(value)) {
                  _controllers['model']!.forward();
                  return 'Car model must be alphanumeric';
                }
                return null;
              },
            ),
          ),

          // Chassis Number
          buildAnimatedField(
            'chassis',
            TextFormField(
              controller: chassisNumber,
              decoration: const InputDecoration(
                labelText: 'Chassis Number',
                icon: Icon(Icons.numbers),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  _controllers['chassis']!.forward();
                  return 'Customer name is required';
                }
                if (!alphanumericRegex.hasMatch(value)) {
                  _controllers['chassis']!.forward();
                  return 'Chassis number must be alphanumeric';
                }
                return null;
              },
            ),
          ),

          // Manufacturing Year
          buildAnimatedField(
            'year',
            TextFormField(
              controller: manuYear,
              decoration: const InputDecoration(
                labelText: 'Manufacturing Year',
                icon: Icon(Icons.date_range),
              ),
              readOnly: true,
              validator: (value) {
                if (value!.isEmpty) {
                  _controllers['year']!.forward();
                  return 'Manufacturing year is required';
                }
                return null;
              },
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Select Manufacturing Year"),
                      content: SizedBox(
                          width: 300,
                          height: 300,
                          child: YearPicker(
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
                              selectedDate: DateTime.now(),
                              onChanged: (date) {
                                Navigator.pop(context);
                                manuYear.text = date.year.toString();
                              })),
                    );
                  },
                );
              },
            ),
          ),

          // Registration Number
          buildAnimatedField(
            'reg',
            TextFormField(
              controller: regNumber,
              decoration: const InputDecoration(
                labelText: 'Registration Number',
                icon: Icon(Icons.pin),
              ),
              keyboardType: const TextInputType.numberWithOptions(),
              validator: (value) {
                if (value!.isEmpty) {
                  _controllers['reg']!.forward();
                  return 'Registrastion number is required';
                }
                if (!alphanumericRegex.hasMatch(value)) {
                  _controllers['reg']!.forward();
                  return 'Registration number must be alphanumeric';
                }
                return null;
              },
            ),
          ),

          // Number of Passengers
          buildAnimatedField(
            'passengers',
            TextFormField(
              controller: passengers,
              decoration: const InputDecoration(
                labelText: 'Number of Passengers',
                icon: Icon(Icons.airline_seat_recline_extra),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  _controllers['passengers']!.forward();
                  return 'Number of passengers is required';
                }
                if (int.tryParse(value) == null) {
                  _controllers['passengers']!.forward();
                  return 'Number of passengers must be a number';
                }
                if (int.parse(value) <= 0) {
                  _controllers['passengers']!.forward();
                  return 'Number of passengers must be positive';
                }
                return null;
              },
            ),
          ),

          // Driver's birthdate (for age)
          buildAnimatedField(
            'birth',
            TextFormField(
              controller: driverBirth,
              decoration: InputDecoration(
                  labelText: 'Driver\'s Birthdate',
                  icon: const Icon(Icons.cake),
                  suffix: Text('${driverAge ?? "0"} years')),
              readOnly: true,
              validator: (value) {
                if (value!.isEmpty) {
                  _controllers['birth']!.forward();
                  return 'Driver\'s birthdate is required';
                }
                if (driverAge! < 18) {
                  _controllers['birth']!.forward();
                  return 'Driver must be 18 or older';
                }
                return null;
              },
              onTap: () {
                showDatePicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 100),
                        lastDate: DateTime.now())
                    .then((pickedDate) {
                  if (pickedDate != null) {
                    String formattedDate = dateToString(pickedDate);
                    driverBirth.text = formattedDate;

                    setState(() {
                      driverAge =
                          AgeCalculator.age(DateTime.parse(driverBirth.text))
                              .years;
                    });
                  }
                });
              },
            ),
          ),

          // Car price when new
          buildAnimatedField(
            'price',
            TextFormField(
              controller: carPrice,
              decoration: const InputDecoration(
                  labelText: 'Car Price When New',
                  icon: Icon(Icons.attach_money),
                  suffixText: 'BHD'),
              validator: (value) {
                if (value!.isEmpty) {
                  _controllers['price']!.forward();
                  return 'Car price is required';
                }
                if (double.tryParse(value) == null) {
                  _controllers['price']!.forward();
                  return 'Car price must be a number';
                }
                if (double.parse(value) <= 0) {
                  _controllers['price']!.forward();
                  return 'Car price must be positive';
                }
                return null;
              },
            ),
          ),
          const SizedBox(),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => submitVehicle(vehicle),
                  child: Text(widget.formType == FormType.create
                      ? 'Add Vehicle'
                      : 'Update Vehicle')),
              ElevatedButton(
                  onPressed: () => vehicleForm.currentState!.reset(),
                  child: const Text('Reset'))
            ],
          ),
        ],
      ),
    );
  }

  void submitVehicle(Vehicle? vehicle) {
    if (vehicleForm.currentState!.validate()) {
      vehicleForm.currentState!.save();

      switch (widget.formType) {
        case FormType.create:
          createVehicle();
          break;
        case FormType.update:
          updateVehicle(vehicle!);
          break;
      }

      vehicleForm.currentState!.reset();
      customerName.clear();
      carModel.clear();
      chassisNumber.clear();
      manuYear.clear();
      regNumber.clear();
      passengers.clear();
      driverBirth.clear();
      carPrice.clear();
    }
  }

  void createVehicle() {
    Vehicle vehicle = Vehicle(
        customerName: customerName.text,
        carModel: carModel.text,
        chassisNumber: chassisNumber.text,
        manuYear: int.parse(manuYear.text),
        regNumber: regNumber.text,
        passengers: int.parse(passengers.text),
        driverBirth: DateTime.parse(driverBirth.text),
        carPrice: double.parse(carPrice.text));

    context.read<VehicleProvider>().addVehicle(vehicle);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar(
          'Add Success',
          'Vehicle ${chassisNumber.text} added successfully',
          ContentType.success));
  }

  void updateVehicle(Vehicle vehicle) {
    vehicle.customerName = customerName.text;
    vehicle.carModel = carModel.text;
    vehicle.chassisNumber = chassisNumber.text;
    vehicle.manuYear = int.parse(manuYear.text);
    vehicle.regNumber = regNumber.text;
    vehicle.passengers = int.parse(passengers.text);
    vehicle.driverBirth = DateTime.parse(driverBirth.text);
    vehicle.carPrice = double.parse(carPrice.text);

    context.read<VehicleProvider>().updateVehicle(vehicle);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar(
          'Update Success',
          'Vehicle ${chassisNumber.text} updated successfully',
          ContentType.success));

    Navigator.pop(context);
  }
}
