import processing.event.*;
import processing.sound.*;
import java.util.Map;
import java.util.function.Consumer;

final HashMap<String, Oscillator> oscs = new HashMap();
final Integer root = 340;

//KEYS
String[] lowKeys = {"z", "x", "c", "v", "b", "n", "m", ",", ".", "-"};
String[] highKeys = {"\t", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "`", "+", "\n"};
String[] midKeys = {"a", "s", "d", "f", "g", "h", "j", "k", "l", "ñ", "´", "ç"};
String[] highestKeys = {"º", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "'", "¡"};
HashMap<String, Integer> keys = new HashMap();

// PITCH BEND
float bend = 1;
enum bendStatuses {
  up, center, down
}
bendStatuses bendStatus = bendStatuses.center;
final float bendSpeed = .2;
final float bendDepth = 9f/8;

void setup () {
  size(200, 200, P2D);
  mapKeys();
  makeOscillators();
  strokeWeight(8);
}

void mapKeys() {
  for (int i = lowKeys.length -1; i > -1; i--) { // sub
    int freq = root*2 / (i+4);
    keys.put(lowKeys[i],freq);
    keys.put(lowKeys[i].toUpperCase(),freq);
  }
  for (int i = 0; i < midKeys.length; i++) { // i
    int freq = (3*root/8) * (i+4);
    keys.put(midKeys[i],freq);
    keys.put(midKeys[i].toUpperCase(),freq);
  }
  for (int i = 0; i < highKeys.length; i++) { // i
    int freq = (root/4) * (i+3);
    keys.put(highKeys[i],freq);
    keys.put(highKeys[i].toUpperCase(),freq);
  }
  for (int i = 0; i < highestKeys.length; i++) { // iv
    int freq = (root/3) * (i+2);
    keys.put(highestKeys[i],freq);
  }
}

void makeOscillators() {
  for (Map.Entry<String, Integer> k : keys.entrySet()) {
    Integer freq = k.getValue();
    Oscillator osc = new TriOsc(this);
    osc.freq(freq);
    osc.amp(0.5);
    oscs.put(k.getKey(), osc);
  }
}

void draw () {
  background(48); // clear background

  // update bend
  switch (bendStatus) {
    case center: bend = lerp(bend, 1, bendSpeed);        break;
    case up:     bend = lerp(bend, bendDepth, bendSpeed); break;
    case down:   bend = lerp(bend, 1/bendDepth, bendSpeed); break;
  }
  
  for (Map.Entry<String, Oscillator> keyosc : oscs.entrySet()) {
    Oscillator osc = keyosc.getValue();
    
    // bend
    String letter = keyosc.getKey();
    Integer freq = keys.get(letter);
    float newfreq = freq * bend;
    osc.freq(newfreq);
    
    // draw line
    if (osc.isPlaying()) {
      float y = map(newfreq, 2000, 0, 0, 200);
      line (0,y,200,y);
    }
  }
}

void newStroke() {
  stroke(
    random(255) + 48,
    random(255) + 48,
    random(255) + 48
  );
}

void keyPressed() {
  String k = String.valueOf(key);
  newStroke();
  if (oscs.containsKey(k)) {
    oscs.get(k).play();
  }
  else if (keyCode == SHIFT) {
    bendStatus = bendStatuses.up;
  }
  else if (keyCode == CONTROL) {
    bendStatus = bendStatuses.down;
  }
}

void keyReleased() {
  String k = String.valueOf(key);
  if (oscs.containsKey(k)) {
    oscs.get(k.toUpperCase()).stop(); // absolutely necessary if
    oscs.get(k.toLowerCase()).stop(); // playing with the shift key
  }
  else if (keyCode == SHIFT || keyCode == CONTROL) {
    bendStatus = bendStatuses.center;
  }
}
