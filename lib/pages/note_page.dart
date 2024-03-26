import 'package:app1/pages/note_detail_page.dart';
import 'package:app1/widgets/note_card_widgets.dart';
import 'package:flutter/material.dart';
import 'package:app1/database/note_database.dart';
import 'package:app1/models/note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:app1/pages/add_edit_note_page.dart';


class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late List<Note> _notes;
  var _isLoading = false;

  Future<void> _refreshNote() async {
    setState(() {
      _isLoading = true;
    });
    _notes = await NoteDatabase.instance.getAllNotes();
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
        title: const Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // final note = Note(
          //     isImportant: false,
          //     number: 1,
          //     title: 'testing 1',
          //     description: 'Data Testing',
          //     createdTime: DateTime.now());

          // await NoteDatabase.instance.create(note);
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddEditNotePage()));
          _refreshNote();
        },
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _notes.isEmpty
              ? Text('Notes Kosong')
              : MasonryGridView.count(
                  crossAxisCount: 2,
                  itemCount: _notes.length,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NoteDetailPage(id: note.id!)));
                          _refreshNote();
                        },
                        child: NoteCardWidget(note: note, index: index));
                  }),
    );
  }
}