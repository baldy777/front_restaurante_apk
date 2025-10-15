import 'dart:ui';

class ColoresStyle {

  //colores de la app
  static const Color fondo = Color(0xFFF6F1EB);
  static const Color encabezado = Color(0xFF7B8C38);
  static const Color acento = Color(0xFF5A3E2B);
  static const Color detalles = Color(0xFFA8B59E);

}

class TextoStyle {
  static final TextStyle titulo = TextStyle(
    fontFamily: "arial",
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF5A3E2B),
  );

  static final TextStyle subtitulo = TextStyle(
    fontFamily: "arial",
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF7B8C38),
  );

  static  TextStyle cuerpo = TextStyle(
    fontFamily: "arial",
    fontSize: 14,
    color: Color(0xFF2E2E2E),
  );
}
