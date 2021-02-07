##############################################
# $Id: myUtilsTemplate.pm 21509 2020-03-25 11:20:51Z rudolfkoenig $
#
# Save this file as 99_myUtils.pm, and create your own functions in the new
# file. They are then available in every Perl expression.

package main;

use strict;
use warnings;

sub
myUtils_Initialize($$)
{
  my ($hash) = @_;
}

# Enter you functions below _this_ line.


sub 
readfromcaterva_BusinessOptimum_config()
{ 

#my $config_skalar  = `tail -1 /opt/fhem/log/BusinessOptimum.config_caterva`;
my $config_skalar = `ssh admin\@caterva "tail -1 /home/admin/bin/BusinessOptimum.config"`;
my @config_array=split(/\;/,$config_skalar);
my $new_counter_increment = $config_array[12]+$config_array[13];

#Log 1, "Von Caterva eingelesene BO Config: $config_skalar";
#Log 1, "Lokal vor  Update:                  ".ReadingsVal("write_settings","Data","999");


if ($config_array[0] ne ReadingsNum("P_in_W_chargeStandbyThreshold","state",0)) {fhem("set P_in_W_chargeStandbyThreshold $config_array[0]")};
if ($config_array[1] ne ReadingsNum("P_in_W_chargeStandbyThreshold_hyst","state",0)) {fhem("set P_in_W_chargeStandbyThreshold_hyst $config_array[1]")};
if ($config_array[2] ne ReadingsNum("P_in_W_dischargeStandbyThreshold","state",0)) {fhem("set P_in_W_dischargeStandbyThreshold $config_array[2]")};
if ($config_array[3] ne ReadingsNum("P_in_W_dischargeStandbyThreshold_delay","state",0)) {fhem("set P_in_W_dischargeStandbyThreshold_delay $config_array[3]")};
if ($config_array[4] ne ReadingsNum("P_in_W_dischargeStandbyThreshold_hyst","state",0)) {fhem("set P_in_W_dischargeStandbyThreshold_hyst $config_array[4]")};
if ($config_array[5] ne ReadingsNum("SoC_max","state",0)) {fhem("set SoC_max $config_array[5]")};
if ($config_array[6] ne ReadingsNum("SoC_charge","state",0)) {fhem("set SoC_charge $config_array[6]")};
if ($config_array[7] ne ReadingsNum("SoC_discharge","state",0)) {fhem("set SoC_discharge $config_array[7]")};
if ($config_array[8] ne ReadingsNum("SoC_min","state",0)) {fhem("set SoC_min $config_array[8]")};
if ($config_array[9] ne ReadingsNum("SoC_err","state",0)) {fhem("set SoC_err $config_array[9]")};
if ($config_array[10] ne ReadingsNum("counter_discharge_to_standby_max","state",0)) {fhem("set counter_discharge_to_standby_max $config_array[10]")};
if ($config_array[11] ne ReadingsNum("counter_standby_to_discharge_max","state",0)) {fhem("set counter_standby_to_discharge_max $config_array[11]")};
if ($new_counter_increment ne ReadingsNum("counter_increment","state",0)) {fhem("set counter_increment $new_counter_increment")};
if ($config_array[14] == 112) {
	#Log 1, "habe 112 erkannt";
	#	fhem("set system_initialization DEAKTIVIERT")
	}
elsif ($config_array[14] == 1112) {
	#Log 1, "habe 1112 erkannt";
#	fhem("set system_initialization AKTIV");
	};


if ($config_array[15] ne ReadingsVal("ECS3_configuration","state","999")) {fhem("set ECS3_configuration $config_array[15]")};
if ($config_array[16] == 1) {
	#Log 1, "habe 1 - BusinessOptimumStarter Konfig erkannt";
	#	fhem("set BusinessOptimum_BOS BusinessOptimum_standalone")
	}
elsif ($config_array[16] == 0) {
	#Log 1, "habe 0 BusinessOptimum Standalone erkannt";
	#	fhem("set BusinessOptimum_BOS BusinessOptimumStarter")
}
	
#Log 1, "Lokal nach Update:                  ".ReadingsVal("write_settings","Data","999");
}

#	setreading system_initialization Initstatus 112;
#	setreading system_initialization Initstatus 1112;
#	setreading BusinessOptimum_BOS Initstatus 1;
#	setreading BusinessOptimum_BOS Initstatus 0;

#########################################################################
# Unterprogramme zur Umwandlung der Fehlerbits in Klartext
# Aufruf: z.B.  {return_WarAlm_Failures(ReadingsVal("SwDER_LLN0","WarAlm","0"))}
# Zur Anzeige in Tablet UI - sub11.html

