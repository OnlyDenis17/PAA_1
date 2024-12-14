import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';

class Catatan {
  final int id;
  final String judul;
  final String Body;

  Catatan({required this.judul, required this.Body, required this.id});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Catatan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


class CatatanScreen extends StatefulWidget {
  const CatatanScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CatatanScreenState();
}

class _CatatanScreenState extends State<CatatanScreen> {
  final List<Catatan> notes = [
    Catatan(judul: "Hello world!", Body: "The moon is beautiful is not it?", id: 1)
  ];

  void addNote(String judul, String body) {
    if(notes.isEmpty) {
      setState(() {
        notes.add(Catatan(judul: judul, Body: body,id: 1));
      });
    } else {
      Catatan lastNote = notes.last;
      int newId = lastNote.id + 1;
      setState(() {
        notes.add(Catatan(judul: judul, Body: body,id: newId));
      });
    }
  }

  int noteIndexLookup(Catatan note) {
      return notes.indexWhere((n) => n.id == note.id);
  }

  void deleteNote(Catatan note) {
    int noteIndex = noteIndexLookup(note);
    setState(() {
      notes.removeAt(noteIndex);
    });
  }

  void updateNote(Catatan oldNote, Catatan newNote) {
    int oldNoteIndex = noteIndexLookup(oldNote);
    if (oldNoteIndex != -1) {
      setState(() {
        notes[oldNoteIndex] = newNote; // Directly replace the item
      });
    }
  }

  void _openUpdateDialog(Catatan note) {
    final _formKey = GlobalKey<FormState>(); // Create a new key for each dialog
    String updatedJudul = note.judul;
    String updatedBody = note.Body;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Catatan'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: note.judul,
                  maxLines: 1,
                  maxLength: 100,
                  decoration: const InputDecoration(labelText: 'Judul'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Judul tidak boleh kosong' : null,
                  onSaved: (value) => updatedJudul = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: note.Body,
                  maxLines: 3,
                  minLines: 1,
                  maxLength: 500,
                  decoration: const InputDecoration(labelText: 'Isi'),
                  validator: (value) => value == null || value.isEmpty ? 'Isi tidak boleh kosong' : null,
                  onSaved: (value) => updatedBody = value!,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                deleteNote(note);
                Navigator.pop(context);
              }, // Cancel
              child: const Text('Hapus'),
            ),
            FilledButton.tonal(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save(); // Save the form data
                  // Update the product
                  updateNote(note, Catatan(judul: updatedJudul, Body: updatedBody, id: note.id));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Catatan diupdate!')),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
  void _createNoteDialog() {
    final _formKey = GlobalKey<FormState>();
    String judul = "";
    String body = "";

    showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Buat Catatan"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: "",
                  decoration: const InputDecoration(labelText: 'Judul'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Judul tidak boleh kosong' : null,
                  onSaved: (value) => judul = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: "",
                  decoration: const InputDecoration(labelText: 'Isi'),
                  validator: (value) => value == null || value.isEmpty ? 'Isi tidak boleh kosong' : null,
                  onSaved: (value) => body = value!,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text('Cancel'),
            ),
            FilledButton.tonal(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save(); // Save the form data
                  // Update the product
                  addNote(judul, body);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Catatan diupdate!')),
                  );
                }
              },
              child: const Text('Buat'),
            ),
          ],
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.orange.shade500,
          centerTitle: true,
          title: Text(
            'NOTES',
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            label: const Text("Tambah"),
            icon: const Icon(Icons.edit),
            onPressed: _createNoteDialog
        ),
        endDrawer: const AppNavigationDrawer(),
        body: notes.isEmpty ?
              Center(
                child: Text("Belum ada catatan.", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500)),
              )
            :
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(notes.length, (index) {
              return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                      onTap: () {
                        _openUpdateDialog(notes[index]);
                      },
                      splashColor: Colors.orangeAccent.shade100.withAlpha(30),
                      child: Container(
                        margin: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notes[index].judul, style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.w600
                            ), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Text(notes[index].Body, style: GoogleFonts.poppins(
                                fontSize: 24
                            ), overflow: TextOverflow.ellipsis, maxLines: 3)
                          ],
                        ),
                      )
                  )
              );
            }),
          ),
        )
    );
  }
}