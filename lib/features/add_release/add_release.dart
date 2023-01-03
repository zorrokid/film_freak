import 'package:flutter/material.dart';
import 'package:flutter_todo/viewmodels/release_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import '../../components/decorated_text_form_field.dart';
import '../../realm/schemas.dart';
import '../../services/release_service.dart';

class AddRelease extends StatefulWidget {
  final String barcode;
  const AddRelease({super.key, required this.barcode});

  @override
  State<StatefulWidget> createState() {
    return _AddReleaseState();
  }
}

class _AddReleaseState extends State<AddRelease> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _barcodeController;
  final releaseService = ReleaseService();

  @override
  void initState() {
    super.initState();
    _barcodeController = TextEditingController(text: widget.barcode);
    _nameController = TextEditingController();
  }

  String? _textInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter value';
    }
    return null;
  }

  void _save(Realm realm) {
    // TODO check if form valid
    ReleaseViewmodel.create(realm,
        Release(ObjectId(), _barcodeController.text, _nameController.text));
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(title: const Text('Add release')),
      body: Form(
        key: _formKey,
        child: ListView(children: [
          DecoratedTextFormField(
            controller: _nameController,
            label: 'Release name',
            required: true,
          ),
          DecoratedTextFormField(
            validator: _textInputValidator,
            controller: _barcodeController,
            label: 'Barcode',
            required: true,
          )
        ]),
      ),
      floatingActionButton: Consumer<Realm>(
        builder: (context, realm, child) {
          return FloatingActionButton(
            onPressed: () => _save(realm),
            child: const Icon(Icons.save),
          );
        },
      ),
    );
  }
}
