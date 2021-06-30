function exitmode
{
  
        conditional_clear
        top
        echo " "
        echo -e "$purple"" EXITING FROM $red""Wi-Fi-$green""STRIKERS-$blue""V-$yellow""1$cyan"".$grey""0 $purple""AND REVERTING BACK THE CHANGES MADE TO YOUR PC..."$transparent""
        echo " "
        sleep 2
   
        cd ~ && cd / 
        rm -fr $Host_MAC-01* > $output_screen

        cd ~ && cd /root
        rm -fr handshakes > $output_screen
        rm -fr pwlog > $output_screen


        if [ $W_DEBUG != 1 ]; then
            echo -e "\n\n"$grey" $general_exitmode"$transparent""
            sleep 1

        if ps -A | grep -q aireplay-ng; then
            echo -e ""$white" ["$red"-"$white"] "$white"Kill "$grey"aireplay-ng"$transparent""
            killall aireplay-ng &>$output_screen
        fi

        if ps -A | grep -q airodump-ng; then
            echo -e ""$white" ["$red"-"$white"] "$white"Kill "$grey"airodump-ng"$transparent""
            killall airodump-ng &>$output_screen
        fi        

        if [ "$WIFI_MONITOR" != "" ]; then
            echo -e ""$grey" $exitmode_1"$transparent""
            ./lib/airmon/airmon    stop $WIFI_MONITOR &> $output_screen
            sleep 1
        fi


        if [ "$WIFI" != "" ]; then
            ./lib/airmon/airmon    stop $WIFI &> $output_screen
            macchanger -p $WIFI &> $output_screen
        fi

        tput cnorm

        if [ $W_DEBUG != 1 ]; then
            echo -e ""$grey" $exitmode_2"$transparent""
            sleep 1
          
            echo -e ""$grey" Deleting the files created"$transparent""
            rm -R $DUMP_PATH/* &>$output_screen
            sleep 1
        fi

		if [ $KEEP_NETWORK = 0 ]; then

	        echo -e ""$grey" $exitmode_3"$transparent""
	        systemd=`whereis systemctl`
	        if [ "$systemd" = "" ];then
	            service network-manager restart &> $output_screen &
		  		service networkmanager restart &> $output_screen &
	            service networking restart &> $output_screen &
	        else
	            systemctl restart NetworkManager &> $output_screen & 	
	        fi 
                sleep 1

	        echo " "
                echo -e ""$yellow" $exitmode_4"$transparent""
                sleep 1

	        echo " "
                echo -e ""$grey" $exitmode_5"$transparent""
                sleep 1

                echo " "
                echo -e ""$green" $exitmode_6"$transparent""
                sleep 4

	        clear
	    fi

	fi

        iw mon0 del > $output_screen
        service network-manager restart     

        exit
    
}
