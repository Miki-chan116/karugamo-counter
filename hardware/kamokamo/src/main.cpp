#include <M5Atom.h>

int count = 0;
bool lastButtonState = false;

void setup() {
  M5.begin(true, false, true);
  Serial.begin(115200);
  delay(1000);

  Serial.println("Karugamo Counter Start");

  // 待機中は青
  M5.dis.drawpix(0, 0x0000ff);
}

void loop() {
  M5.update();

  bool currentButtonState = M5.Btn.isPressed();

  // 押された瞬間だけ1回カウントする
  if (currentButtonState == true && lastButtonState == false) {
    count++;

    Serial.print("count: ");
    Serial.println(count);

    // 緑に光る
    M5.dis.drawpix(0, 0x00ff00);
    delay(200);

    // 青に戻す
    M5.dis.drawpix(0, 0x0000ff);
  }

  lastButtonState = currentButtonState;

  delay(10);
}