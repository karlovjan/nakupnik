import 'package:flutter/material.dart';
import 'package:nakupnik/models/household.dart';
import 'package:nakupnik/services/household_service.dart';

class NewHouseholdPage extends StatefulWidget {
  final HouseholdService _householdService;

  const NewHouseholdPage(HouseholdService householdService, {Key? key})
      : _householdService = householdService,
        super(key: key);

  @override
  State<NewHouseholdPage> createState() => _NewHouseholdPageState();
}

class _NewHouseholdPageState extends State<NewHouseholdPage> {
  final _formKey = GlobalKey<FormState>();
  final _enterHouseholdNameController = TextEditingController();

  @override
  void dispose() {
    _enterHouseholdNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create household'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: _createBodyWidget(context),
    );
  }

  Widget _createBodyWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Zadej nazev domacnosti',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nazev domacnosti nesmi byt prazdny';
              }

              if (widget._householdService.existsHousehold(value)) {
                return 'Zadana domacnost uz existuje';
              }
              return null;
            },
            controller: _enterHouseholdNameController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await widget._householdService.addNewHousehold(
                      Household(_enterHouseholdNameController.value.text));
                  if(!mounted) {
                    return;
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Uloz'),
            ),
          ),
        ],
      ),
    );
  }
}
