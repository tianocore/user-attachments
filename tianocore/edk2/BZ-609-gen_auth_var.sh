#!/bin/sh

#
# Copyright 2020 Intel Corporation
# SPDX-License-Identifier: BSD-2-Clause-Patent
#

red='\033[0;31m'
blue='\033[0;34m'
dark_grey='\033[1;30m'
purple='\033[1;35m'
cyan='\033[0;36m'
color_end='\033[0m'

gen_signed_authvar()
{
	rsa=$1
	digest=$2
	var=$3
	signed=$4
	signer=$5

	echo ${cyan}
	echo "Generating"
	echo "    $signed.key"
	echo "    $signed.crt"
	echo "    $signed.cer"
	echo "    $signed.esl"
	echo "    $signed.auth signed using $signer.key $signer.crt"
	echo ${color_end}

	openssl req -newkey rsa:$rsa -nodes -keyout $signed.key -new -x509 -sha$digest -days 3650 -subj "/CN=$var/" -out $signed.crt
	openssl x509 -outform DER -in $signed.crt -out $signed.cer
	./cert-to-efi-sig-list -g "$(< GUID.txt)" $signed.crt $signed.esl
	./sign-efi-sig-list -g "$(< GUID.txt)" -k $signer.key -c $signer.crt -d sha$digest $var $signed.esl $signed.auth
	./bin2arr --infile $signed.auth --outfile $signed.c
}

print_authvar_log()
{
	rsa=$1
	digest=$2
	var=$3

	log="${log} Generating Auth variable $var with"
	log="${log} RSA$rsa"
	log="${log}SHA$digest"
	echo ${cyan}"**" 
	echo "* " $log
	echo "**" ${color_end}
}

gen_secboot_vars()
{
	rsa=$1
	digest=$2

	# Generate PK
	pk="PK"
	print_authvar_log $rsa $digest $pk
	uuidgen --random > GUID.txt
	gen_signed_authvar $rsa $digest $pk $pk $pk

	# Generate KEK
	kek="KEK"
	print_authvar_log $rsa $digest KEK
	gen_signed_authvar $rsa $digest $kek $kek $pk

	# Generate DB
	db="db"
	print_authvar_log $rsa $digest DB
	gen_signed_authvar $rsa $digest $db $db $kek
}

gen_authvar()
{
	rsa=$1
	digest=$2
	var=$3
	timeout=2

	length=$(echo ${#var})
	upper=$(echo $var | cut -c1)
	lower=$(echo $var | cut -c2-$length)
	lower=$(echo $lower | tr [A-Z] [a-z])
	varname=${upper}${lower}

	print_authvar_log $rsa $digest $var

	uuidgen --random > GUID.txt

	# Generate base version of AuthVar
	echo "Generating the self signed base version of $var"
	base_ver=${varname}
	base_ver=${base_ver}Rsa$rsa
	base_ver=${base_ver}Sha$digest
	gen_signed_authvar $rsa $digest $var $base_ver $base_ver

	echo "Sleeping for $timeout seconds to introduce a gap of few seconds between variable timestamp"
	sleep $timeout

	# Generate a newer version of AuthVar for update
	echo "Generating the updated version of $var"
	update_ver=${varname}
	update_ver="${update_ver}NewRsa$rsa"
	update_ver="${update_ver}Sha$digest"
	gen_signed_authvar $rsa $digest $var $update_ver $base_ver
}

help()
{
	echo "Usage:"
	echo "$0 --rsa=<key_size> --digest=<digest_size> --var=<variable name>"
	echo "Example: $0 --rsa=2048 --digest=256 --var=PK"
	echo "--rsa=<2048, 3072, 4096>"
	echo "      2048: generate AuthVar with RSA2048SHAxxx signing algorithm"
	echo "      3072: generate AuthVar with RSA3072SHAxxx signing algorithm"
	echo "      4096: generate AuthVar with RSA4096SHAxxx signing algorithm"
	echo "--digest=<256, 384, 512>"
	echo "         256: generate AuthVar with RSAXXXXSHA256 signing algorithm"
	echo "         384: generate AuthVar with RSAXXXXSHA384 signing algorithm"
	echo "         512: generate AuthVar with RSAXXXXSHA512 signing algorithm"
	echo "--var=<variable>"
	echo "      e.g. PK: generate a base and an update version of variable named PK"
}

check_rsa()
{
	case $1 in
		2048|3072|4096)
			return 0;;
		*)
			echo ${red}"$1 is an invalid RSA key length identifier"${color_end}
			return 1;;
	esac

}

check_digest()
{
	case $1 in
		256|384|512)
			return 0;;
		*)
			echo ${red}"$1 is invalid digest algorithm identifier"${color_end}
			return 1;;
	esac

}

# Parse command line arguments
OPTIONS=`getopt -o h --longoptions rsa::,var::,digest::,secboot,help -n "$0" -- "$@"`
if [ $? -ne 0 ]; then
	help
	return 1
fi
eval set -- "$OPTIONS"

# Setting default values
rsa=2048
digest=256
var="PK"
secboot=0

while true; do
	case "$1" in
		--rsa)
			rsa=$2
			check_rsa $2
			if [ $? -ne 0 ]; then
				help
				return 1
			fi
			shift 2;;

		--digest)
			digest=$2
			check_digest $2
			if [ $? -ne 0 ]; then
				help
				return 1
			fi
			shift 2;;

		--var)
			var=$2
			shift 2;;

		--secboot)
			secboot=1
			break;;

		-h|--help)
			help
			return 1;;

		--)
			break;;
		*)
			help; return 1
	esac
done

if [ $secboot -ne 0 ]; then
	gen_secboot_vars 2048 256
else
	gen_authvar $rsa $digest $var
fi
