#!/bin/sh
brew install create-dmg
test -f random_questions.dmg && rm random_questions.dmg
create-dmg \
  --volname "随机抽题系统" \
  --volicon "./AppIcon.icns" \
  --window-pos 200 120 \
  --window-size 800 500 \
  --icon-size 100 \
  --icon "random_questions.app" 200 190 \
  --hide-extension "random_questions.app" \
  --app-drop-link 600 185 \
  "random_questions.dmg" \
  "../build/macos/Build/Products/Release/random_questions.app"

