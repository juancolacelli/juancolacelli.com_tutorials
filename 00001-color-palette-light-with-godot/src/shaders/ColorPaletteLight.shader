shader_type canvas_item;

// Godot color palette light shader
// Author: Juan Colacelli
// Website: https://poopbits.com
// License: GNU GPLv3

uniform sampler2D color_palette;
uniform bool dark_mode = false;

vec4 getColorByMode(int index, int mode) {
  return texelFetch(color_palette, ivec2(index, mode), 0);
}

vec4 getColor(int index) {
  return getColorByMode(index, 1);
}

vec4 getLightColor(int index) {
  return getColorByMode(index, 2);
}

vec4 getDarkColor(int index) {
  return getColorByMode(index, 0);
}

int getColorPaletteIndex(vec4 color_to_find) {
  for (int i = 0; i < textureSize(color_palette, 0).x; i++) {
    if (color_to_find == getColor(i)) {
        return i;
    }
  }

  return -1;
}

void fragment() {
  vec4 pixel = texture(TEXTURE, UV);
  int color_palete_index = getColorPaletteIndex(pixel);

  if (color_palete_index > -1) {
    vec4 light_color = getLightColor(color_palete_index);
    vec4 dark_color = getDarkColor(color_palete_index);

    if (AT_LIGHT_PASS) {
      if (dark_mode) {
        COLOR = pixel
      } else {
        COLOR = light_color
      }
    } else {
      if (dark_mode) {
        COLOR = dark_color;
      } else {
        COLOR = pixel;
      }
    }
  } else {
    COLOR = vec4(1.0, 1.0, 0.0, 1.0);
  }
}
