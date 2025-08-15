# Take existing .gnupg folder and create new YubiKey

clear
export GNUPGHOME_EXISTING="/root/KEY/gnupg-2024-09-09-nMEuHHsj7e"
export GNUPGHOME=$(mktemp -d)

export IDENTITY='Andrew Klajman <andrew.klajman@gmail.com>'
export YUBI_ADMIN='^R2@Q1z&2H6&K2dK'
export  YUBI_USER='^R2@Q1z&2H6&K2dK'

export KEY_EXPORT=$(mktemp -d)
export KEY_EXPORT_PUBLIC="$KEY_EXPORT\Public"
export KEY_EXPORT_PRIVATE="$KEY_EXPORT\Private"
export KEY_EXPORT_HOME="$KEY_EXPORT\gnupghome"

export WORKDIR="/persist/YubiKeyReset"

main() {
  load_gpg_home
  variables

  ykman_reset
  gpg_card_check
  setting_up_yubikey
  transfering_keys

  debug
}

load_gpg_home() {
  echo '--- Load GnuPG Home ---'
    cp -r "$GNUPGHOME_EXISTING"/* "$GNUPGHOME"
    export KEYID=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^pub:/ { print $5; exit }')
    export KEYFP=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^fpr:/ { print $10; exit }')
    echo 
}

variables() {
  echo --- Variables ---
    echo "Identity:  $IDENTITY"
    echo "YUBI_ADMIN: $YUBI_ADMIN"
    echo "YUBI_USER:  $YUBI_USER"
    echo "GNUPGHOME: $GNUPGHOME"
    echo "Key ID:    $KEYID"
    echo "Key FP:    $KEYFP"
    echo
}

ykman_reset() { 
  echo '--- Reset YubiKey ---'
  ykman fido     reset -f
  ykman hsmauth  reset -f
  ykman oath     reset -f
  ykman openpgp  reset -f
  ykman otp      delete 1
  ykman otp      delete 2
  ykman piv      reset -f
  echo 
}

gpg_card_check() {
  echo --- Check Card Recognition ---
  echo You need to pull out the card for at least 60 seconds.
  sleep 60 # .................... Initial check for 60 sec
  gpg --card-status

  until [[ "$?" == 0 ]]; do # ... Another check every 10 sec
    sleep 10
    echo
    gpg --card-status
  done

  echo 
}

setting_up_yubikey() {
  echo --- Setting up YubiKey ---
  echo "# Setting the Admin Pin"
gpg --command-fd=0 --pinentry-mode=loopback --change-pin <<EOF
3
12345678
$YUBI_ADMIN
$YUBI_ADMIN
q
EOF
  echo

   echo "# Setting the User Pin"
gpg --command-fd=0 --pinentry-mode=loopback --change-pin <<EOF
1
123456
$YUBI_USER
$YUBI_USER
q
EOF
  echo
}

transfering_keys() {
  echo --- Transfering Keys ---
    echo '# Signature Key'
gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
key 1
keytocard
1
$YUBI_ADMIN
$YUBI_USER
save
EOF
    echo '# Encryption Key'
gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
key 2
keytocard
2
$YUBI_ADMIN
$YUBI_USER
save
EOF
    echo '# Authentication Key'
gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
key 3
keytocard
3
$YUBI_ADMIN
$YUBI_USER
save
EOF
    echo
}

debug() {
  echo --- Debug ---
    echo '# gpg --list-keys'
    gpg --list-keys
    echo
    echo '# gpg --list-secret-keys'
    gpg --list-secret-keys
    echo
    echo '# gpg --card-status'
    gpg --card-status
    echo
}

main 
