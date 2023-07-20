/// Font class represents a Font
class Font {
  /// A fontFamily is what helps us identified the font from the pubspec yaml
  final String fontFamily;
  /// A fontName is what the font is officially known as
  final String fontName;

  /// Constructor for Font, all fonts will have a fontFamily to reference from
  const Font({required this.fontFamily, required this.fontName});


  String getFontFamily() {
    return fontFamily;
  }

  String getFontName() {
    return fontName;
  }

  /// Display the fontFamily of the font
  @override
  String toString() {
    return fontFamily;
  }


}