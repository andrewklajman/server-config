
The goal of this guide is to provide an overview on how to use and setup a yubikey and gpg environment.

    https://github.com/drduh/YubiKey-Guide?tab=readme-ov-file#purchase-yubikey

# Purchase YubiKey

The YubiKey is a USB device which can perform security related functions.
Prominently in this environment we will be taking advantage of the function of
saving private keys to the YubiKey and holding them behind a password.

This is considered a more secure method of holidng private keys since the
Yubikey will not share them with the host computer, will hold all private keys
behind a common password, and has the option of permenantly hiding the private
keys if the common password is misused more then n times.

# Establishing the secure environment

This involves creating a base enviornment so that the gpg keys can be created
and transfered to the Yubi Key

We need an environment to be able to create and transmit the public and private
keys that is secure.  The most secure method to achieve this is a fresh,
untouched airgapped computer.

A purpose built air gapped nixos environment can achieve this or a debian live
cd with appropriate installation can be used.

## Generate GPG Keys

The GNUPGHOME variable will be used to direct the GnuPG home directory to reside
in the /tmp directory to ensure that it will be deleted on reboot.

    export GNUPGHOME=$(mktemp -d -t $(date +%Y.%m.%d)-XXXX)

A custom GnuPG confiugration should be used to ensure that hardened secutity is
used

    cd $GNUPGHOME
    wget https://raw.githubusercontent.com/drduh/config/main/gpg.conf

An IDENTITY variable needs to be set up to ensure users can be quickly input.

    export IDENTITY="YubiKey User <yubikey@example>"

The KEY_TYPE variable will identify the algorithm that should be used

    export KEY_TYPE=rsa4096

The EXPIRATION variable will set the expiration that should apply to the subkey

    export EXPIRATION=2y

The CERTIFY_PASS variable refers to the creation of a passphrase for the certify
key.

    export CERTIFY_PASS=$(LC_ALL=C tr -dc 'A-Z1-9' < /dev/urandom | \
      tr -d "1IOS5U" | fold -w 30 | sed "-es/./ /"{1..26..5} | \
      cut -c2- | tr " " "-" | head -1) ; printf "\n$CERTIFY_PASS\n\n"

### Create Certify Key

The certiy key is the key that is used to generate the subkeys

    echo "$CERTIFY_PASS" | gpg --batch --passphrase-fd 0 \
        --quick-generate-key "$IDENTITY" "$KEY_TYPE" cert never

After the Certify key is created the ID and the Fingerprint variables need to
record their respective values for ....

    export KEYID=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^pub:/ { print $5; exit }')
    export KEYFP=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^fpr:/ { print $10; exit }')
    printf "\nKey ID: %40s\nKey FP: %40s\n\n" "$KEYID" "$KEYFP"

### Create Subkeys

The sign, encrypt and auth keys can be created now that the master (certify key)
was created.

    for SUBKEY in sign encrypt auth ; do \
      echo "$CERTIFY_PASS" | gpg --batch --pinentry-mode=loopback --passphrase-fd 0 \
          --quick-add-key "$KEYFP" "$KEY_TYPE" "$SUBKEY" "$EXPIRATION"
    done

### Key Verification 

The creation of all of the keys can be verified with the command

    gpg -K

Something similar to the following table should be generated

    sec   rsa4096/0xF0F2CFEB04341FB5 2024-01-01 [C]
          Key fingerprint = 4E2C 1FA3 372C BA96 A06A  C34A F0F2 CFEB 0434 1FB5
    uid                   [ultimate] YubiKey User <yubikey@example>
    ssb   rsa4096/0xB3CD10E502E19637 2024-01-01 [S] [expires: 2026-05-01]
    ssb   rsa4096/0x30CBE8C4B085B9F7 2024-01-01 [E] [expires: 2026-05-01]
    ssb   rsa4096/0xAD9E24E1B8CB9600 2024-01-01 [A] [expires: 2026-05-01]

### Exporting all keys (private and public)

All of the keys (private and public) should be backed up too offline secure
storage

    echo "$CERTIFY_PASS" | gpg --output $GNUPGHOME/$KEYID-Certify.key \
        --batch --pinentry-mode=loopback --passphrase-fd 0 \
        --armor --export-secret-keys $KEYID
    
    echo "$CERTIFY_PASS" | gpg --output $GNUPGHOME/$KEYID-Subkeys.key \
        --batch --pinentry-mode=loopback --passphrase-fd 0 \
        --armor --export-secret-subkeys $KEYID
    
    gpg --output $GNUPGHOME/$KEYID-$(date +%F).asc \
        --armor --export $KEYID

### Exporting public key

...

    gpg --armor --export $KEYID | doas tee /mnt/public/$KEYID-$(date +%F).asc

## Configuring YubiKey

To configure the Yubi key the Pins (user and admin) need to be setup and the
keys also need to be transferred to it.

To confirm the card status plug it into the computer and run 

    gpg --card-status

### Set YubiKey Pins

The YubiKey Pins grant access to the YubiKey.  The User Pin grants access to the
keys.  The Admin Pin grants access to administration functions (changing pin,
reset code, ...)

This script will set some default user pins

    export ADMIN_PIN=$(LC_ALL=C tr -dc '0-9' < /dev/urandom | fold -w8 | head -1)
    export USER_PIN=$(LC_ALL=C tr -dc '0-9' < /dev/urandom | fold -w6 | head -1)
    printf "\nAdmin PIN: %12s\nUser PIN: %13s\n\n" "$ADMIN_PIN" "$USER_PIN"

Setting the Admin Pin

    gpg --command-fd=0 --pinentry-mode=loopback --change-pin <<EOF
    3
    12345678
    $ADMIN_PIN
    $ADMIN_PIN
    q
    EOF

