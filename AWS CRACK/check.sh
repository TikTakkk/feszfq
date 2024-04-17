#!/bin/bash

name="$1"
mkdir -p envfolder
###======================= AKIA ================================
grep -rnP -C25 'AKIA[A-Z0-9]{16}' --binary-files=text $name/ | cut -c -500 >> akia.txt
###======================= Sendgrid ================================
grep -rnP -C25 'SG\.[0-9A-Za-z\-_]{22}\.[0-9A-Za-z\-_]{43}' --binary-files=text $name/ | cut -c -500 >> sendgrid.txt
###======================= Mailist ================================
grep --exclude='*.html' -rnP -C25 "@hotmail|@live|@outlook|@gmx|@yahoo|@bluewin|@ggaweb|@sawires" --binary-files=text $name | cut -c -500 >> mailist.txt
###======================= Sendinblue ================================
grep -rnP -C25 "smtp\-relay\.sendinblue\.com" --binary-files=text $name/ | cut -c -500 >> sendinblue.txt
###======================= Twillio ================================
grep -rnP -C25 "AC[a-z0-9]{32}" --binary-files=text $name | cut -c -500 >> Twilio.txt
###======================= Nexmo ================================
grep -rnP -C25 "(nexmo|vonage)_(?:secret|api|key)|rest\.(?:nexmo|vonage)\.com" --binary-files=text $name | cut -c -500 >> nexmo.txt
###======================= office365 ================================
grep -rnP -C25 "smtp\.office365\.com" --binary-files=text $name/ | cut -c -500 >> office365.txt
###======================= gmail ================================
grep -rnP -C25 "smtp\.gmail\.com" --binary-files=text $name/ | cut -c -500 >> gmail.txt
###======================= zoho ================================
grep -rnP -C25 "smtp\.zoho\.com" --binary-files=text $name/ | cut -c -500 >> zoho.txt
###======================= Mailjet ================================
grep -rnP -C25 "in\-v3\.mailjet\.com" --binary-files=text $name/ | cut -c -500 >> mailjet.txt


for envfile in $(find $name -name ".env*" -type f); do
	cat $envfile | tee -a envfolder/${name}_env.txt
done
