import 'package:feelings_overflow/design/font_cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feelings_overflow/design/rich_text_display.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:feelings_overflow/functionality/selection_word.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../design/font.dart';


class SnipScreen extends StatefulWidget {
  final QuillController quillController;
  const SnipScreen({Key? key, required this.quillController,}) : super(key: key);
  @override
  State<SnipScreen> createState() => _SnipScreenState();
}

class _SnipScreenState extends State<SnipScreen> {

  String startText = '';
  ValueNotifier<String> _textNotifier = ValueNotifier<String>('');
  ValueNotifier<int> _selectedCardNotifier = ValueNotifier<int>(-1);



  late TextEditingController _textEditingController;

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
    super.dispose();
  }

  void _onCardSelected(int cardIndex) {
    setState(() {
      if (_selectedCardNotifier.value == cardIndex) {
        _selectedCardNotifier.value = -1; // Deselect if the same card is tapped again
      } else {
        _selectedCardNotifier.value = cardIndex;
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: CupertinoScrollbar(
              thumbVisibility: true,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    FontCard(
                      quillController: WordSelector.createSelectedTextController(widget.quillController),
                      textNotifier: _textNotifier,
                      selectedCardNotifier: _selectedCardNotifier,
                      cardIndex: 0,
                      font: const Font(fontName: 'Rochester', fontFamily: 'Rochester'),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 8,
                    ),
                    FontCard(
                      quillController: WordSelector.createSelectedTextController(widget.quillController),
                      textNotifier: _textNotifier,
                      selectedCardNotifier: _selectedCardNotifier,
                      cardIndex: 1,
                      font: const Font(fontName: 'Leckerli', fontFamily: 'Leckerli One'),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 8,
                    ),
                    FontCard(
                      quillController: WordSelector.createSelectedTextController(widget.quillController),
                      textNotifier: _textNotifier,
                      selectedCardNotifier: _selectedCardNotifier,
                      cardIndex: 2,
                      font: const Font(fontName: 'Fredericka', fontFamily: 'Fredericka the Great'),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 8,
                    ),
                    FontCard(
                      quillController: WordSelector.createSelectedTextController(widget.quillController),
                      textNotifier: _textNotifier,
                      selectedCardNotifier: _selectedCardNotifier,
                      cardIndex: 3,
                      font: const Font(fontName: 'Stalemate', fontFamily: 'Stalemate'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*
          TextField(
            textAlign: TextAlign.center,
            controller: _textEditingController,
            onChanged: (value){
              _textNotifier.value = value;
              _selectedCardNotifier.value = -1; // Deselect when the text changes

            },
          ),
          */
          //RichTextDisplay(controller: WordSelector.createSelectedTextController(widget.quillController), interactive: false),
        ],
      ),

    );
  }
}
