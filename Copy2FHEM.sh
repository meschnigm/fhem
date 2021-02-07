#!/bin/bash

# Kopiere Dateien aus /opt/fhem ins Repository

echo "Willst du Daten aus /opt/fhem ins lokale Repository kopieren?"
read ANSWER
EXIT_READ=$?

[ "$EXIT_READ" != "0" ] && {
    ENDE="j"; return 111;
    }

[ `echo "$ANSWER" | wc -w` -ne 1 ] && { return 112; }
if [ "$ANSWER" = "J" ] || [ "$ANSWER" = "j" ] || [ "$ANSWER" = "Ja" ] || [ "$ANSWER" = "ja" ] 
then
    cp /opt/fhem/FHEM/00_Caterva_ESS.cfg /home/pi/Git-Clones/fhem/FHEM
    cp /opt/fhem/FHEM/00_SYSMON.cfg      /home/pi/Git-Clones/fhem/FHEM
    cp /opt/fhem/FHEM/99_myUtils.pm      /home/pi/Git-Clones/fhem/FHEM
    cp /opt/fhem/FHEM/00_Private.cfg     /home/pi/Git-Clones/fhem/FHEM
    cp /opt/fhem/FHEM/00_BusinessOptimum_Parameter.cfg     /home/pi/Git-Clones/fhem/FHEM

    cp /opt/fhem/fhem.cfg                /home/pi/Git-Clones/fhem

    cp /opt/fhem/www/gplot/SVG_ESS_GPLOT*.gplot /home/pi/Git-Clones/fhem/www/gplot

    cp -r /opt/fhem/www/images/caterva /home/pi/Git-Clones/fhem/www/images

    cp /opt/fhem/www/tablet/index.html /home/pi/Git-Clones/fhem/www/tablet
    cp /opt/fhem/www/tablet/menu.html /home/pi/Git-Clones/fhem/www/tablet
    cp /opt/fhem/www/tablet/sub1.html /home/pi/Git-Clones/fhem/www/tablet
    cp /opt/fhem/www/tablet/sub10.html /home/pi/Git-Clones/fhem/www/tablet
    cp /opt/fhem/www/tablet/sub11.html /home/pi/Git-Clones/fhem/www/tablet
    cp /opt/fhem/www/tablet/sub12.html /home/pi/Git-Clones/fhem/www/tablet

    echo "Daten kopiert"
else
    echo "Keine Daten kopiert"
fi
