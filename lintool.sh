#!/bin/bash

#minimum code coverage value
coverage_limit=70

exit_message () {
    echo -e "\e[1;31m 😅 Lintool failed.\n 🪛 Check the issues.\n 🐝 Run again.\e[0m"
    exit 0
}

flutter format --set-exit-if-changed lib test || exit_message

flutter analyze lib test || exit_message

flutter test -j 4 --no-pub --coverage --test-randomize-ordering-seed random || exit_message

coverage_output=$(genhtml coverage/lcov.info -o coverage/) # | grep -Eoh '[0-9]+.[0-9]+%')

regex="([0-9]+)\.[0-9]*%"
if [[ $coverage_output =~ $regex ]]
then
    coverage_value="${BASH_REMATCH[1]}"
    echo "Code Coverage is $coverage_value%"

    if [ $coverage_value -lt $coverage_limit ]
    then
        echo "Code Coverage must be at least $coverage_limit%"
        exit_message
    fi
else
    echo "😅 Can't detect Code Coverage Value. Check it yourself."
fi

echo -e "\e[1;32m Ready to push!\e[0m 🚀"
