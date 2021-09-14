##############################################
# $Id: myUtilsTemplate.pm 21509 2020-03-25 11:20:51Z rudolfkoenig $
#
# Save this file as 99_myUtils.pm, and create your own functions in the new
# file. They are then available in every Perl expression.

package main;

use strict;
use warnings;

sub
myUtils_CS_Steuerung_Initialize($$)
{
  my ($hash) = @_;
}

# Enter you functions below _this_ line.




sub 
create_CS_Steuerung_config()
{

my $filename = "/opt/fhem/log/CS_Steuerung.cfg";

my $SoC_max = ReadingsNum("SoC_max","state",90);
my $SoC_charge = ReadingsNum("SoC_charge","state",80);
my $P_in_W_chargeStandbyThreshold = ReadingsNum("P_in_W_chargeStandbyThreshold","state",3000);
my $P_in_W_dischargeStandbyThreshold = ReadingsNum("P_in_W_dischargeStandbyThreshold","state",-1500);
my $Auto_Balancing = ReadingsVal("Auto_Balancing","state","nein");

my $string = "# Erste Spalte bis zu diesem Wert soll der Speicher geladen werden			default: 90
# Zweite Spalte bis zu diesem Wert geht die entladehystere				default: 87
# Dritte Spalte ab diesem Wert in Watt beginnt die Anlage mit einspeichern		default: 3000
# Vierte Spalte ab diesem Wert in Watt beginnt die Anlage zum ausspeichern		default: -1500
# Fuenfte Spalte Automatisches balancen der Module nur bei Sony Anlagen			default: nein";



my @dataArray = ($SoC_max,$SoC_charge,$P_in_W_chargeStandbyThreshold,$P_in_W_dischargeStandbyThreshold,$Auto_Balancing);


overwriteLog($filename, "$SoC_max;$SoC_charge;$P_in_W_chargeStandbyThreshold;$P_in_W_dischargeStandbyThreshold;$Auto_Balancing");


fhem("setreading write_settings Data @dataArray"); 	



}





# Config senden an Caterva
sub 
copy2caterva_CS_Steuerung_config()
{
system("scp /opt/fhem/log/CS_Steuerung.cfg admin\@caterva:bin");
}






sub 
readfromcaterva_CS_Steuerung_config()
{ 

my $config_skalar = `ssh admin\@caterva "tail -1 /home/admin/bin/CS_Steuerung.cfg"`;
my @config_array=split(/\;/,$config_skalar);

Log 1, "Von Caterva eingelesene BO Config: $config_skalar";
Log 1, "Lokal vor  Update:                  ".ReadingsVal("write_settings","Data","999");

if ($config_array[0] ne ReadingsNum("SoC_max","state",0)) {fhem("set SoC_max $config_array[0]")};
if ($config_array[1] ne ReadingsNum("SoC_charge","state",0)) {fhem("set SoC_charge $config_array[1]")};
if ($config_array[2] ne ReadingsNum("P_in_W_chargeStandbyThreshold","state",0)) {fhem("set P_in_W_chargeStandbyThreshold $config_array[2]")};
if ($config_array[3] ne ReadingsNum("P_in_W_dischargeStandbyThreshold","state",0)) {fhem("set P_in_W_dischargeStandbyThreshold $config_array[3]")};
if ($config_array[4] ne ReadingsNum("Auto_Balancing","state",0)) {fhem("set Auto_Balancing $config_array[4]")};

Log 1, "Lokal nach Update:                  ".ReadingsVal("write_settings","Data","999");

}
















#########################################################################
# do not change below _this_ line.

1;