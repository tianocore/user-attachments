## @file
# Bash shell script for generating test certificates, for
# <https://bugzilla.tianocore.org/show_bug.cgi?id=960>.
#
# Copyright (C) 2019, Red Hat, Inc.
#
# SPDX-License-Identifier: BSD-2-Clause-Patent
#
# Customize te variables in section "Configuration", then run the script with
# "bash gencerts.sh".
#
# The script creates 17 files in the current working directory:
# - one CA certificate (note: key is discarded);
#
# - for the (IPv4 domain name, IPv4 address) pair, one keypair (that is, a
#   CA-issued certificate, plus the private key) for each case below:
#   - Common Name = IPv4 domain name,     no subjectAltName,
#   - Common Name = IPv4 domain name,     IPv4 address in subjectAltName,
#   - Common Name = IPv4 address literal, no subjectAltName,
#   - Common Name = IPv4 address literal, IPv4 address in subjectAltName;
#
# - for the (IPv6 domain name, IPv6 address) pair, a similar set of files.
#
# Finally, the script prints some commands for the root user that are related
# to the following OVMF feature: OVMF can HTTPS boot while trusting the same
# set of CA certificates that the virt host trusts. The commands install the
# new CA certificate on the host (note: this should never be done in
# production, in spite of the CA key being discarded), and also extract all CA
# certs in the format that OVMF expects. (This edk2-specific extraction is
# normally performed by the "update-ca-trust" command, but if yours isn't
# up-to-date enough for that, build and install p11-kit from source, and set
# MY_P11_KIT_PREFIX, before invoking this script.) See "OvmfPkg/README" for
# passing the extracted CA certs to OVMF on the QEMU cmdline.
##
set -e -u -C

# Configuration.
CA_NAME=TianoCore_BZ_960_CA
IPV4_NAME=ipv4-server
IPV4_ADDR=192.168.124.2
IPV6_NAME=ipv6-server
IPV6_ADDR=fd33:eb1b:9b36::2

# Create a temporary directory for transient files.
TMP_D=$(mktemp -d)
trap 'rm -f -r -- "$TMP_D"' EXIT

# Set some helper variables.
TMP_EXT=$TMP_D/ext       # OpenSSL extensions
TMP_CSR=$TMP_D/csr       # certificate request
TMP_CA_KEY=$TMP_D/ca.key # CA key
TMP_CA_SRL=$TMP_D/ca.srl # CA serial number

# Generate the CA certificate.
openssl req -x509 -nodes \
  -subj   /CN="$CA_NAME" \
  -out    "$CA_NAME".crt \
  -keyout "$TMP_CA_KEY"

# Create a CA-issued certificate.
# Parameters:
# $1: Common Name
# $2: IPv4 or IPv6 address literal, to be used in SAN; or empty string
gencrt()
{
  local CN="$1"
  local SANIP="$2"
  local STEM
  local EXT

  if test -z "$SANIP"; then
    # File name stem consists of Common Name only. No certificate extensions.
    STEM=svr_$CN
    EXT=
  else
    # File name stem includes Common Name and IP address literal.
    STEM=svr_${CN}_${SANIP}

    # SAN IP extension in the certificate. Rewrite the ad-hoc extensions file
    # with the current SAN IP.
    echo "subjectAltName=IP:$SANIP" >| "$TMP_EXT"
    EXT="-extfile $TMP_EXT"
  fi
  STEM=${STEM//[:.]/_}

  # Generate CSR.
  openssl req -new -nodes \
    -subj   /CN="$CN" \
    -out    "$TMP_CSR" \
    -keyout "$STEM".key

  # Sign the certificate request, potentially adding the SAN IP.
  openssl x509 -req -CAcreateserial $EXT \
    -in       "$TMP_CSR" \
    -out      "$STEM".crt \
    -CA       "$CA_NAME".crt \
    -CAkey    "$TMP_CA_KEY" \
    -CAserial "$TMP_CA_SRL"
}

# Generate all certificates.
gencrt "$IPV4_NAME" ""           # domain name in CN,  no SAN IPv4
gencrt "$IPV4_NAME" "$IPV4_ADDR" # domain name in CN,     SAN IPv4
gencrt "$IPV4_ADDR" ""           # IPv4 literal in CN, no SAN IPv4
gencrt "$IPV4_ADDR" "$IPV4_ADDR" # IPv4 literal in CN,    SAN IPv4
gencrt "$IPV6_NAME" ""           # domain name in CN,  no SAN IPv6
gencrt "$IPV6_NAME" "$IPV6_ADDR" # domain name in CN,     SAN IPv6
gencrt "$IPV6_ADDR" ""           # IPv6 literal in CN, no SAN IPv6
gencrt "$IPV6_ADDR" "$IPV6_ADDR" # IPv6 literal in CN,    SAN IPv6

# Print commands for the root user:
# - for making the CA a trusted CA
echo
echo install -o root -g root -m 644 -t /etc/pki/ca-trust/source/anchors \
  "$PWD/$CA_NAME".crt
echo restorecon -Fvv /etc/pki/ca-trust/source/anchors/"$CA_NAME".crt
echo update-ca-trust extract

# - and for extracting the CA certificates for OVMF.
if test -v MY_P11_KIT_PREFIX; then
  echo mkdir -p -v /etc/pki/ca-trust/extracted/edk2
  echo chmod -c --reference=/etc/pki/ca-trust/extracted/java \
    /etc/pki/ca-trust/extracted/edk2
  echo "$MY_P11_KIT_PREFIX/bin/p11-kit" extract --overwrite \
    --format=edk2-cacerts \
    --filter=ca-anchors \
    --purpose=server-auth \
    /etc/pki/ca-trust/extracted/edk2/cacerts.bin
  echo chmod -c --reference=/etc/pki/ca-trust/extracted/java/cacerts \
    /etc/pki/ca-trust/extracted/edk2/cacerts.bin
  echo restorecon -FvvR /etc/pki/ca-trust/extracted/edk2
fi
