import 'package:app1/database/note_database.dart';
import 'package:app1/models/note.dart';
import 'package:flutter/material.dart';
import 'package:app1/pages/add_edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note _note;
  var _isLoading = false;

  Future<void> _refreshNote() async {
    setState(() {
      _isLoading = true;
    });
    _note = await NoteDatabase.instance.getNoteById(widget.id);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
        actions: [
          _editButton(),
          _deleteButton(),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  _note.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(_note.description, style: TextStyle(fontSize: 18),)
                
                // Other widgets in your Column
              ],
            ),
    );
  }

  Widget _editButton() {
    return IconButton(
      onPressed: () async {
        if (_isLoading) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditNotePage(note: _note),
          ),
        );
        _refreshNote();
      },
      icon: const Icon(Icons.edit_outlined),
    );
  }

  Widget _deleteButton() {
    return IconButton(
      onPressed: () async {
        if (_isLoading) return;
        await NoteDatabase.instance.deleteNoteById(widget.id);
        Navigator.pop(context);
      },
      icon: const Icon(Icons.delete),
    );
  }
}
