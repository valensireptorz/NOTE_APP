import 'package:flutter/material.dart';
import 'package:app1/database/note_database.dart';
import 'package:app1/widgets/note_form_widgets.dart';
import 'package:app1/models/note.dart';

class AddEditNotePage extends StatefulWidget {
  const AddEditNotePage({Key? key, this.note}) : super(key: key);

  final Note? note;

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  late bool _isImportant;
  late int _number;
  late String _title;
  late String _description;
  final _formKey = GlobalKey<FormState>();
  var _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _isImportant = widget.note?.isImportant ?? false;
    _number = widget.note?.number ?? 1;
    _title = widget.note?.title ?? '';
    _description = widget.note?.description ?? '';
    _isUpdating = widget.note != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isUpdating ? 'Edit' : 'Add'),
        actions: [_buildButtonSave()], // Tombol simpan di sebelah kanan AppBar
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          isImportant: _isImportant,
          number: _number,
          title: _title,
          description: _description,
          onChangeIsImportant: (value) {
            setState(() {
              _isImportant = value;
            });
          },
          onChangeNumber: (value) {
            setState(() {
              _number = value;
            });
          },
          onChangeTitle: (value) {
            setState(() {
              _title = value;
            });
          },
          onChangeDescription: (value) {
            setState(() {
              _description = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            if (_isUpdating) {
              await _updateNote();
            } else {
              await _addNote();
            }
            Navigator.pop(context);
          }
        },
        child: const Text('Save'),
      ),
    );
  }

  Future<void> _addNote() async {
    final note = Note(
      isImportant: _isImportant,
      number: _number,
      title: _title,
      description: _description,
      createdTime: DateTime.now(),
    );

    await NoteDatabase.instance.create(note);
  }

  Future<void> _updateNote() async {
    final note = widget.note!.copyC(
      isImportant: _isImportant,
      number: _number,
      title: _title,
      description: _description,
    );

    await NoteDatabase.instance.updateNote(note);
  }
}