Setting the User Pin 

    gpg --command-fd=0 --pinentry-mode=loopback --change-pin <<EOF
    1
    123456
    $USER_PIN
    $USER_PIN
    q
    EOF

After this remove the YubiKey and plug it back in.

### Transferring Subkeys to the YubiKey

The transfer of the subkeys to the YubiKey can now take place.  But note this is
a one way operation so make sure that backups were performed.

Signature Key Transfer

    gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
    key 1
    keytocard
    1
    $CERTIFY_PASS
    $ADMIN_PIN
    save
    EOF

Encryption Key Transfer

    gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
    key 2
    keytocard
    2
    $CERTIFY_PASS
    $ADMIN_PIN
    save
    EOF

Authentication Key Transfer

    gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
    key 3
    keytocard
    3
    $CERTIFY_PASS
    $ADMIN_PIN
    save
    EOF

### Verifaction of transfer of subkeys

It can be confirmed that the subkeys were transferred by using 

    gpg -K

The output should be similar to the below where the ssb now has a '>'

    sec   rsa4096/0xF0F2CFEB04341FB5 2024-01-01 [C]
          Key fingerprint = 4E2C 1FA3 372C BA96 A06A  C34A F0F2 CFEB 0434 1FB5
    uid                   [ultimate] YubiKey User <yubikey@example>
    ssb>  rsa4096/0xB3CD10E502E19637 2024-01-01 [S] [expires: 2026-05-01]
    ssb>  rsa4096/0x30CBE8C4B085B9F7 2024-01-01 [E] [expires: 2026-05-01]
    ssb>  rsa4096/0xAD9E24E1B8CB9600 2024-01-01 [A] [expires: 2026-05-01]

### Finishing Setup

At this point the setup is complete.  The keys have been generated, the backups
have been stored and the YubiKey is now avaiable for use on other machines.

Before closing up the temporary environment make sure that the following items
have been checked off.

    - The CERTIFY_PASS variable has been memorized or written down
    - The Certify and Sub keys have been stored on secured usb keys
    - The public keys have been exported to an external usb key
    - The YubiKey User and Admin Pins have been memorized
    - The Subkeys have been pushed to the YubiKey (the '>' in `gpg -K`)

# Implementation on main pc

Now that the YubiKey is available it is necessary to set up on your daily pc.

## Setting up GnuPG

As before a hardened GnuPG config should be used

    cd ~/.gnupg
    wget https://raw.githubusercontent.com/drduh/config/main/gpg.conf
    touch scdaemon.conf
    echo "disable-ccid" >>scdaemon.conf

The installation of the required packages also needs to be performed

    gnupg gnupg-agent scdaemon pcscd

The public key should be imported onto the pc

    gpg --import /mnt/public/*.asc

Derive the public key id 

    gpg -k
    export KEYID=0x.....

Assign complete trust to the new key 

    gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
    trust
    5
    y
    save
    EOF

Reinsert the YubiKey and confirm its status

    gpg --card-status

# Perform tests

At this point the YubiKey and your daily driver should be operating according to
expectations.  So it is worth performing some tests.

## Encryption

Encrypting a message 

    echo -e "\ntest message string" | \
      gpg --encrypt --armor \
          --recipient $KEYID --output encrypted.txt

Decrypting a message

    gpg --decrypt --armor encrypted.txt

## Signing a message

Signing a message

    echo "test message string" | gpg --armor --clearsign > signed.txt

Verifying a message

    gpg --verify signed.txt

## Other operations

Other operations that can be performed but will not be described in detail here
are 

    - SSH 
    - SSH Agent Forwarding
    - GitHub
    - GnuPG Agent Forwarding
    - Using multiple YubiKeys
    - Email encryption

# YubiKey and GnuPG Maintenance

Sometimes keys will need to be renewed or rotated.  This requires following the
same process as above:

1. Boot into secure environment
2. Install software
3. Disable networking
4. Mount private keys and copy them to the GNUPGHOME

    sudo cryptsetup luksOpen /dev/sdc1 gnupg-secrets
    sudo mkdir /mnt/encrypted-storage
    sudo mount /dev/mapper/gnupg-secrets /mnt/encrypted-storage
    export GNUPGHOME=$(mktemp -d -t $(date +%Y.%m.%d)-XXXX)
    cp -avi /mnt/encrypted-storage/2025.12.31-AbCd/* $GNUPGHOME/

5. Derive the KeyID and Key Fingerprint

    gpg -K
    export KEYID=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^pub:/ { print $5; exit }')
    export KEYFP=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^fpr:/ { print $10; exit }')
    echo $KEYID $KEYFP

6. Update the certify password variable

    export CERTIFY_PASS=ABCD-0123-IJKL-4567-QRST-UVWX


7. Mount Public keys

    sudo mkdir /mnt/public
    sudo mount /dev/sdc2 /mnt/public

8. Proceed with either Renewing or Rotating Subkeys accordingly

## Renew Subkeys

Renewing subkeys means extending the expiration on the keys.

First update the expiration variables

    export EXPIRATION=2026-09-01
    export EXPIRATION=2y

Renew the subkey

    echo "$CERTIFY_PASS" | gpg --batch --pinentry-mode=loopback \
      --passphrase-fd 0 --quick-set-expire "$KEYFP" "$EXPIRATION" \
      $(gpg -K --with-colons | awk -F: '/^fpr:/ { print $10 }' | tail -n "+2" | tr "\n" " ")

Update the public key

    gpg --armor --export $KEYID | sudo tee /mnt/public/$KEYID-$(date +%F).asc
    gpg --import /mnt/public/*.asc

## Rotate subkey
