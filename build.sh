#!/bin/bash

mkdir -p build

{
while read line; do
    if grep -qP "^ *\. \w+\.sh$" <<< "$line"; then
        echo
        cat $(echo $line | cut -d ' ' -f2)
        echo
    else
        echo $line
    fi
done < "main.sh"
} > build/main.sh

cp install.sh build
cp uninstall.sh build

cd build

shc -ro main -f main.sh
rm main.sh*

shc -ro install -f install.sh
rm install.sh*

shc -ro uninstall -f uninstall.sh
rm uninstall.sh*

exit 0
