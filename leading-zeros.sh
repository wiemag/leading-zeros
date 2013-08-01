#!/bin/bash
#leading-zeros.sh v1.0 by Wiesław Magusiak (wm/wiemag/dif) 2013-08-01

# The script renames file names that start with a number, padding such numbers with leading zeros.
# Additionally it may add a prefix.
# Works only in the current directory.
# To see the usage call the script with -h.
# If used, the last argument is the "width" (number of digits including leasing zeros),
# and if the argument is too small, width is expanded to the minimum reqired.
# If called without any arguments, script will calculate the minimum required 
# and do the necessary padding with zeros.

function usage () {
	echo -e "\n\E[1;32mleading-zeros.sh\e[0m renames file names that start in a number."
	echo -e "\nUsage:\n\t\E[1m$(basename $0) [ -h | [-v] [-e EXT] [-p PREFIX] WIDTH ]\E[0m"
	echo -e "Where:\n\tWIDTH is the number of digits including leading zeros;"
	echo -e "\t\"v\" denotes a verbose mode;"
	echo -e "\tEXT is the file extension to filter;"
	echo -e "\tPREFIX is a string added before leading zeros.\n"
}

V=0 		# Verbose mode (0 = No)
EXT=""		# File extension for filtering
PREFIX=""	# File prefix
PN=$#		# No of parameters

while getopts  ":h?ve:p:" flag
do
    case "$flag" in
		h) usage && exit;;
		v) V=1;;
		e) EXT=".$OPTARG" ;;
		p) PREFIX="$OPTARG" ;;
		*) { EXT=" "; PREFIX=" ";}
	esac
done

if [[ "$EXT" == " " || $PREFIX == " " ]]; then
	echo -e "\n\E[1mWrong paremeters!\E[0m"
	usage
	exit
fi

# Do files with extension $EXT exist in the current directory?
s=$(ls -1 [0-9]*${EXT} 2>/dev/null|head -n1)
if [[ $s == "" ]]; then
	echo -e "\nNo file names matching the [0-9]*${EXT} pattern have been found."
	exit
fi

if [[ $(( $[ $PN + $V ] % 2)) == 0 ]]; then
	usage
	for ((t=15;--t;)) {
		echo -en "\rDo you know what you are doing? (Y/n) [$t sek] "
		read -rsn1 -t1 KEY && break
	}
	if [[ "$KEY" != "Y" && "$KEY" != "y" && "$KEY" != "" ]]; then
		echo -en "\r                                               "
		exit
	fi
fi

echo -en "\rWorking...                                    \r"

# Set initial $WIDTH value (either the last argument or one)
[[ $(($[ $PN + $V ] % 2)) -gt 0 ]] && WIDTH=${@:${#@}} || WIDTH=1

# Determine the minimum width
for f in [0-9]*$EXT ; do 
	i=$(echo $(expr "$f" : '[0-9]*'))
	[[ $L -lt $i ]] && L=$i
done

# Adjust width if necessary
[[ $WIDTH -lt $L ]] && WIDTH=$L

# Add $PREFIX and leading zeros
for f in [0-9]*$EXT ; do 
	j=$[ $WIDTH - $(echo $(expr "$f" : '[0-9]*')) ]
	s=''
	for ((k=0; k < $j; k++)){ s=${s}0; }
	if [[ ! -f "${PREFIX}${s}${f}" ]] ; then
		[[ $V == 1  ]] && echo ${PREFIX}${s}${f}
		mv "$f" "${PREFIX}${s}${f}"
	elif [[ "$f" != "${PREFIX}${s}${f}" ]]; then
		echo "File already exists. Skipping "$f" --> "${PREFIX}${s}${f}""
	else
		[[ $V == 1  ]] && echo "$f"
	fi
done
echo "Done.     "
# The end.
