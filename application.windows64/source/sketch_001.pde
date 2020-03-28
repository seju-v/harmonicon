import processing.event.*;
import processing.sound.*;
import java.util.Map;
import java.util.function.Consumer;

HashMap<String, Oscillator> oscs = new HashMap();

Integer root = 340;
String[] lowKeys = {"z", "x", "c", "v", "b", "n", "m", ",", ".", "-"};
String[] highKeys = {"q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "`", "+"};
String[] highestKeys = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "'", "¡"};
HashMap<String, Integer> keys = new HashMap();

SoundObject channel;
Reverb reverb = new Reverb(this);

void setup () {
  size(80,80, P2D);
  background(48);

  // map keys
  for (int i = lowKeys.length -1; i > -1; i--) {
    int freq = root / (i+2);
    keys.put(lowKeys[i],freq);
  }
  for (int i = 0; i < highKeys.length; i++) {
    int freq = (root/2) * (i+2);
    keys.put(highKeys[i],freq);
  }
  for (int i = 0; i < highestKeys.length; i++) {
    int freq = (2*root/3) * (i+1);
    keys.put(highestKeys[i],freq);
  }
    
  // make oscillators
  for (Map.Entry<String, Integer> k : keys.entrySet()) {
    Integer freq = k.getValue();
    Oscillator osc = new TriOsc(this);
    osc.freq(freq);
    osc.amp(0.5);
    oscs.put(k.getKey(), osc);
  }
}

void draw () {
  // do nothing
}

void keyPressed() {
  String k = String.valueOf(key);
  if (oscs.containsKey(k)) {
    oscs.get(k).play();
  }
}

void keyReleased() {
  String k = String.valueOf(key);
  if (oscs.containsKey(k)) {
    oscs.get(k).stop();
  }
}
