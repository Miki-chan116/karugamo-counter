#include <M5Atom.h>

int count = 0;
bool lastButtonState = false;
unsigned long lastPressTime = 0;

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
    unsigned long now = millis();

    // 緑に光る
    M5.dis.drawpix(0, 0x00ff00);

    if (count == 1) {
      Serial.print("count: ");
      Serial.print(count);
      Serial.println(" / interval: first press");
    } else {
      unsigned long interval = now - lastPressTime;

      Serial.print("count: ");
      Serial.print(count);
      Serial.print(" / interval: ");
      Serial.print(interval);
      Serial.println(" ms");
    }

    lastPressTime = now;

    delay(200);

    // 青に戻す
    M5.dis.drawpix(0, 0x0000ff);
  }

  lastButtonState = currentButtonState;

  delay(10);
}