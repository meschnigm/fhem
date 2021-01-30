#!/bin/bash

rm controls_webserver.txt

while IFS= read -r -d '' FILE
do
    DIRNAME=`dirname $FILE`
    if ( [ $DIRNAME != "./Bilder" ] ) ; then
        TIME=$(git log --pretty=format:%cd -n 1 --date=iso -- "$FILE")
        TIME=$(TZ=Europe/Berlin date -d "$TIME" +%Y-%m-%d_%H:%M:%S)
        FILESIZE=$(stat -c%s "$FILE")
            FILE=$(echo "$FILE"  | cut -c 3-)
            printf "UPD %s %-7d %s\n" "$TIME" "$FILESIZE" "$FILE"  >> controls_webserver.txt
    fi 
done <   <(find ./ -maxdepth 4 \( -name "*.cfg" -o -name "*.html" -o -name "*.png" -o -name "SVG_ESS*" -o -name "99_*" \) -print0 | \
 sort -z -g)
