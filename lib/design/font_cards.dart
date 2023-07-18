import 'package:feelings_overflow/design/font.dart';
import 'package:feelings_overflow/design/rich_text_for_posting.dart';
import 'package:feelings_overflow/functionality/TextFormatting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';




class FontCard extends StatefulWidget {
  final QuillController quillController;
  final ValueNotifier<String> textNotifier;
  final ValueNotifier<int> selectedCardNotifier;
  final int cardIndex;
  final Font font;

  const FontCard({
    required this.quillController,
    required this.textNotifier,
    required this.selectedCardNotifier,
    required this.cardIndex,
    required this.font,
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
    widget.textNotifier.addListener(() {_updateText();});

    _isSelected = (widget.selectedCardNotifier.value == widget.cardIndex);
    widget.selectedCardNotifier.addListener(_updateSelectedCard);

  }
  @override
  void dispose() {
    widget.textNotifier.removeListener(() {_updateText();});
    widget.selectedCardNotifier.removeListener(_updateSelectedCard);

    super.dispose();
  }

  void _updateText(){
    setState(() {
      _text = widget.textNotifier.value;
    });
  }



  void _updateSelectedCard() {
    setState(() {
      _isSelected = (widget.selectedCardNotifier.value == widget.cardIndex);
    });
  }

  void _onCardSelected() {
    setState(() {
      if (_isSelected) {
        widget.selectedCardNotifier.value = -1; // Deselect if the same card is tapped again
      } else {
        widget.selectedCardNotifier.value = widget.cardIndex;
      }
    });
  }

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



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance!.addPostFrameCallback((_){
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

    return Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        image:  DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/vibrantBackground.jpg'),
        ),
        border: Border.all(
            width: 2.0,
            strokeAlign: BorderSide.strokeAlignCenter
        ),
        boxShadow: [BoxShadow(blurRadius: 10)],
        shape: BoxShape.rectangle,
        color: Colors.white,

      ),
      width: MediaQuery.of(context).size.width / 4 ,
      child: Padding(
        padding: EdgeInsets.all(7.0),
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height / 6,
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
                  padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 2.0, ),
                  child: RichTextDisplayPost(
                    controller: localController,
                    interactive: false,
                  )
                  /*
                  child: Text(
                    _text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      widget.font.getFontFamily(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w100,
                    ),
                  ),

                  */
                )
            ),
            SizedBox(height: 5.0,),
            Text(
              widget.font.getFontName(),
              style: GoogleFonts.getFont(
                widget.font.getFontFamily(),
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
            Flexible(
              child: Radio<int>(
                value: widget.cardIndex,
                groupValue: widget.selectedCardNotifier.value,
                onChanged: (value) => _onCardSelected(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
