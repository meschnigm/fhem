#!/bin/bash

rm controls_webserver.txt

while IFS= read -r -d '' FILE
do
    TIME=$(git log --pretty=format:%cd -n 1 --date=iso -- "$FILE")
    TIME=$(TZ=Europe/Berlin date -d "$TIME" +%Y-%m-%d_%H:%M:%S)
    FILESIZE=$(stat -c%s "$FILE")
        FILE=$(echo "$FILE"  | cut -c 3-)
        printf "UPD %s %-7d %s\n" "$TIME" "$FILESIZE" "$FILE"  >> controls_webserver.txt
done <   <(find ./ -maxdepth 4 \( -name "*.cfg" -o -name "*.html" -o -name "SVG_ESS*" \) -print0 | sort -z -g)
