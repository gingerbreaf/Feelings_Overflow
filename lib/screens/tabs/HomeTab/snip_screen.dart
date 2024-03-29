import 'dart:convert';
import 'package:feelings_overflow/design/font_cards.dart';
import 'package:feelings_overflow/design/rich_text_for_posting.dart';
import 'package:feelings_overflow/functionality/TextFormatting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:feelings_overflow/functionality/selection_word.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:status_alert/status_alert.dart';

import '../../../design/font.dart';
import '../../../functionality/firebase_methods.dart';


/// This is the screen for the snippet function
/// It contains the font cards, backgrounds and formatting
class SnipScreen extends StatefulWidget {
  final QuillController quillController;
  const SnipScreen({
    Key? key,
    required this.quillController,
  }) : super(key: key);
  @override
  State<SnipScreen> createState() => _SnipScreenState();
}

class _SnipScreenState extends State<SnipScreen> {
  //TODO: optimise code by passing in 1 controller only
  String startText = '';
  final ValueNotifier<String> _textNotifier = ValueNotifier<String>('');
  final ValueNotifier<int> _selectedCardNotifier = ValueNotifier<int>(-1);
  final ValueNotifier<Font?> _selectedFontNotifier = ValueNotifier<Font?>(null);
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  int _groupValue = 0;
  String _chosenBackground = 'backgroundPastel';
  String _selectedFont = 'Rochester';

  late TextEditingController _textEditingController;

  QuillController finalController = QuillController.basic();
  @override
  void initState() {
    super.initState();
    startText = WordSelector.getPlainTextSelection(widget.quillController);
    _textEditingController = TextEditingController(text: startText);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textNotifier.dispose();
    _selectedCardNotifier.dispose();
    _selectedFontNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    finalController =
        WordSelector.createSelectedTextController(widget.quillController);

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Choose a font',
              style: GoogleFonts.getFont(
                'Rochester',
                wordSpacing: 2.0,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 4.2,
              child: CupertinoScrollbar(
                thumbVisibility: true,
                controller: _scrollController1,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController1,
                  children: [
                    FontCard(
                      quillController:
                          WordSelector.createSelectedTextController(
                              widget.quillController),
                      textNotifier: _textNotifier,
                      selectedCardNotifier: _selectedCardNotifier,
                      selectedFontNotifier: _selectedFontNotifier,
                      cardIndex: 0,
                      font: const Font(
                          fontName: 'Rochester', fontFamily: 'Rochester'),
                    ),
                    FontCard(
                      quillController:
                          WordSelector.createSelectedTextController(
                              widget.quillController),
                      textNotifier: _textNotifier,
                      selectedCardNotifier: _selectedCardNotifier,
                      selectedFontNotifier: _selectedFontNotifier,
                      cardIndex: 1,
                      font: const Font(
                          fontName: 'Leckerli', fontFamily: 'Leckerli One'),
                    ),
                    FontCard(
                      quillController:
                          WordSelector.createSelectedTextController(
                              widget.quillController),
                      textNotifier: _textNotifier,
                      selectedCardNotifier: _selectedCardNotifier,
                      selectedFontNotifier: _selectedFontNotifier,
                      cardIndex: 2,
                      font: const Font(
                          fontName: 'Fredericka',
                          fontFamily: 'Fredericka the Great'),
                    ),
                    FontCard(
                      quillController:
                          WordSelector.createSelectedTextController(
                              widget.quillController),
                      textNotifier: _textNotifier,
                      selectedCardNotifier: _selectedCardNotifier,
                      selectedFontNotifier: _selectedFontNotifier,
                      cardIndex: 3,
                      font: const Font(
                          fontName: 'Stalemate', fontFamily: 'Stalemate'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Choose a background',
              style: GoogleFonts.getFont(
                'Rochester',
                wordSpacing: 2.0,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 4.2,
              child: CupertinoScrollbar(
                thumbVisibility: true,
                controller: _scrollController2,
                child: ListView(
                  controller: _scrollController2,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _groupValue = 0;
                          _chosenBackground = 'backgroundPastel';

                          // Handle selection for value 0
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        alignment: Alignment.bottomCenter,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/images/backgroundPastel.jpg'),
                          ),
                        ),
                        child: Radio<int>(
                          value: 0,
                          groupValue: _groupValue,
                          onChanged: (value) {
                            setState(() {
                              _groupValue = value!;
                              _chosenBackground = 'backgroundPastel';
                              // Handle selection for value 0
                            });
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _groupValue = 1;
                          _chosenBackground = 'waterColourBackground';

                          // Handle selection for value 0
                        });
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/images/waterColourBackground.jpg'),
                          ),
                        ),
                        child: Radio<int>(
                          value: 1,
                          groupValue: _groupValue,
                          onChanged: (value) {
                            setState(() {
                              _groupValue = value!;
                              _chosenBackground = 'waterColourBackground';

                              // Handle selection for value 0
                            });
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _groupValue = 2;
                          _chosenBackground = 'waterColourBlueBackground';
                          // Handle selection for value 0
                        });
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/images/waterColourBlueBackground.jpg'),
                          ),
                        ),
                        child: Radio<int>(
                          value: 2,
                          groupValue: _groupValue,
                          onChanged: (value) {
                            setState(() {
                              _groupValue = value!;
                              _chosenBackground = 'waterColourBlueBackground';
                              // Handle selection for value 0
                            });
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _groupValue = 3;
                          _chosenBackground = 'vibrantBackground';
                          // Handle selection for value 0
                        });
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/images/vibrantBackground.jpg'),
                          ),
                        ),
                        child: Radio<int>(
                          value: 3,
                          groupValue: _groupValue,
                          onChanged: (value) {
                            setState(() {
                              _groupValue = value!;
                              _chosenBackground = 'vibrantBackground';
                              // Handle selection for value 0
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/$_chosenBackground.jpg'),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Preview',
                    style: GoogleFonts.getFont(
                      'Rochester',
                      wordSpacing: 2.0,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 3,
                      right: MediaQuery.of(context).size.width / 3,
                      top: MediaQuery.of(context).size.height / 14,
                    ),
                    child: RichTextDisplayPost(
                      controller: finalController,
                      interactive: false,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ValueListenableBuilder(
                      valueListenable: _selectedFontNotifier,
                      builder: (context, selectedFont, _) {
                        final String fontFamily = selectedFont != null
                            ? selectedFont.fontFamily
                            : _selectedFont;
                        return Flexible(
                          child: OutlinedButton(
                            onPressed: () {
                              if (_selectedFontNotifier.value != null) {
                                _selectedFont =
                                    _selectedFontNotifier.value!.fontFamily;
                              }
                              TextFormatting.formatTextStyle(
                                  finalController, fontFamily);
                              TextFormatting.formatSize(
                                  finalController, 'huge');
                            },
                            child: Text('Format Text',
                                style: GoogleFonts.leckerliOne(
                                    color: Colors.black)),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: const Icon(Icons.post_add_rounded),
          onPressed: () async {
            var json = jsonEncode(finalController.document.toDelta().toJson());

            FirebaseMethods.postCard(json, _chosenBackground);
            StatusAlert.show(
              context,
              duration: const Duration(seconds: 2),
              title: 'Diary posted',
              subtitle: 'Viewable for 24 hours',
              configuration: const IconConfiguration(icon: Icons.done),
              maxWidth: 260,
            );
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          }),
    );
  }
}
