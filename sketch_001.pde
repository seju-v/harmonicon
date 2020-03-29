import processing.event.*;
import processing.sound.*;
import java.util.Collection;
import java.util.function.Consumer;

final Integer root = 340;

class Voice {
  int freq;
  Oscillator osc;
  color c;
  
  Voice (int freq, Oscillator osc) {
    this.freq = freq;
    this.osc  = osc;
    this.c    = color (
      random(255) + 48,
      random(255) + 48,
      random(255) + 48
    );
    
    osc.freq(freq);
    osc.amp(0.6);
  }
}

// KEYMAP - Here be dragons!
//    v:         º   1   2   3   4   5   6   7   8   9   0   '   ¡   BACK
int[] v__keys = {186,49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 39, 161, 8};
//    iv:       tab  q   w   e   r   t   y   u   i   o   p   `   +
int[] iv_keys = { 9, 81, 87, 69, 82, 84, 89, 85, 73, 79, 80,-432,43};
//    i:       lock  a   s   d   f   g   h   j   k   l   ñ   ´   ç   enter
int[] i__keys = {20, 65, 83, 68, 70, 71, 72, 74, 75, 76,241,-431,231, 10};
//    sub:    shift  <   z   x   c   v   b   n   m   ,   .   -      menu
int[] subkeys = {16, 60, 90, 88, 67, 86, 66, 78, 77, 44, 46, 45, 153};
//    extra:  ctrl(-) alt(+)

HashMap<Integer, Voice> voices = new HashMap();

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
  strokeWeight(8);
}

void mapKeys() {
  // sub
  for (int i = subkeys.length -1; i > -1; i--) {
    int kc = subkeys[i];
    int freq = root*2 / (i+4);
    Voice v = new Voice(freq, new TriOsc(this));
    voices.put(kc, v);
  }
  
  // i
  for (int i = 0; i < i__keys.length; i++) {
    int kc = i__keys[i];
    int freq = (root/4) * (i+3);
    Voice v = new Voice(freq, new TriOsc(this));
    voices.put(kc, v);
  }
  
  // iv
  for (int i = 0; i < iv_keys.length; i++) {
    int kc = iv_keys[i];
    int freq = (root/3) * (i+2);
    Voice v = new Voice(freq, new TriOsc(this));
    voices.put(kc, v);
  }
  
  // v
  for (int i = 0; i < v__keys.length; i++) {
    int kc = v__keys[i];
    int freq = (3*root/8) * (i+1);
    Voice v = new Voice(freq, new TriOsc(this));
    voices.put(kc, v);
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
  
  for (Voice v : voices.values()) {
    // bend
    float newfreq = v.freq * bend;
    v.osc.freq(newfreq);
    
    // draw line
    if (v.osc.isPlaying()) {
      float y = map(newfreq, 2000, 0, 0, 200);
      stroke(v.c);
      line (0,y,200,y);
    }
  }
}

void keyPressed() {
  println(keyCode);
  if (voices.containsKey(keyCode)) {
    voices.get(keyCode).osc.play();
  }
  else if (keyCode == CONTROL) {
    bendStatus = bendStatuses.down;
  }
  else if (keyCode == ALT) {
    bendStatus = bendStatuses.up;
  }
}

void keyReleased() {
  if (voices.containsKey(keyCode)) {
    voices.get(keyCode).osc.stop();
  }
  else if (keyCode == CONTROL || keyCode == ALT) {
    bendStatus = bendStatuses.center;
  }
}
