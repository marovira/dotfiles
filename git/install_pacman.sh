#!/bin/bash

# Script to install pacman package management
# in Git for Windows Portable
# To be run from a git-bash session.

GITURL="https://github.com/git-for-windows/git-sdk-64.git"
RAWURL="https://github.com/git-for-windows/git-sdk-64/raw"
RAWURLB="https://raw.githubusercontent.com/git-for-windows/git-sdk-64"

rm -rf git-sdk-64
# Clone tiny blobless shallow repo
git clone \
    --depth 150 \
    --filter=blob:none \
    --no-checkout \
    $GITURL

cd git-sdk-64 || exit
git pull

### Pre install minimal pacman bootstrap
d="var/lib/pacman/local"
mkdir -p "/$d"
pkgs=('pacman-[0-9]' 'gettext-[0-9]' 'pacman-mirrors-' 'msys2-keyring-')
for j in ${pkgs[@]} ; do
    pacvers=$(basename $( git show main:$d | grep "$j" ))
    echo "Bootstrapping: $pacvers"
    shfiles=$(curl -sSL $RAWURLB/main/$d/$pacvers/files )
    for f in $shfiles
    do
        if [[ $f = *"/"* ]] && [[ $f != *"/man/"* ]] && [[ $f != *"locale/"* ]] && [[ $f != *\/ ]]
        then
            if [ ! -f "/$f" ]; then
                mkdir -p /$(dirname "$f" )
                curl -sSL $RAWURLB/main/$f -o /$f &
                [ $( jobs | wc -l ) -ge $( nproc ) ] && wait
            fi
        fi
    done
    wait
done
wait

mkdir -p /var/lib/pacman
rm -rf /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate msys2
curl -L https://raw.githubusercontent.com/git-for-windows/build-extra/HEAD/git-for-windows-keyring/git-for-windows.gpg |\
pacman-key --add - &&
pacman-key --lsign-key E8325679DFFF09668AD8D7B67115A57376871B1C
pacman -Sy

################
#Restore Pacman metadata
commits=$(git log --pretty=%H)

spdup ()
{
    package=$1
    version=$2
    found=false
    for cs in $commits ; do
        d=var/lib/pacman/local/$package-$version
        if git show $cs:$d >/dev/null 2>&1; then
            [ ! -d /$d ] && mkdir -p /$d
            for f in desc files install mtree; do
                if git show $cs:$d/$f > /dev/null 2>&1; then
                    [ ! -f "/$d/$f" ] && curl -sSL "$RAWURL/$cs/$d/$f" -o /$d/$f
                fi
            done
            echo -e "Restored:\t$package $version"
            found=true
            break
        fi
    done

    # If version not found in SDK, clear the local folder so pacman can fresh-install
    if [ "$found" = false ]; then
        echo -e "DRIFT DETECTED:\t$package $version (Skipping metadata)"
        rm -rf /var/lib/pacman/local/$package-$version
    fi
}

while read -r package version; do
    [ -z "$package" ] && continue
    spdup "$package" "$version"&
    if [[ $(jobs -r | wc -l) -ge $(nproc) ]]; then
        wait -n
    fi
done < /etc/package-versions.txt

pacman -Sy --noconfirm --overwrite '*' filesystem libxml2 liblzma icu gcc-libs bash-completion

# Sync new repositories. This will also allow downgrades as well. This will also kill the MSYS2
echo
echo
echo "###################################################################"
echo "#                                                                 #"
echo "#                                                                 #"
echo "#                   W   A   R   N   I   N   G                     #"
echo "#                                                                 #"
echo "#    Select Y to re-install MSYS2. After restart, manually run    #"
echo "#          'pacman -Suu' to update rest of applications.          #"
echo "#                                                                 #"
echo "#                                                                 #"
echo "###################################################################"
echo
echo
read -rs -p $"Press escape or arrow key to continue or wait 5 seconds..." -t 5 -d $'\e';echo;
pacman -Syyuu --overwrite "*"
