#!/bin/bash

clear
#----- Auto Remove Vmess
data=( $(grep '^###' /etc/xray/config.json | cut -d ' ' -f 2 | sort | uniq) )
now=$(date +"%Y-%m-%d")
if [[ ${#data[@]} -gt 0 ]]; then
  for user in "${data[@]}"; do
      exp=$(grep -w "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
      d1=$(date -d "$exp" +%s)
      d2=$(date -d "$now" +%s)
      exp2=$(( (d1 - d2) / 86400 ))
      if [[ "$exp2" -le "0" ]]; then
          # Hapus yang memiliki tanda `},{`
          sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
          # Hapus yang memiliki tanda `#},{`
          sed -i "/^### $user $exp/,/^#},{/d" /etc/xray/config.json
          rm -f /etc/xray/$user-tls.json /etc/xray/$user-none.json
      fi
  done
fi

#----- Auto Remove Vless
data=( $(grep '^#&' /etc/xray/config.json | cut -d ' ' -f 2 | sort | uniq) )
now=$(date +"%Y-%m-%d")
if [[ ${#data[@]} -gt 0 ]]; then
  for user in "${data[@]}"; do
      exp=$(grep -w "^#& $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
      d1=$(date -d "$exp" +%s)
      d2=$(date -d "$now" +%s)
      exp2=$(( (d1 - d2) / 86400 ))
      if [[ "$exp2" -le "0" ]]; then
          # Hapus yang memiliki tanda `},{`
          sed -i "/^#& $user $exp/,/^},{/d" /etc/xray/config.json
          # Hapus yang memiliki tanda `#},{`
          sed -i "/^#& $user $exp/,/^#},{/d" /etc/xray/config.json
      fi
  done
fi

#----- Auto Remove Trojan
data=( $(grep '^#!' /etc/xray/config.json | cut -d ' ' -f 2 | sort | uniq) )
now=$(date +"%Y-%m-%d")
if [[ ${#data[@]} -gt 0 ]]; then
  for user in "${data[@]}"; do
      exp=$(grep -w "^#! $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
      d1=$(date -d "$exp" +%s)
      d2=$(date -d "$now" +%s)
      exp2=$(( (d1 - d2) / 86400 ))
      if [[ "$exp2" -le "0" ]]; then
          # Hapus yang memiliki tanda `},{`
          sed -i "/^#! $user $exp/,/^},{/d" /etc/xray/config.json
          # Hapus yang memiliki tanda `#},{`
          sed -i "/^#! $user $exp/,/^#},{/d" /etc/xray/config.json
      fi
  done
fi

systemctl restart xray

##------ Auto Remove SSH
hariini=`date +%d-%m-%Y`
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
totalaccounts=`cat /tmp/expirelist.txt | wc -l`

for ((i=1; i<=$totalaccounts; i++))
do
  tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
  username=`echo $tuserval | cut -f1 -d:`
  userexp=`echo $tuserval | cut -f2 -d:`

  # Convert expiration date to seconds since epoch
  userexpireinseconds=$(( $userexp * 86400 ))
  tglexp=`date -d @$userexpireinseconds`
  
  # Get current time in seconds since epoch
  todaystime=`date +%s`

  echo "Processing user: $username"
  echo "Expiry date: $tglexp, Current time: $(date)"

  # Check if the account has expired
  if [ $userexpireinseconds -ge $todaystime ]; then
    echo "User $username is still active."
  else
    echo "User $username has expired and will be deleted."
    userdel --force $username
  fi
  echo
done

# Clean up temporary file
rm /tmp/expirelist.txt
