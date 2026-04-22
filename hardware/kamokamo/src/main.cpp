#include <M5Atom.h>

void setup() {
  M5.begin(true, false, true);
  delay(50);

  Serial.begin(115200);
  Serial.println("Atom Lite button test start");

  // 待機中は青
  M5.dis.drawpix(0, 0x0000ff);
}

void loop() {
  M5.update();

  if (M5.Btn.wasPressed()) {
    Serial.println("button pressed");

    // 押したら緑
    M5.dis.drawpix(0, 0x00ff00);
    delay(200);

    // 元に戻す
    M5.dis.drawpix(0, 0x0000ff);
  }
}