sub 
return_WarAlm_Failures(@) 
{
my $name = "WarAlm";
my $failureflags_r = shift;
my $failureflags = reverse($failureflags_r);
my @failureflags = split //, sprintf $failureflags;
my @failuretext = (
'WarAlm(0)  -  Kurzzeitige Inkonsistenz der Leistungsmessungen am internen EHZ und Wechselrichter-Alarm kann ignoriert werden.',
'WarAlm(1)  -  Kurzzeitige Inkonsistenz der Leistungsvorgabe und Leistungsmessung am Wechselrichter-Alarm kann ignoriert werden.',
'WarAlm(2)  -  Lastwiderstand kann im Moment nicht angeschaltet werden, da zu heiß-Keine Aktion nötig - Lastwiderstand regeneriert sich selbst.',
'WarAlm(3)  -  Lastwiderstand kann im Moment nicht angeschaltet werden, da in Regnerationspahse-Keine Aktion nötig - Lastwiderstand regeneriert sich selbst.',
'WarAlm(4)  -  Lastwiderstand wurde mit höherer Leistung eingestellt als dies die Betriebslogik angefordert hat.-Alarm kann ignoriert werden.',
'WarAlm(5)  -  Lastwiderstand wurde mit niedrigerer Leistung eingestellt als dies die Betriebslogik angefordert hat.-Alarm kann ignoriert werden.',
'WarAlm(6)  -  Es können kurzzeitig keine Werte aus dem HH Leistungsmesser gelesen werden-Alarm kann ignoriert werden.',
'WarAlm(7)  -  Es können kurzzeitig keine Werte aus dem PV Leistungsmesser gelesen werden-Alarm kann ignoriert werden.',
'WarAlm(8)  -  Es können kurzzeitig keine Werte aus dem internen ehz gelesen werden-Alarm kann ignoriert werden.',
'WarAlm(9)  -  Es konnten kurzzeitig keine Werte aus dem Frequenzmessgerät gelesen werden!-Alarm kann ignoriert werden.',
'WarAlm(10) -  Batterie hat einen niedrigen Ladestand. Baldige automatisierte Nachladung der Batterie aus dem Netz.-Alarm kann ignoriert werden.',
'WarAlm(11) -  Unterschied in den Zellspannungen übertrifft 60 mV-Alarm kann ignoriert werden.',
'WarAlm(12) -  Neg. Regelleistung, die dem ESS vom CC zugeteilt ist, kann im Anforderungsfall nicht geleistet werden-Alarm kann ignoriert werden.',
'WarAlm(13) -  Pos. Regelleistung, die dem ESS vom CC zugeteilt ist, kann im Anforderungsfall nicht geleistet werden-Alarm kann ignoriert werden.',
'WarAlm(14) -  nicht belegt',
'WarAlm(15) -  Hohe PV-Pufferleistung-Alarm kann ignoriert werden.',
'WarAlm(16) -  Kommunikation zwischen den beiden lokalen Steuergeräten ist kurzfristig unterbrochen-Alarm kann ignoriert werden.',
'WarAlm(17) -  ESS hat keine Rückmeldung von der Leitstelle erhalten.-Alarm kann ignoriert werden.',
'WarAlm(18) -  Lesen des externen EHZ ist fehlgeschlagen.-Alarm kann ignoriert werden.',
'WarAlm(19) -  Im Moment erhält das ESS seine Frequenz vom Server-Alarm kann ignoriert werden.',
'WarAlm(20) -  Wechselrichter sendet eine Fehlermeldung-Alarm kann ignoriert werden.',
'WarAlm(21) -  Verbindungsqualität ESS / Leitstelle ist schlecht.',
'WarAlm(22) -  Messung der Leistung am Hausanschluss nicht möglich, Messgerät nicht verfügbar!',
'WarAlm(23) -  Messung der PV-Leistung nicht möglich, Messgerät nicht verfügbar!',
'WarAlm(24) -  ESS hat keine Verbindung zum Frequenzserver.-Alarm kann ignoriert werden.',
'WarAlm(25) -  PV-Pufferung ist deaktiviert.-Alarm kann ignoriert werden.',
'WarAlm(26) -  Lokales Steuergerät meldet eine Warnung.-Alarm kann ignoriert werden.',
'WarAlm(27) -  Batterie Steuergerät (BMM) meldet eine Warnung.-Alarm kann ignoriert werden.',
'WarAlm(28) -  nicht belegt',
'WarAlm(29) -  nicht belegt',
'WarAlm(30) -  nicht belegt',
'WarAlm(31) -  nicht belegt',
);

if ($#failureflags != $#failuretext) {die "Die Anzahl Fehler passt nicht zu definierten Fehlertexten. FailureFlags: $#failureflags Texte: $#failuretext \n\n"};
#for(0..31) {fhem("deletereading dummy_Fehlerspeicher $name$_");}
my $count = 0;

foreach(@failureflags){
					if ($failureflags[$count] > 0){
							fhem("setreading dummy_Fehlerspeicher $name$count $failuretext[$count]");
							} 
					else {fhem("deletereading dummy_Fehlerspeicher $name$count")}
					
					$count ++;
					}
}

sub 
return_BusAlm_Failures(@) 
{
my $name = "BusAlm";
my $failureflags_r = shift;
my $failureflags = reverse($failureflags_r);
my @failureflags = split //, sprintf $failureflags;
my @failuretext = (
'BusAlm(0)  -  Keine Regelleistung möglich, da in Zwangsnachladung aufgrund niedrigem SOCs',
'BusAlm(1)  -  Abweichung zwischen Soll- und Istleistung, Leistung eingeschränkt.',
'BusAlm(2)  -  Systemleistung maximal, Abweichungen möglich!',
'BusAlm(3)  -  Ausfall der Frequenzmessung!',
'BusAlm(4)  -  ESS hat keine Rückmeldung von der Leitstelle erhalten.',
'BusAlm(5)  -  nicht belegt',
'BusAlm(6)  -  ESS erbringt keine Regelleistung!',
'BusAlm(7)  -  ESS ist im Inselnetzbetrieb!',
'BusAlm(8)  -  Parameter der Betriebslogik sind nicht plausibel',
'BusAlm(9)  -  ESS wird auf neutralen Ladestand gebracht',
'BusAlm(10) -  Leistungstest ist geplant',
'BusAlm(11) -  Leistungstest wird durchgeführt',
'BusAlm(12) -  nicht belegt',
'BusAlm(13) -  nicht belegt',
'BusAlm(14) -  nicht belegt',
'BusAlm(15) -  nicht belegt',
'BusAlm(16) -  nicht belegt',
'BusAlm(17) -  nicht belegt',
'BusAlm(18) -  nicht belegt',
'BusAlm(19) -  nicht belegt',
'BusAlm(20) -  nicht belegt',
'BusAlm(21) -  nicht belegt',
'BusAlm(22) -  nicht belegt',
'BusAlm(23) -  nicht belegt',
'BusAlm(24) -  nicht belegt',
'BusAlm(25) -  nicht belegt',
'BusAlm(26) -  nicht belegt',
'BusAlm(27) -  nicht belegt',
'BusAlm(28) -  nicht belegt',
'BusAlm(29) -  nicht belegt',
'BusAlm(30) -  nicht belegt',
'BusAlm(31) -  nicht belegt',
);

if ($#failureflags != $#failuretext) {die "Die Anzahl Fehler passt nicht zu definierten Fehlertexten. FailureFlags: $#failureflags Texte: $#failuretext \n\n"};
#for(0..31) {fhem("deletereading dummy_Fehlerspeicher $name$_")}

my $count = 0;
foreach(@failureflags){
					if ($failureflags[$count] > 0){
							fhem("setreading dummy_Fehlerspeicher $name$count $failuretext[$count]");
							} 
					else {fhem("deletereading dummy_Fehlerspeicher $name$count")}
					$count ++;
					}
}

sub 
return_CcAlm_Failures(@) 
{
my $name = "CcAlm";
my $failureflags_r = shift;
my $failureflags = reverse($failureflags_r);
my @failureflags = split //, sprintf $failureflags;
my @failuretext = (
'CcAlm(0)  -  ESS ist nicht verfügbar!',
'CcAlm(1)  -  Kapazität der Batterien reicht für positive Regelleistung nicht aus!',
'CcAlm(2)  -  Kapazität der Batterien reicht für angeforderte Energieabgabe nicht aus!',
'CcAlm(3)  -  Kapazität der Batterien reicht für angeforderte Energieaufnahme nicht aus!',
'CcAlm(4)  -  Anzahl der ESS im Schwarm reicht für die Erbringung von maximaler Regelleistung nicht aus!',
'CcAlm(5)  -  In der Zukunft wird ein kritischer Ladezustand des Schwarms erreicht!',
'CcAlm(6)  -  In der Zukunft wird der Schwarm die angeforderte Leistung nicht erbringen können!',
'CcAlm(7)  -  Ladestand der Batterien reicht für negative Regelleistung nicht aus!',
'CcAlm(8)  -  Kritischer Zustand erreicht! Schwarm Ladezustand außerhalb Zielbereich!',
'CcAlm(9)  -  Schwarm Ladezustand zu gering!',
'CcAlm(10) -  Schwarm Ladezustand zu hoch!',
'CcAlm(11) -  Schwarm Ladezustand zu gering! Kritischer Zustand erreicht!',
'CcAlm(12) -  Schwarm Ladezustand zu hoch! Kritischer Zustand erreicht!',
'CcAlm(13) -  nicht belegt',
'CcAlm(14) -  nicht belegt',
'CcAlm(15) -  nicht belegt',
'CcAlm(16) -  nicht belegt',
'CcAlm(17) -  nicht belegt',
'CcAlm(18) -  nicht belegt',
'CcAlm(19) -  nicht belegt',
'CcAlm(20) -  nicht belegt',
'CcAlm(21) -  nicht belegt',
'CcAlm(22) -  nicht belegt',
'CcAlm(23) -  nicht belegt',
'CcAlm(24) -  nicht belegt',
'CcAlm(25) -  nicht belegt',
'CcAlm(26) -  nicht belegt',
'CcAlm(27) -  nicht belegt',
'CcAlm(28) -  nicht belegt',
'CcAlm(29) -  nicht belegt',
'CcAlm(30) -  nicht belegt',
'CcAlm(31) -  nicht belegt',
);

if ($#failureflags != $#failuretext) {die "Die Anzahl Fehler passt nicht zu definierten Fehlertexten. FailureFlags: $#failureflags Texte: $#failuretext \n\n"};

#for(0..31) {fhem("deletereading dummy_Fehlerspeicher $name$_")}

my $count = 0;
foreach(@failureflags){
					if ($failureflags[$count] > 0){
							fhem("setreading dummy_Fehlerspeicher $name$count $failuretext[$count]");
							} 
					else {fhem("deletereading dummy_Fehlerspeicher $name$count")}
					$count ++;
					}
}

sub 
return_InoAlm_Failures(@) 
{
my $name = "InoAlm";
my $failureflags_r = shift;
my $failureflags = reverse($failureflags_r);
my @failureflags = split //, sprintf $failureflags;
my @failuretext = (
'InoAlm(0)  -  Eingangsdaten für die Betriebslogik sind nicht plausibel',
'InoAlm(1)  -  Rechenergebnis der Betriebslogik ist nicht plausibel',
'InoAlm(2)  -  Fehler am Wechselrichter lässt sich nicht quittieren.-ESS deaktivieren!',
'InoAlm(3)  -  Inkonsistenz der Leistungsvorgabe und Leisttungsmessung am Wechselrichter-ESS deaktivieren!',
'InoAlm(4)  -  Wechselrichter ist abgeschaltet und sendet eine Fehlermeldung-ESS deaktivieren!',
'InoAlm(5)  -  Inkonsistenz der Leistungsmessung am internen EHZ und am Wechselrichters-ESS deaktivieren!',
'InoAlm(6)  -  Batterie ist in der Initialisierung und nicht in Betrieb-ESS nach zwei Minuten deaktivieren! !',
'InoAlm(7)  -  Batterie ist nicht betriebsbereit, Batterieschütz ist offen-ESS deaktivieren!',
'InoAlm(8)  -  Berechnung der Batterieleistungsgrenzen fehlgeschlagen evtl sind die gesendeten Batteriedaten nicht plausibel-ESS nach zwei Minuten deaktivieren!',
'InoAlm(9)  -  Batteriedaten sind nicht plausibel oder werden nicht gesendet-ESS nach zwei Minuten deaktivieren!',
'InoAlm(10) -  Batterie meldet einen Fehler-ESS deaktivieren!',
'InoAlm(11) -  Lokales Steuergerät kann die Kommunikation zur Batterie nicht aufbauen.-ESS nach zwei Minuten deaktivieren!',
'InoAlm(12) -  ESS ist in nicht funktionstüchtigem Systemzustand, Reset notwendig-ESS deaktivieren und nach 30 Sekunden wieder aktivieren!',
'InoAlm(13) -  Fehler in der Messung der Leistungaufnahme des Haushalts!-ESS bei wiederholtem Auftreten deaktivieren! ',
'InoAlm(14) -  Fehler in der Messung der PV-Leistung!-ESS bei wiederholtem Auftreten deaktivieren! ',
'InoAlm(15) -  Berechnung der Phasenleistungsgrenzen des HA fehlgeschlagen evtl sind die gesendeten Messdaten (HH u. PV) nicht plausibel-ESS bei wiederholtem Auftreten deaktivieren! ',
'InoAlm(16) -  HH oder PV Messdaten sind nicht plausibel oder werden nicht gesendet-ESS bei wiederholtem Auftreten deaktivieren!',
'InoAlm(17) -  Überprüfung der Spannungen am Haushaltsanschluss fehlgeschlagen evtl sind die gesendeten Messdaten (HH) nicht plausibel-ESS bei wiederholtem Auftreten deaktivieren!',
'InoAlm(18) -  HH Spannungswerte sind nicht plausibel oder werden nicht gesendet-ESS bei wiederholtem Auftreten deaktivieren!',
'InoAlm(19) -  Kommunikation zwischen den beiden lokalen Steuergeräten ist unterbrochen-ESS bei wiederholtem Auftreten deaktivieren!',
'InoAlm(20) -  Messung des Haushaltsverbrauchs nicht möglich!-ESS bei wiederholtem Auftreten deaktivieren!',
'InoAlm(21) -  Messung der PV-Leistung nicht möglich!-ESS bei wiederholtem Auftreten deaktivieren!',
'InoAlm(22) -  Batterie ist nicht in Betrieb da im Energiesparmodus',
'InoAlm(23) -  Steuerungssoftware versagt-ESS deaktivieren!',
'InoAlm(24) -  Anlagenschutz versagt-ESS deaktivieren!',
'InoAlm(25) -  Initialisierung des Stromzählers des ESS ist fehlgeschlagen.-ESS bei wiederholtem Auftreten deaktivieren!',
'InoAlm(26) -  Batteriedaten lassen keine Lade- oder Entlade-Leistung zu.',
'InoAlm(27) -  Wechselrichterdaten lassen keine Lade- oder Entleistung zu. ',
'InoAlm(28) -  Die Steuerungssoftware reagiert nicht',
'InoAlm(29) -  Lokale Steuerung meldet einen Systemfehler-ESS deaktivieren!',
'InoAlm(30) -  Die Wechselrichterüberwachung hat einen Fehler festgestellt-ESS deaktivieren!',
'InoAlm(31) -  1-nicht belegt',
);

if ($#failureflags != $#failuretext) {die "Die Anzahl Fehler passt nicht zu definierten Fehlertexten. FailureFlags: $#failureflags Texte: $#failuretext \n\n"};

#for(0..31) {fhem("deletereading dummy_Fehlerspeicher $name$_")}

my $count = 0;
foreach(@failureflags){
					if ($failureflags[$count] > 0){
							fhem("setreading dummy_Fehlerspeicher $name$count $failuretext[$count]");
							} 
					else {fhem("deletereading dummy_Fehlerspeicher $name$count")}
					$count ++;
					}
}

sub 
return_MacAlm_Failures(@) 
{
my $name = "MacAlm";
my $failureflags_r = shift;
my $failureflags = reverse($failureflags_r);
my @failureflags = split //, sprintf $failureflags;
my @failuretext = (
'MacAlm(0)  -  Selbsttest des Rauchmelders fehlgeschlagen - Wartungsprozess anstoßen!',
'MacAlm(1)  -  Batterie des ESS verlangt nach einem Self-Test - Wartungsprozess anstoßen!',
'MacAlm(2)  -  Fehler in der Summenmessung PV + Haushalt - Keine Aktion nötig.',
'MacAlm(3)  -  nicht belegt',
'MacAlm(4)  -  Summenmessung PV + Haushalt nicht möglich, ext. Messgerät nicht verfügbar - Keine Aktion nötig.',
'MacAlm(5)  -  Unterschied in den Zellspannungen übertrifft 120 mV - Keine Aktion nötig.',
'MacAlm(6)  -  Primärregelenergie wird nicht gezählt - Wartungsprozess anstoßen!',
'MacAlm(7)  -  Eigenverbrauchserhöhung wird nicht gezählt - Wartungsprozess anstoßen!',
'MacAlm(8)  -  Fahrplangeschäfte werden nicht gezählt - Wartungsprozess anstoßen!',
'MacAlm(9)  -  Angefragter Doppelhöcker kann nicht ausgeführt werden - Sollte gerade gar kein Doppelhöcker gefahren werden: Wartungsprozess anstoßen!',
'MacAlm(10) -  Lokale Frequenzmessung nicht möglich, Messgerät nicht verfügbar! - Bei wiederholtem Auftreten Caterva in Übergabe benachrichtigen!',
'MacAlm(11) -  Lastwiderstand nicht einsatzbereit wegen ungültiger Messwerte - Bei wiederholtem Auftreten Caterva in Übergabe benachrichtigen!',
'MacAlm(12) -  Soft Asset Protection ist abgeschaltet. - System sofort deaktivieren - Bei wiederholtem Auftreten Caterva in Übergabe benachrichtigen!',
'MacAlm(13) -  Lastwiderstand nicht einsatzbereit wegen ungültiger Messwerte - Bei wiederholtem Auftreten Caterva in Übergabe benachrichtigen!',
'MacAlm(14) -  Datenspeicher fast voll - Wartungsprozess anstoßen!',
'MacAlm(15) -  Die Vorladung des Zwischenkreises ist fehlgeschlagen - Wartungsprozess anstoßen!',
'MacAlm(16) -  Die Frequenzmessung des ESS weicht von der Frequenzmessung des Servers ab. - Bei längerem Auftreten: Wartungsprozess anstoßen!',
'MacAlm(17) -  Fehler im Datensammler für die Endkunden-App - Wartungsprozess anstoßen!',
'MacAlm(18) -  Fehler bei der Durchführung des Selbsttests - Wartungsprozess anstoßen!',
'MacAlm(19) -  Sekundärregelenergie wird nicht gezählt - Wartungsprozess anstoßen!',
'MacAlm(20) -  ESS führt eine (u.Ust. längere) geplante Wartungsoperation durch. - Keine Aktion nötig. ESS bitte nicht deaktivieren.',
'MacAlm(21) -  nicht belegt',
'MacAlm(22) -  nicht belegt',
'MacAlm(23) -  nicht belegt',
'MacAlm(24) -  nicht belegt',
'MacAlm(25) -  nicht belegt',
'MacAlm(26) -  nicht belegt',
'MacAlm(27) -  nicht belegt',
'MacAlm(28) -  nicht belegt',
'MacAlm(29) -  nicht belegt',
'MacAlm(30) -  nicht belegt',
'MacAlm(31) -  nicht belegt',
);


if ($#failureflags != $#failuretext) {die "Die Anzahl Fehler passt nicht zu definierten Fehlertexten. FailureFlags: $#failureflags Texte: $#failuretext \n\n"};

#for(0..31) {fhem("deletereading dummy_Fehlerspeicher $name$_")}

my $count = 0;
foreach(@failureflags){
					if ($failureflags[$count] == 1 ){
							fhem("setreading dummy_Fehlerspeicher $name$count $failuretext[$count]");
							} 
					else {fhem("deletereading dummy_Fehlerspeicher $name$count")}
					$count ++;
					}
}

sub 
return_SafAlm_Failures(@) 
{
my $name = "SafAlm";
my $failureflags_r = shift;
my $failureflags = reverse($failureflags_r);
my @failureflags = split //, sprintf $failureflags;
my @failuretext = (
'SafAlm(0)  -  Tür ist nicht verschlossen! - ESS deaktivieren! Erst nach Klärung quittieren!',
'SafAlm(1)  -  Not-Aus vor Ort gedrückt oder automatisch ausgelöst (Ausgelöst durch andere rot/schwarze Alarme oder auch durch Stromausfall möglich) - Besitzer anfragen! Auf weitere Alarme achten! Erst nach Klärung quittieren!',
'SafAlm(2)  -  Überflutungsalarm oder Überhitzung! - Erst nach Klärung quittieren! ',
'SafAlm(3)  -  Rauchalarm! - ESS deaktivieren! Feuerwehr benachrichtigen! ',
'SafAlm(4)  -  Luftfeuchtigkeit überschreitet Grenzwert - Besitzer anfragen! Nach Klärung und Lösung durch Besitzer quittieren! ',
'SafAlm(5)  -  Netzausfall am ESS! Netzparameter außerhalb der Regelwerte',
'SafAlm(6)  -  Übertemperatur im Elektronikschrank oder am Trafo! - Temperatur des ESS überprüfen! Bei >55°C ESS deaktivieren',
'SafAlm(7)  -  Übertemperatur Lastwiderstand! - Temperatur des Lastwiderstands am ESS überprüfen! Bei >55°C ESS deaktivieren',
'SafAlm(8)  -  Lastwiderstand lehnt aufgrund von Sicherheitsanforderungen Leistungsanforderung ab!',
'SafAlm(9)  -  Entweder ist der Temperatursensor im Lastwiderstandsschrank oder der Lastwiderstand defekt - Temperatur des Lastwiderstands am ESS überprüfen! Bei >55°C ESS deaktivieren ',
'SafAlm(10) -  Temperatur im Lastwiderstandsscharnk erhöht sich zu schnell - Temperatur am Lastwiderstand (STMP/Tmp) überprüfen! Bei >90°C ESS deaktivieren und Caterva in Übergabe benachrichtigen!',
'SafAlm(11) -  Test des Vorladeschützes fehlegschlagen. Gefahr, dass Schütz verklebt ist - ESS deaktivieren.',
'SafAlm(12) -  Sebststest der Batterie fehlegschlagen. Gefahr, dass BMM-Schütz verklebt ist - ESS deaktivieren.',
'SafAlm(13) -  Inselnetzschütz Rückmeldung falsch. Gefahr, dass das Schütz verklebt ist! - ESS deaktivieren.',
'SafAlm(14) -  ',
'SafAlm(15) -  ',
'SafAlm(16) -  ',
'SafAlm(17) -  ',
'SafAlm(18) -  ',
'SafAlm(19) -  ',
'SafAlm(20) -  ',
'SafAlm(21) -  ',
'SafAlm(22) -  ',
'SafAlm(23) -  ',
'SafAlm(24) -  ',
'SafAlm(25) -  ',
'SafAlm(26) -  ',
'SafAlm(27) -  ',
'SafAlm(28) -  ',
'SafAlm(29) -  ',
'SafAlm(30) -  ',
'SafAlm(31) -  ',
);

if ($#failureflags != $#failuretext) {die "Die Anzahl Fehler passt nicht zu definierten Fehlertexten. FailureFlags: $#failureflags Texte: $#failuretext \n\n"};
#for(0..31) {fhem("deletereading dummy_Fehlerspeicher $name$_")}

my $count = 0;
foreach(@failureflags){
					if ($failureflags[$count] > 0){
							fhem("setreading dummy_Fehlerspeicher $name$count $failuretext[$count]");
							} 
					else {fhem("deletereading dummy_Fehlerspeicher $name$count")}
					$count ++;
					}
}
#		Log(3,"setreading dummy_Fehlerspeicher F$count $failuretext[$count]");
#########################################################################

# Unterprogramm zur Aktualisierung aller Fehlerspeichereinträge
#
sub update_Fehlerspeicher()
{
CMD_LLN0();
CMD_LLN0_Init_stVal();
CMD_LLN0_Mod();
return_WarAlm_Failures(ReadingsVal("SwDER_LLN0","WarAlm","0"));
return_BusAlm_Failures(ReadingsVal("SwDER_LLN0","BusAlm","0"));
return_CcAlm_Failures(ReadingsVal("SwDER_LLN0","CcAlm","0"));
return_InoAlm_Failures(ReadingsVal("SwDER_LLN0","InoAlm","0"));
return_MacAlm_Failures(ReadingsVal("SwDER_LLN0","MacAlm","0"));
return_SafAlm_Failures(ReadingsVal("SwDER_LLN0","SafAlm","0"));
}





#########################################################################

sub 
createReadings_ESS_Minutenwerte($)
{
my $SELF = shift;
my @readingnames =qw(Timestamp SoC_in_Pct Grid_to_Household_in_W Battery_to_Household_in_W PV_to_Household_in_W PV_to_Battery_in_W PV_to_Grid_in_W PV_power_provision_in_W Household_demand_in_W PVpeak_in_W Load_resistor_in_W Neg_Inverter_AC_power_in_W Pos_Inverter_AC_power_in_W Neg_Inverter_DC_power_in_W Pos_Inverter_DC_power_in_W PFCR_as_measured_in_W PFCRpos_scheduled_in_W PFCRneg_scheduled_in_W Traded_power_in_W PGRD_as_measured_in_W PFRR_as_measured_in_W PFRRpos_reserved_in_W PFRRneg_reserved_in_W PFCRpos_overfulfillment_setpoint_in_W PFCRneg_overfulfillment_setpoint_in_W Control_Power_to_Battery_in_W Battery_to_Control_Power_in_W Deadband_recharge_in_W Recharge_by_power_purchase_in_W Discharge_by_power_sale_in_W ESS_counter_level_discharge_in_Wh HH_counter_level_discharge_in_Wh HH_counter_level_charge_in_Wh PV_counter_level_discharge_in_Wh ESS_counter_level_charge_in_Wh PV_counter_level_charge_in_Wh PVplusHH_counter_level_discharge_in_Wh PVplusHH_counter_level_charge_in_Wh PBH_counter_level_in_Wh PPB_counter_level_in_Wh PRE_counter_level_in_Wh PDI_counter_level_in_Wh PFCRpos_counter_level_in_Wh PFCRneg_counter_level_in_Wh HHpa_in_Wh PFRRpos_counter_level_in_Wh PFRRneg_counter_level_in_Wh);
my $timestamp = substr(TimeNow(),0,7);
my $filename = "/opt/fhem/log/$SELF-$timestamp.log";
my $last_line = `tail -1 $filename`;
my @readings = split / \d+: /, $last_line;
my $x=0;

foreach (@readings)
 {
 	my $y = sprintf("%02d",$x);
 	my $readingname = $y."_Reading_$y";
 	$readingname = $y."_".$readingnames[$x] if defined $readingnames[$x];
 	fhem("setreading $SELF $readingname $_");
 $x++;
 }
}




sub
Zaehler_1()
{
my @response = `(echo "SwDER/MMTR1";echo "exit";) | netcat 192.168.0.222 1337`;

fhem("setreading Zaehler 1_content @response");

@response= grep {/SwDER\/MMTR1\./} @response;
foreach ( @response ) {
  my @line = split(" ",$_);
  my @reading = split(/\./,$line[1]);
   fhem("setreading Zaehler $reading[1] $line[-2]");
  }
}


sub
CMD_LLN0()
{
my @response = `(echo "SwDER/LLN0";echo "exit";) | netcat 192.168.0.222 1337`;
fhem("setreading SwDER_LLN0 1_content @response");
@response= grep {/SwDER\/LLN0\./} @response;
foreach ( @response ) {
  my @line = split(" ",$_);
  my @reading = split(/\./,$line[1]);
   fhem("setreading SwDER_LLN0 $reading[1] $line[-2]");
  }
}
# Log(3," $reading[1]  $line[-2]");

sub
CMD_LLN0_Init_stVal()
{
my @response = `(echo "SwDER/LLN0.Init.stVal";echo "exit";) | netcat 192.168.0.222 1337`;
@response= grep {/SwDER\/LLN0\./} @response;
foreach ( @response ) {
	my @line = split(" ",$_);
	my @reading = split(/\./,$line[1]);
	fhem("setreading SwDER_LLN0 $reading[1] $line[-1]");
  }
}

sub
CMD_LLN0_Mod()
{
my @response = `(echo "SwDER/LLN0.Mod";echo "exit";) | netcat 192.168.0.222 1337`;
@response= grep {/SwDER\/LLN0\./} @response;
foreach ( @response ) {
	my @line = split(" ",$_);
	my @reading = split(/\./,$line[1]);
	fhem("setreading SwDER_LLN0 $reading[1] $line[-8]");
  }
}


sub
CMD_CPOL1()
{
my @response = `(echo "SwDER/CPOL1";echo "exit";) | netcat 192.168.0.222 1337`;
fhem("setreading SwDER_CPOL1 1_content @response");
@response= grep {/SwDER\/CPOL1\./} @response;
foreach ( @response ) {
  my @line = split(" ",$_);
  my @reading = split(/\./,$line[1]);
  Log(3," $reading[1] $line[-1]");
  fhem("setreading SwDER_CPOL1 $reading[1] $line[-1]");
  }
}

sub
CMD_MMXU4()
{
my @response = `(echo "SwDER/MMXU4";echo "exit";) | netcat 192.168.0.222 1337`;
fhem("setreading SwDER_MMXU4 1_content @response");
}



sub
CMD_ZBTC1()
{
my @response = `(echo "SwDER/ZBTC1";echo "exit";) | netcat 192.168.0.222 1337`;
fhem("setreading SwDER_ZBTC1 1_content @response");
}


sub 
CMD_MOD()
{
my @response = `(echo "mod";echo "exit";) | netcat 192.168.0.222 1338`;
fhem("setreading MOD 1_content @response");
}


##############################################################
#
# nicht hinterlegte Befehle können wie folgt direkt in die Eingabezeile eingegeben werden:
# {CMD("SwDER","CPOL1")}
#

sub 
CMD($$)
{
my($CMD1,$CMD2) = @_;
Log(3,"$CMD1"."/"."$CMD2");
my$CMD3 = ("$CMD1"."/"."$CMD2");
Log(3,"$CMD3");
my $response = `(echo "$CMD3";echo "exit";) | netcat 192.168.0.222 1337`;
#my $response = `(echo ""$CMD1"."/"."CMD2";echo "exit"";) | netcat 192.168.0.222 1337`;
#Log(3,"$CMD3");
#return($response);
}


my $SELF = shift;

#############################################################
#
# SwDER/ZINV1.DcV.mag.f zeigt Gesamtspannung der Akkus geht aber nicht bei SAFT-Akkus
sub 
CMD_ZINV1()
{
my @response = `(echo "SwDER/ZINV1";echo "exit";) | netcat 192.168.0.222 1337`;
fhem("setreading SwDER_ZINV1 1_content @response");
@response= grep {/SwDER\/ZINV1\./} @response;
foreach ( @response ) {
  my @line = split(" ",$_);
  my @reading = split(/\./,$line[1]);
  fhem("setreading SwDER_ZINV1 $reading[1] $line[-1]");
  }
}
#  Log(3," $reading[1] $line[-1]");

#############################################################
#
# interessant für SAFT Akkus

sub 
CMD_MBMS1()
{
my @response = `(echo "SwDER/MBMS1";echo "exit";) | netcat 192.168.0.222 1337`;
fhem("setreading SwDER_MBMS1 1_content @response");
@response= grep {/SwDER\/MBMS1\./} @response;
foreach ( @response ) {
  my @line = split(" ",$_);
  my @reading = split(/\./,$line[1]);
  fhem("setreading SwDER_MBMS1 $reading[1] $line[-1]");
  }
}
#  Log(3," $reading[1] $line[-1]");

#############################################################
# Geht nicht
#############################################################

#sub 
#CMD_SOC()
#{
#my $response = `(echo "swarmBcCheckSoC <<< j";echo "exit";) | netcat 192.168.0.222 1337`;
#Log(3,"test: $response");
#return($response);
#}

#sub 
#CMD_BC_Status()
#{
#my $response = `(echo "swarmBcStatus <<< j";echo "exit";) | netcat 192.168.0.222 1337`;
#Log(3,"test: $response");
#return($response);
#}

#############################################################


sub 
LogZaehlerDay()
{

my $timestamp1 = substr(TimeNow(),0,7);  #"2020-04"-11 01:00:15  für Filename

my $timestamp2 = substr(TimeNow(),0,10); #"2020-04-11" 01:00:15  für Logfile Teil1
my $timestamp3 = substr(TimeNow(),11,8); #2020-04-11 "01:00:15"  für Logfile Teil2
my $timestamp4 = $timestamp2."_".$timestamp3; #für Logfile Teil1_Teil2

my $filename = "/opt/fhem/log/Zaehler_Tageswerte-$timestamp1.log";

my $stat30_ESS_counter_level_discharge_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","statESS_counter_level_discharge_in_WhDay","999")/1000,1);
my $stat31_HH_counter_level_discharge_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat31_HH_counter_level_discharge_in_WhDay","999")/1000,1);
my $stat32_HH_counter_level_charge_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat32_HH_counter_level_charge_in_WhDay","999")/1000,1);
my $stat33_PV_counter_level_discharge_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat33_PV_counter_level_discharge_in_WhDay","999")/1000,1);
my $stat34_ESS_counter_level_charge_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","statESS_counter_level_charge_in_WhDay","999")/1000,1);
my $stat35_PV_counter_level_charge_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat35_PV_counter_level_charge_in_WhDay","999")/1000,1);
my $stat36_PVplusHH_counter_level_discharge_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat36_PVplusHH_counter_level_discharge_in_WhDay","999")/1000,1);
my $stat37_PVplusHH_counter_level_charge_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat37_PVplusHH_counter_level_charge_in_WhDay","999")/1000,1);
my $stat38_PBH_counter_level_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat38_PBH_counter_level_in_WhDay","999")/1000,1);
my $stat39_PPB_counter_level_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat39_PPB_counter_level_in_WhDay","999")/1000,1);
my $stat40_PRE_counter_level_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat40_PRE_counter_level_in_WhDay","999")/1000,1);
my $stat41_PDI_counter_level_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat41_PDI_counter_level_in_WhDay","999")/1000,1);
my $stat42_PFCRpos_counter_level_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat42_PFCRpos_counter_level_in_WhDay","999")/1000,1);
my $stat43_PFCRneg_counter_level_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat43_PFCRneg_counter_level_in_WhDay","999")/1000,1);
my $stat45_PFRRpos_counter_level_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat45_PFRRpos_counter_level_in_WhDay","999")/1000,1);
my $stat46_PFRRneg_counter_level_in_WhDay = round(ReadingsVal("ESS_Minutenwerte","stat46_PFRRneg_counter_level_in_WhDay","999")/1000,1);
my $statPVtoHHDay = round(ReadingsVal("ESS_Minutenwerte","statPVtoHHDay","999")/1000,1);
my $statPV2GridDay = round(ReadingsVal("ESS_Minutenwerte","statPV2GridDay","999")/1000,1);
my $statPV2HHDay = round(ReadingsVal("ESS_Minutenwerte","statPV2HHDay","999")/1000,1);
my $statGrid2HHDay = round(ReadingsVal("ESS_Minutenwerte","statGrid2HHDay","999")/1000,1);
my $statGrid2HH_2Day = round(ReadingsVal("ESS_Minutenwerte","statGrid2HH_2Day","999")/1000,1);
addToLog($filename, "$timestamp4 03: $stat30_ESS_counter_level_discharge_in_WhDay 05: $stat31_HH_counter_level_discharge_in_WhDay 07: $stat32_HH_counter_level_charge_in_WhDay 09: $stat33_PV_counter_level_discharge_in_WhDay 11: $stat34_ESS_counter_level_charge_in_WhDay 13: $stat35_PV_counter_level_charge_in_WhDay 15: $stat36_PVplusHH_counter_level_discharge_in_WhDay 17: $stat37_PVplusHH_counter_level_charge_in_WhDay 19: $stat38_PBH_counter_level_in_WhDay 21: $stat39_PPB_counter_level_in_WhDay 23: $stat40_PRE_counter_level_in_WhDay 25: $stat41_PDI_counter_level_in_WhDay 27: $stat42_PFCRpos_counter_level_in_WhDay 29: $stat43_PFCRneg_counter_level_in_WhDay 31: $stat45_PFRRpos_counter_level_in_WhDay 33: $stat46_PFRRneg_counter_level_in_WhDay 35: $statPV2GridDay 37: $statPV2HHDay 39: $statGrid2HHDay 41: $statGrid2HH_2Day");
}

sub 
LogZaehlerMonth()
{


my $timestamp1 = substr(TimeNow(),0,7);  #"2020-04"-11 01:00:15  für Filename

my $timestamp2 = substr(TimeNow(),0,10); #"2020-04-11" 01:00:15  für Logfile Teil1
my $timestamp3 = substr(TimeNow(),11,8); #2020-04-11 "01:00:15"  für Logfile Teil2
my $timestamp4 = $timestamp2."_".$timestamp3; #für Logfile Teil1_Teil2

my $filename = "/opt/fhem/log/Zaehler_Monatswerte-$timestamp1.log";

my $stat30_ESS_counter_level_discharge_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","statESS_counter_level_discharge_in_WhMonth","999")/1000,1);
my $stat31_HH_counter_level_discharge_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat31_HH_counter_level_discharge_in_WhMonth","999")/1000,1);
my $stat32_HH_counter_level_charge_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat32_HH_counter_level_charge_in_WhMonth","999")/1000,1);
my $stat33_PV_counter_level_discharge_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat33_PV_counter_level_discharge_in_WhMonth","999")/1000,1);
my $stat34_ESS_counter_level_charge_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","statESS_counter_level_charge_in_WhMonth","999")/1000,1);
my $stat35_PV_counter_level_charge_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat35_PV_counter_level_charge_in_WhMonth","999")/1000,1);
my $stat36_PVplusHH_counter_level_discharge_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat36_PVplusHH_counter_level_discharge_in_WhMonth","999")/1000,1);
my $stat37_PVplusHH_counter_level_charge_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat37_PVplusHH_counter_level_charge_in_WhMonth","999")/1000,1);
my $stat38_PBH_counter_level_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat38_PBH_counter_level_in_WhMonth","999")/1000,1);
my $stat39_PPB_counter_level_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat39_PPB_counter_level_in_WhMonth","999")/1000,1);
my $stat40_PRE_counter_level_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat40_PRE_counter_level_in_WhMonth","999")/1000,1);
my $stat41_PDI_counter_level_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat41_PDI_counter_level_in_WhMonth","999")/1000,1);
my $stat42_PFCRpos_counter_level_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat42_PFCRpos_counter_level_in_WhMonth","999")/1000,1);
my $stat43_PFCRneg_counter_level_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat43_PFCRneg_counter_level_in_WhMonth","999")/1000,1);
my $stat45_PFRRpos_counter_level_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat45_PFRRpos_counter_level_in_WhMonth","999")/1000,1);
my $stat46_PFRRneg_counter_level_in_WhMonth = round(ReadingsVal("ESS_Minutenwerte","stat46_PFRRneg_counter_level_in_WhMonth","999")/1000,1);
my $statPVtoHHMonth = round(ReadingsVal("ESS_Minutenwerte","statPVtoHHMonth","999")/1000,1);
my $statPV2GridMonth = round(ReadingsVal("ESS_Minutenwerte","statPV2GridMonth","999")/1000,1);
my $statPV2HHMonth = round(ReadingsVal("ESS_Minutenwerte","statPV2HHMonth","999")/1000,1);
my $statGrid2HHMonth = round(ReadingsVal("ESS_Minutenwerte","statGrid2HHMonth","999")/1000,1);
addToLog($filename, "$timestamp4 03: $stat30_ESS_counter_level_discharge_in_WhMonth 05: $stat31_HH_counter_level_discharge_in_WhMonth 07: $stat32_HH_counter_level_charge_in_WhMonth 09: $stat33_PV_counter_level_discharge_in_WhMonth 11: $stat34_ESS_counter_level_charge_in_WhMonth 13: $stat35_PV_counter_level_charge_in_WhMonth 15: $stat36_PVplusHH_counter_level_discharge_in_WhMonth 17: $stat37_PVplusHH_counter_level_charge_in_WhMonth 19: $stat38_PBH_counter_level_in_WhMonth 21: $stat39_PPB_counter_level_in_WhMonth 23: $stat40_PRE_counter_level_in_WhMonth 25: $stat41_PDI_counter_level_in_WhMonth 27: $stat42_PFCRpos_counter_level_in_WhMonth 29: $stat43_PFCRneg_counter_level_in_WhMonth 31: $stat45_PFRRpos_counter_level_in_WhMonth 33: $stat46_PFRRneg_counter_level_in_WhMonth  35: $statPV2GridMonth 37: $statPV2HHMonth 39: $statGrid2HHMonth");
}

sub 
LogZaehlerLastDay()
{


my $timestamp1 = substr(TimeNow(),0,7);  #"2020-04"-11 01:00:15  für Filename

my $timestamp2 = substr(TimeNow(),0,10); #"2020-04-11" 01:00:15  für Logfile Teil1
my $timestamp3 = substr(TimeNow(),11,8); #2020-04-11 "01:00:15"  für Logfile Teil2
my $timestamp4 = $timestamp2."_".$timestamp3; #für Logfile Teil1_Teil2

my $filename = "/opt/fhem/log/Zaehler_LastDaywerte-$timestamp1.log";

my $stat30_ESS_counter_level_discharge_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","statESS_counter_level_discharge_in_WhDayLast","999")/1000,1);
my $stat31_HH_counter_level_discharge_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat31_HH_counter_level_discharge_in_WhDayLast","999")/1000,1);
my $stat32_HH_counter_level_charge_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat32_HH_counter_level_charge_in_WhDayLast","999")/1000,1);
my $stat33_PV_counter_level_discharge_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat33_PV_counter_level_discharge_in_WhDayLast","999")/1000,1);
my $stat34_ESS_counter_level_charge_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","statESS_counter_level_charge_in_WhDayLast","999")/1000,1);
my $stat35_PV_counter_level_charge_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat35_PV_counter_level_charge_in_WhDayLast","999")/1000,1);
my $stat36_PVplusHH_counter_level_discharge_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat36_PVplusHH_counter_level_discharge_in_WhDayLast","999")/1000,1);
my $stat37_PVplusHH_counter_level_charge_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat37_PVplusHH_counter_level_charge_in_WhDayLast","999")/1000,1);
my $stat38_PBH_counter_level_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat38_PBH_counter_level_in_WhDayLast","999")/1000,1);
my $stat39_PPB_counter_level_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat39_PPB_counter_level_in_WhDayLast","999")/1000,1);
my $stat40_PRE_counter_level_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat40_PRE_counter_level_in_WhDayLast","999")/1000,1);
my $stat41_PDI_counter_level_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat41_PDI_counter_level_in_WhDayLast","999")/1000,1);
my $stat42_PFCRpos_counter_level_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat42_PFCRpos_counter_level_in_WhDayLast","999")/1000,1);
my $stat43_PFCRneg_counter_level_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat43_PFCRneg_counter_level_in_WhDayLast","999")/1000,1);
my $stat45_PFRRpos_counter_level_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat45_PFRRpos_counter_level_in_WhDayLast","999")/1000,1);
my $stat46_PFRRneg_counter_level_in_WhDayLast = round(ReadingsVal("ESS_Minutenwerte","stat46_PFRRneg_counter_level_in_WhDayLast","999")/1000,1);
my $statPVtoHHDayLast = round(ReadingsVal("ESS_Minutenwerte","statPVtoHHDayLast","999")/1000,1);
my $statPV2GridDayLast = round(ReadingsVal("ESS_Minutenwerte","statPV2GridDayLast","999")/1000,1);
my $statPV2HHDayLast = round(ReadingsVal("ESS_Minutenwerte","statPV2HHDayLast","999")/1000,1);
my $statGrid2HHDayLast = round(ReadingsVal("ESS_Minutenwerte","statGrid2HHDayLast","999")/1000,1);
addToLog($filename, "$timestamp4 03: $stat30_ESS_counter_level_discharge_in_WhDayLast 05: $stat31_HH_counter_level_discharge_in_WhDayLast 07: $stat32_HH_counter_level_charge_in_WhDayLast 09: $stat33_PV_counter_level_discharge_in_WhDayLast 11: $stat34_ESS_counter_level_charge_in_WhDayLast 13: $stat35_PV_counter_level_charge_in_WhDayLast 15: $stat36_PVplusHH_counter_level_discharge_in_WhDayLast 17: $stat37_PVplusHH_counter_level_charge_in_WhDayLast 19: $stat38_PBH_counter_level_in_WhDayLast 21: $stat39_PPB_counter_level_in_WhDayLast 23: $stat40_PRE_counter_level_in_WhDayLast 25: $stat41_PDI_counter_level_in_WhDayLast 27: $stat42_PFCRpos_counter_level_in_WhDayLast 29: $stat43_PFCRneg_counter_level_in_WhDayLast 31: $stat45_PFRRpos_counter_level_in_WhDayLast 33: $stat46_PFRRneg_counter_level_in_WhDayLast  35: $statPV2GridDayLast 37: $statPV2HHDayLast 39: $statGrid2HHDayLast");
}



sub
Configuration_Check()
{

fhem("set Configuration_Check ok");


if(ReadingsVal("P_in_W_dischargeStandbyThreshold_delay","check1","999") eq "nok"){fhem("set Configuration_Check nok")};
if(ReadingsVal("P_in_W_dischargeStandbyThreshold_delay","check2","999") eq "nok"){fhem("set Configuration_Check nok")};


if(ReadingsVal("P_in_W_dischargeStandbyThreshold_hyst","check1","999") eq "nok"){fhem("set Configuration_Check nok")};

if(ReadingsVal("P_in_W_chargeStandbyThreshold","check1","999") eq "nok"){fhem("set Configuration_Check nok")};

if(ReadingsVal("P_in_W_chargeStandbyThreshold_hyst","check1","999") eq "nok"){fhem("set Configuration_Check nok")};
if(ReadingsVal("P_in_W_chargeStandbyThreshold_hyst","check2","999") eq "nok"){fhem("set Configuration_Check nok")};
 	

if(ReadingsVal("SoC_max","check1","999") eq "nok"){fhem("set Configuration_Check nok")};
if(ReadingsVal("SoC_max","check2","999") eq "nok"){fhem("set Configuration_Check nok")};

if(ReadingsVal("SoC_charge","check1","999") eq "nok"){fhem("set Configuration_Check nok")};
if(ReadingsVal("SoC_charge","check2","999") eq "nok"){fhem("set Configuration_Check nok")};

if(ReadingsVal("SoC_discharge","check1","999") eq "nok"){fhem("set Configuration_Check nok")};
if(ReadingsVal("SoC_discharge","check2","999") eq "nok"){fhem("set Configuration_Check nok")};
if(ReadingsVal("SoC_discharge","check3","999") eq "nok"){fhem("set Configuration_Check nok")};

if(ReadingsVal("SoC_min","check1","999") eq "nok"){fhem("set Configuration_Check nok")};
if(ReadingsVal("SoC_min","check2","999") eq "nok"){fhem("set Configuration_Check nok")};

if(ReadingsVal("SoC_err","check1","999") eq "nok"){fhem("set Configuration_Check nok")};

if(ReadingsVal("ECS3_configuration","check1","999") eq "nok"){fhem("set Configuration_Check nok")};

}


sub 
create_BusinessOptimum_config()
{
my $string = "#P_in_W_chargeStandbyThreshold:				Charging only, when \"P_in_W_chargeStandbyThreshold\" \'exceeded\'
#P_in_W_chargeStandbyThreshold_hyst:       	Charging routine will stop, when \"P_in_W_chargeStandbyThreshold_hyst\" has been reached
#P_in_W_dischargeStandbyThreshold:			Discharging immediately, when \"P_in_W_dischargeStandbyThreshold\" exceeded
#P_in_W_dischargeStandbyThreshold_delay:	Discharging only, when \"P_in_W_dischargeStandbyThreshold_delay\" has been exceeded > \"counter_standby_to_discharge_max\"
#P_in_W_dischargeStandbyThreshold_hyst:		Discharging routine will stop, when \"P_in_W_dischargeStandbyThreshold_hyst\" has been reached
#
#SoC_max:									Soc ... max. up to charging will be possible; shall not exceed 90; as this is the limit of other caterva parameters
#SoC_charge:								SoC ... enable re-charging (ChargedFlag is reset to \"0\")
#SoC_discharge:								SoC ... set minimum value of SoC; beyond that only <<charging>> is possible; limit by Caterva: Soc.stVal=20% -> results in \"SocDC.stVal about 23%\"
#SoC_min:									SoC ... force charging (ChargedFlag is set to \"-1\") until \"SoC_discharge\" is reached, e.g. 5% less than SoC_discharge.
#SoC_err:									SoC ... verify wrong entries in log, - below that value (should be set in range of 1 ... 5)
#
#counter_discharge_to_standby_max:			max. time (in sec.) until dis/charging is possible prior to swtiching to standby
#counter_standby_to_discharge_max:			max. time (in sec.) observing in standby until discharging is enabled
#counter_increment:							time of one loop (while) in sec
#loop_delay:								time (in sec.) of a requested delay (sleep routine)
#
#
#system_initialization:						required system init:  \"1112\" or \"112\"
#
#ECS3_configuration:						ECS3 Configuration: \"PVHH\" ... PVHH meter; \"GRID\" ... Grid meter
#
#BusinessOptimum_BOS:						Connection with BOS:  0: BusinessOptimum standalone // 1: BusinessOptimumStarter (BOS) required
#
#P_in_W_chargeStandbyThreshold ... P_in_W_chargeStandbyThreshold_hyst ... 0
#P_in_W_dischargeStandbyThreshold ... P_in_W_dischargeStandbyThreshold_delay ... P_in_W_dischargeStandbyThreshold_hyst ... 0
#SoC_max ... SoC_charge ... SoC_discharge ... SoC_min ... SoC_err
#
#P_in_W_chargeStandbyThreshold;#P_in_W_chargeStandbyThreshold_hyst;#P_in_W_dischargeStandbyThreshold;#P_in_W_dischargeStandbyThreshold_delay;#P_in_W_dischargeStandbyThreshold_hyst;#SoC_max;#SoC_charge;#SoC_discharge;#SoC_min;#SoC_err;#counter_discharge_to_standby_max;#counter_charge_to_standby_max;#counter_standby_to_discharge_max;#counter_increment;#system_initialization;#ECS3_Configuration
#October-March: -1500;-1000;2500;1500;1000;90;80;23;18;0;120;60;4;0;1112;PVHH;0;
#April-September: -4000;-1500;1500;750;500;90;80;23;18;0;120;60;4;0;1112;PVHH;0;
#Config created by FHEM";

#update_Fehlerspeicher();

my $timestamp2 = substr(TimeNow(),0,10); #"2020-04-11" 01:00:15  für Logfile Teil1
my $timestamp3 = substr(TimeNow(),11,8); #2020-04-11 "01:00:15"  für Logfile Teil2
my $timestamp4 = $timestamp2."_".$timestamp3; #für Logfile Teil1_Teil2

my $filename = "/opt/fhem/log/BusinessOptimum.config";

my $P_in_W_chargeStandbyThreshold = ReadingsNum("P_in_W_chargeStandbyThreshold","state",0);
my $P_in_W_chargeStandbyThreshold_hyst = ReadingsNum("P_in_W_chargeStandbyThreshold_hyst","state",0);
my $P_in_W_dischargeStandbyThreshold = ReadingsNum("P_in_W_dischargeStandbyThreshold","state",0);
my $P_in_W_dischargeStandbyThreshold_delay = ReadingsNum("P_in_W_dischargeStandbyThreshold_delay","state",0);
my $P_in_W_dischargeStandbyThreshold_hyst = ReadingsNum("P_in_W_dischargeStandbyThreshold_hyst","state",0);
my $SoC_max = ReadingsNum("SoC_max","state",0);
my $SoC_charge = ReadingsNum("SoC_charge","state",0);
my $SoC_discharge =ReadingsNum("SoC_discharge","state",0);
my $SoC_min = ReadingsNum("SoC_min","state",0);
my $SoC_err = ReadingsNum("SoC_err","state",0);
my $counter_discharge_to_standby_max = ReadingsNum("counter_discharge_to_standby_max","state",0);
my $counter_standby_to_discharge_max = ReadingsNum("counter_standby_to_discharge_max","state",0);
my $counter_increment = ReadingsVal("counter_increment","counter_increment","999");
my $loop_delay = ReadingsVal("counter_increment","loop_delay","999");
my $system_initialization = ReadingsVal("system_initialization","Initstatus","999");
#my $system_initialization = ReadingsVal("SwDER_LLN0", "Init", "999");
my $ECS3_configuration = ReadingsVal("ECS3_configuration","state","999");
my $BusinessOptimum_BOS = ReadingsVal("BusinessOptimum_BOS","Initstatus","999");
my @dataArray = ($P_in_W_chargeStandbyThreshold,$P_in_W_chargeStandbyThreshold_hyst,$P_in_W_dischargeStandbyThreshold,$P_in_W_dischargeStandbyThreshold_delay,$P_in_W_dischargeStandbyThreshold_hyst,$SoC_max,$SoC_charge,$SoC_discharge,$SoC_min,$SoC_err,$counter_discharge_to_standby_max,$counter_standby_to_discharge_max,$counter_increment,$loop_delay,$system_initialization,$ECS3_configuration,$BusinessOptimum_BOS);


overwriteLog($filename, "$string $timestamp4
$P_in_W_chargeStandbyThreshold;$P_in_W_chargeStandbyThreshold_hyst;$P_in_W_dischargeStandbyThreshold;$P_in_W_dischargeStandbyThreshold_delay;$P_in_W_dischargeStandbyThreshold_hyst;$SoC_max;$SoC_charge;$SoC_discharge;$SoC_min;$SoC_err;$counter_discharge_to_standby_max;$counter_standby_to_discharge_max;$counter_increment;$loop_delay;$system_initialization;$ECS3_configuration;$BusinessOptimum_BOS;");


fhem("setreading write_settings Data @dataArray"); 	


#Log(1,"BussinessOptimum @dataArray");
}





# Config senden an Caterva
sub 
copy2caterva_BusinessOptimum_config()
{
system("scp /opt/fhem/log/BusinessOptimum.config admin\@caterva:bin");
}



sub 
delete_noPVBuffering_Flag()
{`ssh admin\@caterva "rm -f /home/admin/registry/noPVBuffering"`;
}

sub 
create_noPVBuffering_Flag()
{
system("ssh admin\@caterva touch /home/admin/registry/noPVBuffering");
}

#Stop BusinessOptimum
#touch /tmp/BusinessOptimumStop
sub 
create_BusinessOptimumStop_Flag()
{
system("ssh admin\@caterva touch /tmp/BusinessOptimumStop");
Log 1, "BusinessOptimum_Stop_Flag gesetzt";
}

#Stop BusinessOptimumStarter
#touch /tmp/BusinessOptimumStarterStop
#touch /tmp/BusinessOptimumStop
sub 
create_BusinessOptimumStarterStop_Flag()
{
system("ssh admin\@caterva touch /tmp/BusinessOptimumStarterStop");
system("ssh admin\@caterva touch /tmp/BusinessOptimumStop");
Log 1, "BusinessOptimumStarterStop_Flag gesetzt";


}


#Start of Module-Balancing:
#touch /var/log/ModuleBalancing
sub 
start_ModuleBalancing_Flag()
{
system("ssh admin\@caterva touch /var/log/ModuleBalancing");
Log 1, "ModuleBalancing_Flag gesetzt";
}


#Start of Cell-Balancing:
#touch /tmp/CellBalancing
sub 
start_CellBalancing_Flag()
{
system("ssh admin\@caterva touch /tmp/CellBalancing");
Log 1, "CellBalancing_Flag gesetzt";
}



sub
reset_Befehl_Anzeige()
{
		fhem("define at_Sec_Counter at +00:00:03 set BusinessOptimum_Befehle .");
		fhem("attr at_Sec_Counter room 6_System");
}



sub
check_noPVBuffering_Flag()
{
my $response = `(echo -f /home/admin/registry/noPVBuffering;)`;
if ($response) {Log 1,"File noPVBuffering existiert"} else {Log 1,"File noPVBuffering existiert nicht"}; 
}



#/home/pi/Git-Clones/.FHEM_Setup_Copy_per_Shell.did_run
sub
check_FHEM_Rechte_Flag()
{
system("ssh admin\@caterva touch /var/log/ModuleBalancing");
Log 1, "ModuleBalancing_Flag gesetzt";
}



#rsh admin@caterva "/home/admin/bin/BusinessOptimumKill.sh" 
#sub 
#BusinessOptimumKill()
#{
#system("rsh admin\@caterva /home/admin/bin/BusinessOptimumKill.sh");
#}

#sub 
#BusinessOptimumStart()
#{
#system("rsh admin\@caterva nohup /home/admin/bin/BusinessOptimum.sh &");
#}

#sub 
#BusinessOptimumStarter_Start()
#{
#system("(rsh admin\@caterva nohup /home/admin/bin/BusinessOptimumStarter.sh start & )&");
#}

#sub 
#BusinessOptimumStarter_Stop()
#{
#system("rsh admin\@caterva /home/admin/bin/BusinessOptimumStarter.sh stop");
#}


#{`rsh admin\@caterva cat /home/admin/registry/out/pvPeak`}
# bei Anlagen welche die Prediction-Funktion abgeschalten haben wird der Wert PV Peak nicht mehr berechnet...
# Dieser Wert wird bei Tablet-UI zur Anzeigeoptimierung verwendet.
# Bei Initialisierung soll dieser Wert eingelesen werden.

sub 
read_PV_Peak()
{
my $PVPeak = trim(`rsh admin\@caterva cat /home/admin/registry/out/pvPeak`);
fhem("setreading ESS_Minutenwerte 09_PVpeak_in_W_2 $PVPeak");
#Log 1,"read_PV_Peak: $PVPeak W";
}

sub 
read_bmm_Type()
{
my $bmmType = `rsh admin\@caterva cat /home/admin/registry/out/bmmType 1>/dev/null 2>&1 ; echo $?`;
fhem("setreading ESS_Minutenwerte 09_bmmType $bmmType");
Log 1,"read_bmm_Type: $bmmType";
}



#grep -i quinger /home/admin/bin/BusinessOptimum.sh
#substr(TimeNow(),0,7);
sub 
read_BO_Version()
{
my $Version = substr(`rsh admin\@caterva grep -i quinger /home/admin/bin/BusinessOptimum.sh`,21,23);
if (length($Version) > 0){
fhem("setreading BO_BusinessOptimum_Status Version $Version");
Log 1,"Business Optimum Version $Version installiert";
}
else {
fhem("setreading BO_BusinessOptimum_Status Version n.a.");
Log 1,"Business Optimum nicht installiert";
}
}



#sub 
#read_ESS_GEN()
#{
#my $gen = `(rsh admin\@caterva "ls /home/admin/registry/out/gen1" 1>/dev/null 2>&1 ; echo \$?)`;
#my $gen = system("rsh admin\@caterva ls /home/admin/registry/out/gen1 1>/dev/null 2>&1 ; echo $?");
#Log 1,"read_ESS_GEN: GEN1 --> $gen";
#return $gen;
#}

#{check_File_exists('/home/admin/registry/out/gen1')}
#{check_File_exists('/home/admin/bin/BusinessOptimum.sh')}
sub 
check_File_exists($)
{
my $filename = shift;
my $response = `(rsh admin\@caterva "ls $filename" 1>/dev/null 2>&1 ; echo \$?)`;
Log 1,"response: $response";
if ($response == "0"){
    Log 1,"$filename exists";
    return 1;
} else {
    Log 1,"$filename does not exist";
    return 9;
    }
}

#gleiches lokal
sub 
check_File_exists_PI($)
{
my $filename = shift;
my $response = `("ls $filename" 1>/dev/null 2>&1 ; echo \$?)`;
Log 1,"response: $response";
if ($response == "0"){
    Log 1,"$filename exists";
    return 1;
} else {
    Log 1,"$filename does not exist";
    return 9;
    }
}


sub
addToLog($$)
{
	my ($filename, $data) = @_;
	open(MYFILE,">>$filename");
	print MYFILE "\n$data";
	close(MYFILE);
}

sub
overwriteLog($$)
{
	my ($filename, $data) = @_;
	my $timestamp1 = substr(TimeNow(),0,7);
	open(MYFILE,">$filename");
	print MYFILE "$data";
	close(MYFILE);
}

sub prg_Tage_MTD(){
 	my ($sec,$min,$hour,$mday,$month,$year,$wday,$yday,$isdst) = localtime;
	return($mday);
	}
	

sub prg_Tage_YTD(){
 	my ($sec,$min,$hour,$mday,$month,$year,$wday,$yday,$isdst) = localtime;
	return($yday);
	}


sub myProxyForVentil($){
my $DEVICE= shift;
 if ($DEVICE =~ m/Ventil_1/) {return "Bewaesserung_Vorgarten_1"}
 if ($DEVICE =~ m/Ventil_2/) {return "Bewaesserung_Vorgarten_aussen"}
 if ($DEVICE =~ m/Ventil_3/) {return "Bewaesserung_Vorgarten_Tropfschlauch"}
}

#########################################################################
# do not change below _this_ line.

1;
