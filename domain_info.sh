#!/bin/bash
#
#Program which takes domain as input and autonomously gathers
#information about the domain entered by the user.
#Nolan Caissie
#March 19/21
#
#
#printf "\n"
#echo -e "\e[1;42m ..."
#Prompt the user to enter in the domain name
echo -e "\e[1;31m----------------------------------------------------------------------------------------------------------------------------------------------- \e[0m"
echo -e "\e[1;33m---------------------------------------------------- Please enter the domain information ----------------------------------------------------- \e[0m"
echo -e "\e[1;33mInput can be in the form of a full URL, email address, IP address, or domain name with or without the sub-domain eg. www.yahoo.com or yahoo.com\e[0m"
echo -e "\e[1;31m----------------------------------------------------------------------------------------------------------------------------------------------- \e[0m"
echo -n  ">> "
#
#
#function to join delimited strings (I found this function here: https://dev.to/meleu/how-to-join-array-elements-in-a-bash-script-303a)
joinbystring() {
	local separator="$1"
	shift
	local first="$1"
	shift
	printf "%s" "$first" "${@/#/$separator}"
}
#read the users input
read usr_input
#store the user input in an array using "." as a delimiter
IFS="." read -a usr_arr <<< $usr_input #will be used if user enters the domain name (with sub-domain www)
#store the user input in an array using ":" as a delimiter
IFS=":" read -a usr_arr1 <<< $usr_input #will be used if user enters a full URL (with HTTPS or HTTP protocol)
#store the user input in an array using "@" as a delimiter
IFS="@" read -a usr_arr2 <<< $usr_input #will be used if user enters an email address
#debugging prints
#repeat the input back to the user
#echo $usr_input
#print the value of the period delimited array
#echo "${usr_arr[-1]}"
#print the value of the colon delimited array
#echo ${usr_arr1[@]}
#echo ${usr_arr2[@]}
#create a regex to find numbers in user input to check if input is an IP address
re='^[0-9]+$'
#conditional statements to determine whether the user has entered a URL, email address, IP address, or domain name
if [ ${usr_arr[0]} = "www" ] || [ ${usr_arr1[0]} = "https" ] || [ ${usr_arr1[0]} = "http" ]; then
	#printf "we have a URL"
	#conditional to extract the domain name depending on how the user entered the URL
	if [ ${usr_arr1[0]} = "https" ] || [ ${usr_arr1[0]} = "http" ]; then
		#grab all array values after the first one in case we have a multi-level subdomains
		domain=$(joinbystring . "${usr_arr[@]:1}")
	elif [ ${usr_arr[0]} = "www" ]; then
		#grab all array values after the first one in case we have a multi-level subdomains
		domain=$(joinbystring . "${usr_arr[@]:1}")
	fi
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;32m Finding information about %s now...\n" $domain
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe IP addresses associated with this domain are: \n\e[0m"
	dig +noall +answer $domain | awk '{print $5}'
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mFinding traceroute information now... this may take a few seconds: \n\e[0m"
	traceroute -I $domain | awk '{print $1, $2, $3}'
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe registrant of this domain is: \n\e[0m"
	whois $domain | grep  Registrant | sort | uniq | sed -e 's/^[ \t]*//' # #grep -v registrant | tail -n  +1 #|
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe registrar of this domain is: \n\e[0m"
	whois $domain | grep Registrar | sort | uniq | sed -e 's/^[ \t]*//' # | grep -v registrant | tail -n  +1
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe network administrator of this domain is: \n\e[0m"
	whois $domain | grep Admin | sort | uniq | sed -e 's/^[ \t]*//' # | grep -v registrant | tail -n  +1
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe tech of this domain is: \n\e[0m"
	whois $domain | grep Tech | sort | uniq | sed -e 's/^[ \t]*//' # | grep -v registrant | tail -n  +1
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
#user entered an email
elif [ ${usr_arr2[1]} ]; then
	domain=${usr_arr2[1]}
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;32mFinding information about %s now...\n" $domain
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe IP addresses associated with this domain are: \n\e[0m"
	dig +noall +answer $domain | awk '{print $5}'
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mFinding traceroute information now... this may take a few seconds: \n\e[0m"
	traceroute -I $domain | awk '{print $1, $2, $3}'
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe registrant of this domain is: \n\e[0m"
	whois $domain | grep  Registrant | sort | uniq | sed -e 's/^[ \t]*//' # #grep -v registrant | tail -n  +1 #|
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe registrar of this domain is: \n\e[0m"
	whois $domain | grep Registrar | sort | uniq | sed -e 's/^[ \t]*//' # | grep -v registrant | tail -n  +1
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe network administrator of this domain is: \n\e[0m"
	whois $domain | grep Admin | sort | uniq | sed -e 's/^[ \t]*//' # | grep -v registrant | tail -n  +1
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe tech of this domain is: \n\e[0m"
	whois $domain | grep Tech | sort | uniq | sed -e 's/^[ \t]*//' # | grep -v registrant | tail -n  +1
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
#must use double square brackets for regex matching
#user entered an IP address
elif [[ ${usr_arr[0]} =~ ^[0-9]+$ ]]; then
	domain=$(joinbystring . ${usr_arr[@]})
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;32mFinding information about IP address %s now...\n" $domain
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe information obtained from the dig command is: \n\e[0m"
	dig $domain
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mFinding traceroute information now... this may take a few seconds: \n\e[0m"
	traceroute -I $domain | awk '{print $1, $2, $3}'
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe registrant information is: \n\e[0m"
	whois $domain | head -35 | sed -e '/^[ \t]*#/d' #sed 's:^#.*$::g'
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe network administrator of this domain is: \n\e[0m"
	whois $domain | grep Admin | sort | uniq | sed -e 's/^[ \t]*//' # | grep -v registrant | tail -n  +1
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe tech of this domain is: \n\e[0m"
	whois $domain | grep Tech | sort | uniq | sed -e 's/^[ \t]*//' # | grep -v registrant | tail -n  +1
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
elif [ "${usr_arr[-1]}" = "com" ] || [ "${usr_arr[-1]}" = "ca" ] || [ "${usr_arr[-1]}" = "uk" ] || [ "${usr_arr[-1]}" = "au" ] || [ "${usr_arr[-1]}" = "nz" ] || [ "${usr_arr[-1]}" = "net" ] || [ "${usr_arr[-1]}" = "org" ] || [ "${usr_arr[-1]}" = "io" ] || [  "${usr_arr[-1]}" = "ai" ] || [ "${usr_arr[-1]}" = "co" ]; then
	domain=$usr_input
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;32mFinding information about %s now...\n" $domain
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe IP addresses associated with this domain are: \n\e[0m"
	dig +noall +answer $domain | awk '{print $5}'
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mFinding traceroute information now... this may take a few seconds: \n\e[0m"
	traceroute -I $domain | awk '{print $1, $2, $3}'
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe registrant of this domain is: \n\e[0m"
	whois $domain | grep  Registrant | sort | uniq | sed -e 's/^[ \t]*//' # #grep -v registrant | tail -n  +1 #|
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe registrar of this domain is: \n\e[0m"
	whois $domain | grep Registrar | sort | uniq | sed -e 's/^[ \t]*//' # | grep -v registrant | tail -n  +1
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe network administrator of this domain is: \n\e[0m"
	whois $domain | grep Admin | sort | uniq | sed -e 's/^[ \t]*//' # | grep -v registrant | tail -n  +1
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
	printf "\e[1;36mThe tech of this domain is: \n\e[0m"
	whois $domain | grep Tech | sort | uniq | sed -e 's/^[ \t]*//' # | grep -v registrant | tail -n  +1
	printf --  "\e[1;34m \n-------------------------------------------------------------\n\n\e[0m"
else
	printf "\n\e[1;36mPlease enter in a correctly formatted input\n\e[0m"
fi

