// Author: Stanislaw Adaszewski
// License: MIT

uniform ivec2 squaresMin; // = ivec2(20)
// zero disable the stepping
uniform int steps; // = 50

float d = min(progress, 1.0 - progress);
float dist = steps>0 ? ceil(d * float(steps)) / float(steps) : d;
vec2 squareSize = 2.0 * dist / vec2(squaresMin);

vec2 pixelize(vec2 uv) {
  vec2 p = dist>0.0 ? (floor(uv / squareSize) + 0.5) * squareSize : uv;
  return p;
}

#define PI 3.14159265359

uniform vec2 center; // = vec2(0.5, 0.5);
uniform float rotations; // = 1;
uniform float scale; // = 8;
uniform vec4 backColor; // = vec4(0.15, 0.15, 0.15, 1.0);

vec2 rotateScaleFade(vec2 uv, float angleBias) {
  vec2 difference = uv - center;
  vec2 dir = normalize(difference);
  float dist = length(difference);
  
  float angle = 2.0 * PI * rotations * progress + angleBias;
  
  float c = cos(angle);
  float s = sin(angle);
  
  float currentScale = mix(scale, 1.0, 2.0 * abs(progress - 0.5));
  
  vec2 rotatedDir = vec2(dir.x  * c - dir.y * s, dir.x * s + dir.y * c);
  vec2 rotatedUv = center + rotatedDir * dist / currentScale;
  
  /*if (rotatedUv.x < 0.0 || rotatedUv.x > 1.0 ||
      rotatedUv.y < 0.0 || rotatedUv.y > 1.0)
    return backColor;*/
  return rotatedUv;
}

vec4 transition (vec2 uv) {
  
  float rgbSplit = 1. - distance(0.5, progress) * 2.;
  vec2 uvR = pixelize(rotateScaleFade(uv, -.2 * rgbSplit));
  vec2 uvG = pixelize(rotateScaleFade(uv, .0));
  vec2 uvB = pixelize(rotateScaleFade(uv, .2 * rgbSplit));
  
  vec4 colorFrom = vec4(getFromColor(uvR).r,
    getFromColor(uvG).g,
    getFromColor(uvB).b, 1.);
    
  vec4 colorTo = vec4(getToColor(uvR).r,
    getToColor(uvG).g,
    getToColor(uvB).b, 1.);
    
  return mix(colorFrom, colorTo, progress);
}
