String[] hexColors;

// Параметры изображения
int IMG_WIDTH = 5040;
int IMG_HEIGHT = 1176;
float TEXT_HEIGHT_PERCENT = 0.6; // <-- ИЗМЕНЕНО: 60% от высоты

// Имя шрифта
String FONT_NAME = "Monaco"; // <-- ИЗМЕНЕНО: Monaco

void setup() {
  // ==========================================
  // МЕСТО ДЛЯ ВВОДА ДАННЫХ
  // ==========================================
  hexColors = new String[] {
    "FF0000",
    "00FF00", 
    "0000FF",
    "FFFFFF",
    "808080",
    "FFA500"
    // Добавляйте сюда свои цвета
  };
  
  size(800, 200);
  background(50);
  
  println("Начинаю обработку " + hexColors.length + " цветов...");
  println("Размер шрифта: 60% от высоты (" + int(IMG_HEIGHT * TEXT_HEIGHT_PERCENT) + "px)");
  
  PFont font = createFont(FONT_NAME, 400, true);
  
  if (font == null) {
    println("Шрифт '" + FONT_NAME + "' не найден, использую стандартный моноширинный");
    font = createFont("Monospaced", 400, true);
  }
  
  // Определяем количество цифр для нумерации (например, 3 для 001, 002...)
  int numDigits = String.valueOf(hexColors.length).length();
  if (numDigits < 3) numDigits = 3; // Минимум 3 цифры (001, 002...)
  
  for (int i = 0; i < hexColors.length; i++) {
    String hex = hexColors[i].trim().toUpperCase();
    
    if (hex.length() != 6 || !hex.matches("[0-9A-F]+")) {
      println("Пропускаю неверный формат: " + hex);
      continue;
    }
    
    try {
      int r = unhex(hex.substring(0, 2));
      int g = unhex(hex.substring(2, 4));
      int b = unhex(hex.substring(4, 6));
      
      String outputText = String.format("#%02X:%02X:%02X", r, g, b);
      
      PGraphics pg = createGraphics(IMG_WIDTH, IMG_HEIGHT);
      pg.beginDraw();
      pg.background(0);
      
      pg.textFont(font);
      pg.fill(255);
      pg.textAlign(CENTER, CENTER);
      
      // Размер шрифта: 60% от высоты (~705px для 1176px)
      float fontSize = IMG_HEIGHT * TEXT_HEIGHT_PERCENT;
      pg.textSize(fontSize);
      
      // Проверка по ширине
      float textWidth = pg.textWidth(outputText);
      float maxWidth = IMG_WIDTH * 0.95;
      
      if (textWidth > maxWidth) {
        float scaleFactor = maxWidth / textWidth;
        fontSize = fontSize * scaleFactor;
        pg.textSize(fontSize);
      }
      
      // Вывод по центру
      pg.text(outputText, IMG_WIDTH / 2, IMG_HEIGHT / 2);
      pg.endDraw();
      
      // ==========================================
      // НОВЫЙ ФОРМАТ ИМЕНИ ФАЙЛА: color-text_001.png
      // ==========================================
      String filename = String.format("color-text_%0" + numDigits + "d.png", i + 1);
      pg.save(filename);
      
      println("[" + (i+1) + "/" + hexColors.length + "] " + filename + 
              " (цвет: #" + hex + ", шрифт: " + int(fontSize) + "px)");
      
    } catch (Exception e) {
      println("Ошибка с '" + hex + "': " + e.getMessage());
    }
  }
  
  println("Готово! Все файлы сохранены в: " + sketchPath());
  exit();
}

void draw() {
  background(30);
  fill(0, 255, 0);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Все изображения созданы!", width/2, height/2);
}
