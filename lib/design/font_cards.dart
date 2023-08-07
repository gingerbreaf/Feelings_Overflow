import 'package:feelings_overflow/design/font.dart';
import 'package:feelings_overflow/design/rich_text_for_posting.dart';
import 'package:feelings_overflow/functionality/TextFormatting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';

/// Font Card are the cards that are displayed on the snip function screen
class FontCard extends StatefulWidget {

  /// The controller that displays the rich text
  final QuillController quillController;
  /// Text Notifier that notifies the snippet screen to display
  final ValueNotifier<String> textNotifier;
  /// Selected Card Notifier that notifies snippet screen which card is selected
  final ValueNotifier<int> selectedCardNotifier;
  /// Selected Font Notifier that notifies snippet screen which font is selected
  final ValueNotifier<Font?> selectedFontNotifier;
  /// Index of the card to identify the card
  final int cardIndex;
  /// Font used by the card
  final Font font;

  const FontCard({
    required this.quillController,
    required this.textNotifier,
    required this.selectedCardNotifier,
    required this.cardIndex,
    required this.font,
    required this.selectedFontNotifier,
  });

  @override
  State<FontCard> createState() => _FontCardState();
}

class _FontCardState extends State<FontCard> {
  String _text = '';
  bool _isSelected = false;
  QuillController localController = QuillController.basic();

  @override
  void initState() {
    super.initState();

    _text = widget.textNotifier.value;
    widget.textNotifier.addListener(() {
      _updateText();
    });

    _isSelected = (widget.selectedCardNotifier.value == widget.cardIndex);
    widget.selectedCardNotifier.addListener(_updateSelectedCard);
  }

  @override
  void dispose() {
    widget.textNotifier.removeListener(() {
      _updateText();
    });
    widget.selectedCardNotifier.removeListener(_updateSelectedCard);

    super.dispose();
  }

  /// State management to update the text displayed from what was previously selected
  void _updateText() {
    setState(() {
      _text = widget.textNotifier.value;
    });
  }

  /// Updating the screen on whichever card is selected
  void _updateSelectedCard() {
    setState(() {
      _isSelected = (widget.selectedCardNotifier.value == widget.cardIndex);

      if (_isSelected) {
        widget.selectedFontNotifier.value = widget.font;
      } else {
        widget.selectedFontNotifier.value = null;
      }
    });
  }

  ///  Changes the selection of the card and update the values accordingly
  void _onCardSelected() {
    setState(() {
      if (_isSelected) {
        widget.selectedCardNotifier.value =
        -1; // Deselect if the same card is tapped again
        _updateSelectedCard();
      } else {
        widget.selectedCardNotifier.value = widget.cardIndex;
        _updateSelectedCard();
      }
    });
  }


  /// Change the display size of the words to prevent overflow
  QuillController changeSizeAccordingly(QuillController quillController) {
    int len = quillController.document.length;
    if (0 < len && len < 20) {
      return TextFormatting.formatSize(quillController, 'huge');
    } else if (19 < len && len < 40) {
      return TextFormatting.formatSize(quillController, 'large');
    } else {
      return TextFormatting.formatSize(quillController, 'small');
    }
  }

  /// Initalize the words and fonts
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _text = widget.textNotifier.value;
      localController = widget.quillController;
      localController = TextFormatting.formatTextStyle(
        widget.quillController,
        widget.font.fontFamily,
      );
      localController = changeSizeAccordingly(localController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onCardSelected,
      child: Container(
        width: MediaQuery.of(context).size.width / 4 ,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/vibrantBackground.jpg'),
          ),
          border:
          Border.all(width: 1.0, strokeAlign: BorderSide.strokeAlignOutside),
          boxShadow: [BoxShadow(blurRadius: 5)],
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 6.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/backgroundPastel.jpg'),
                  ),
                  border: Border.all(
                    width: 2.0,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 10.0,
                    top: 2.0,
                  ),
                  child: RichTextDisplayPost(
                    controller: localController,
                    interactive: false,
                  ),
                ),
              ),
              SizedBox(height: 5.0,),
              Text(
                widget.font.getFontName(),
                style: GoogleFonts.getFont(
                  widget.font.getFontFamily(),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Container(
                height: 10.0,
                child: Radio<int>(
                  value: widget.cardIndex,
                  groupValue: widget.selectedCardNotifier.value,
                  onChanged: (value) => _onCardSelected(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
