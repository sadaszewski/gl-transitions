// author: Paweł Płóciennik
// license: MIT
uniform float amplitude; // = 30
uniform float speed; // = 30
uniform float rgbSplit; // = 0.01;

vec4 water(vec2 p, float progress) {
  vec2 dir = p - vec2(.5);
  float dist = length(dir);

  if (dist > progress) {
    return mix(getFromColor( p), getToColor( p), progress);
  } else {
    vec2 offset = dir * sin(dist * amplitude - progress * speed);
    return mix(getFromColor( p + offset), getToColor( p), progress);
  }
}

vec4 transition(vec2 p) {
  return vec4(
    water(p, progress-rgbSplit).r,
    water(p, progress).g,
    water(p, progress+rgbSplit).b,
    1.
  );
}
