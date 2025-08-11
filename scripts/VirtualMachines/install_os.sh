CDROM=""
HDD_FILE=""
HDD_FMAT=""
MEMORY="512M"

HDD="file=$HDD_FILE,format=$HDD_FMAT"

qemu-system-x86_64 \
  -cdrom "$CDROM" -boot order=d \
  -drive "$HDD" \
  -m "$MEMORY" \
  -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
  -enable-kvm

