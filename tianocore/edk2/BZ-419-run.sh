OvmfPkg/build.sh -a IA32
mkdir -p startup
echo 'reset -s' > startup/startup.nsh
timeout -s 9 30 qemu-system-i386 -bios Build/OvmfIa32/DEBUG_GCC5/FV/OVMF.fd \
	-net none -nographic -hda fat:rw:startup < /dev/null || exit 1
