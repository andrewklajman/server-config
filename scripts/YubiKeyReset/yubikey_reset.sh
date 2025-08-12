# Take existing .gnupg folder and create new YubiKey
clear
export GNUPGHOME_EXISTING="/persist/YubiKeyReset"
export GNUPGHOME=$(mktemp -d)

export IDENTITY='Andrew Klajman <andrew.klajman@gmail.com>'
export YUBI_ADMIN='Newadmin1232'
export  YUBI_USER='Newadmin1232'

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

  export_public_keys
  export_private_keys
  export_gpg_home

  debug
}

load_gpg_home() {
  echo '--- Load GnuPG Home ---'
    cp -r $GNUPG_EXISTING $GNUPGHOME
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

export_public_keys() {
  echo "-- Exporting public key to $KEY_EXPORT_PUBLIC"
  mkdir -p $KEY_EXPORT_PUBLIC
  gpg --output $KEY_EXPORT_PUBLIC/$KEYID-$(date +%F).asc \
      --armor --export $KEYID
  echo
}

export_private_keys() {
  echo "-- Exporting private key to $KEY_EXPORT_PRIVATE"
  mkdir -p $KEY_EXPORT_PRIVATE
  gpg --output $KEY_EXPORT_PRIVATE/$KEYID-Certify.key \
      --batch --pinentry-mode=loopback --passphrase-fd 0 \
      --armor --export-secret-keys $KEYID
  
  gpg --output $KEY_EXPORT_PRIVATE/$KEYID-Subkeys.key \
      --batch --pinentry-mode=loopback --passphrase-fd 0 \
      --armor --export-secret-subkeys $KEYID

  gpg --output $KEY_EXPORT_PRIVATE/$KEYID-$(date +%F).asc \
      --armor --export $KEYID
}

export_gpg_home() {
  echo "-- Exporting gnupg to $KEY_EXPORT_HOME"
    mkdir -p $KEY_EXPORT_HOME
    cp -r $GNUPGHOME $KEY_EXPORT_HOME
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
