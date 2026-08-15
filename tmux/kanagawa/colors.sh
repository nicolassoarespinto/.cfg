#!/usr/bin/env bash
# Kanagawa Color Palette

# Wave theme colors (default)
fuji_white='#dcd7ba'
sumi_ink_0='#16161d'
sumi_ink_1='#1e1f28'
sumi_ink_2='#1a1a22'
sumi_ink_3='#363646'
sumi_ink_4='#2a2a37'
sumi_ink_5='#363646'
sumi_ink_6='#54546D'
wave_aqua='#6a9589'
ronin_yellow='#ff9e3b'
spring_violet_1='#938aa9'
autumn_orange='#dca561'
wave_red='#e46876'
sakura_pink='#d27e99'

# Dragon theme colors
old_white='#c8c093'
dragon_black_0='#0d0c0c'
dragon_black_1='#12120f'
dragon_black_2='#1D1C19'
dragon_black_3='#181616'
dragon_black_4='#282727'
dragon_black_5='#393836'
dragon_orange='#b6927b'
dragon_ash='#737c73'
dragon_teal='#949fb5'
dragon_yellow='#c4b28a'
dragon_red='#c4746e'

# Lotus theme colors
lotus_white_3='#f2ecbc'
lotus_yellow_2='#836f4a'
lotus_cyan='#d7e3d8'
lotus_red_2='#d7474b'
lotus_red_4='#d9a594'
lotus_pink='#b35b79'
lotus_aqua_2='#5e857a'
lotus_teal_3='#5a7785'

set_theme() {
  case $1 in
    dragon)
      white=$old_white
      gray=$dragon_black_4
      dark_gray=$dragon_black_2
      light_purple=$dragon_orange
      dark_purple=$dragon_black_5
      cyan=$dragon_teal
      green=$dragon_ash
      orange=$dragon_yellow
      red=$dragon_red
      pink=$dragon_orange
      yellow=$dragon_yellow
      ;;
    lotus)
      white=$lotus_white_3
      gray=$lotus_yellow_2
      dark_gray=$lotus_white_3
      light_purple=$lotus_red_4
      dark_purple=$lotus_red_4
      cyan=$lotus_cyan
      green=$lotus_red_2
      orange=$lotus_aqua_2
      red=$lotus_red_4
      pink=$lotus_pink
      yellow=$lotus_teal_3
      ;;
    *)
      white=$fuji_white
      gray=$sumi_ink_4
      dark_gray=$sumi_ink_3
      light_purple=$sumi_ink_5
      dark_purple=$sumi_ink_6
      cyan=$wave_aqua
      green=$spring_violet_1
      orange=$autumn_orange
      red=$wave_red
      pink=$sakura_pink
      yellow=$ronin_yellow
      ;;
  esac
}
