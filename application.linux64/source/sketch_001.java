import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.event.*; 
import processing.sound.*; 
import java.util.Map; 
import java.util.function.Consumer; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_001 extends PApplet {






HashMap<String, Oscillator> oscs = new HashMap();

Integer root = 340;
String[] lowKeys = {"z", "x", "c", "v", "b", "n", "m", ",", ".", "-"};
String[] highKeys = {"q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "`", "+"};
String[] highestKeys = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "'", "¡"};
HashMap<String, Integer> keys = new HashMap();

SoundObject channel;
Reverb reverb = new Reverb(this);

public void setup () {
  
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
    osc.amp(0.5f);
    oscs.put(k.getKey(), osc);
  }
}

public void draw () {
  // do nothing
}

public void keyPressed() {
  String k = String.valueOf(key);
  if (oscs.containsKey(k)) {
    oscs.get(k).play();
  }
}

public void keyReleased() {
  String k = String.valueOf(key);
  if (oscs.containsKey(k)) {
    oscs.get(k).stop();
  }
}
  public void settings() {  size(80,80, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_001" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
