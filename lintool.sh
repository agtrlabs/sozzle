#!/bin/sh
exit_message () {
    echo "\e[1;31m 😅 Lintool failed.\n 🪛 Check the issues.\n 🐝 Run again.\e[0m"
    exit 0
}

flutter format --set-exit-if-changed lib test || exit_message
flutter analyze lib test || exit_message
flutter test --no-pub --coverage --test-randomize-ordering-seed random

echo "\e[1;42m It's ready to go!\e[0m 🚀"