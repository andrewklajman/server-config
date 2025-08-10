export IDENTITY='Andrew Klajman <andrew.klajman@gmail.com>'
export WORKDIR="/persist/YubiKeyReset"
export GNUPGFOLDER="gnupg-2024-09-09-nMEuHHsj7e"
export GNUPGHOME="$WORKDIR/DELETE/$GNUPGFOLDER"
export GNUPGHOME="$WORKDIR/DELETE/$GNUPGFOLDER"

export ADMIN_PIN='Newadmin1232'
export  USER_PIN='Newadmin1232'
clear

main() {
  load_gpg_home
  variables

  ykman_reset
  gpg_card_check
  setting_up_yubikey
  transfering_keys

  export_public_key

  debug
}

load_gpg_home() {
  echo '--- Load GnuPG Home ---'
    rm -rf $GNUPGHOME
    cp -r $WORKDIR/DELETE/backup/$GNUPGFOLDER  DELETE/
    ls -l --recursive DELETE/
    export KEYID=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^pub:/ { print $5; exit }')
    export KEYFP=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^fpr:/ { print $10; exit }')
    echo 
}

variables() {
  echo --- Variables ---
    echo "Identity:  $IDENTITY"
    echo "ADMIN_PIN: $ADMIN_PIN"
    echo "USER_PIN:  $USER_PIN"
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
$ADMIN_PIN
$ADMIN_PIN
q
EOF
  echo

   echo "# Setting the User Pin"
gpg --command-fd=0 --pinentry-mode=loopback --change-pin <<EOF
1
123456
$USER_PIN
$USER_PIN
q
EOF
  echo
}

transfering_keys() {
# TODO: I need to check the ADMIN and User pin used below
  echo --- Transfering Keys ---
    echo '# Signature Key'
gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
key 1
keytocard
1
$ADMIN_PIN
$USER_PIN
save
EOF
    echo '# Encryption Key'
gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
key 2
keytocard
2
$ADMIN_PIN
$USER_PIN
save
EOF
    echo '# Authentication Key'
gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
key 3
keytocard
3
$ADMIN_PIN
$USER_PIN
save
EOF
    echo
}

export_public_key() {
  echo --- Debug ---
    echo "# Exporting public key to $WORKDIR"
    gpg --output $WORKDIR/$KEYID-$(date +%F).asc \
        --armor --export $KEYID
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
