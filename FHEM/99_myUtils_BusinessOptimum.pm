##############################################
# $Id: myUtilsTemplate.pm 21509 2020-03-25 11:20:51Z rudolfkoenig $
#
# Save this file as 99_myUtils.pm, and create your own functions in the new
# file. They are then available in every Perl expression.

package main;

use strict;
use warnings;

sub
myUtils_BusinessOptimum_Initialize($$)
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


sub
reset_Befehl_Anzeige()
{
		fhem("define at_Sec_Counter at +00:00:03 set BusinessOptimum_Befehle .");
		fhem("attr at_Sec_Counter room 6_System");
}








#########################################################################
# do not change below _this_ line.

1;
