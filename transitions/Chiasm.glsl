// Chiasm
// License: MIT
// Author: Stanislaw Adaszewski

uniform float rgbSplit; // = 0.05

float rand (vec2 co) {
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 transition_part(vec2 uv, float progress) {
  float a = progress/1.3 + rand(vec2(uv.x, progress/1000000.))/5.;
  a = mix(0., a, progress);
  float b = mix(0., a-0.1, progress);
  if (uv.y < 0.5 - a || uv.y > 0.5 + a)
    return getFromColor(uv);
  else if (uv.y < 0.5 - b || uv.y > 0.5 + b)
    return vec4(1.);
  else
    return getToColor(uv);
}

vec4 transition_comp(vec2 uv, float progress) {
  vec4 color = vec4(0.);
  float total;
  for (float t = 0.0; t <= 40.0; t++) {
    float ofs = progress < .5 ? mix(0., t/400., progress * 2.) :
      mix(t/400., 0., (progress-0.5)*2.);
    color += transition_part(vec2(uv.x, uv.y + ofs), progress);
    total += 1.0;
  }
  return (color/total);
}

vec4 transition(vec2 uv) {
  float p = rgbSplit * ((progress < .5) ? (progress * 2.) : (1. - (progress - 0.5) * 2.));
  return vec4(
      transition_comp(uv, progress-p).r,
      transition_comp(uv, progress).g,
      transition_comp(uv, progress+p).b,
    1.);
}
