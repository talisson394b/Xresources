#! /bin/bash

# DIRECTORY STRUCTURE

#  /HOME/.Xresources
#  /HOME/.Xresources.d
#  |----/colors
#  |   |----/dark
#  |       |----/dark.sh
#  |	   |----/dark.properties
#  |----/colors.Xresources  


DIR="${HOME}/.Xresources.d"
PALETTES_DIR="${DIR}/themes"
PALETTES_NAMES=`ls $PALETTES_DIR`
RESOURCES="${HOME}/.Xresources"


function _list {
    count=1
    echo "Avaliable options:"
    for f in $PALETTES_NAMES; do
        echo "$count $f"
        ((count++))
    done
}


function _compare() {
    for t in $PALETTES_NAMES; do
        if [ "$t" == "$1" ]; then
	    echo true
	    return
	fi
    done
    echo false
}


function _apply() {
    local T="$PALETTES_DIR/$1/$1.property"
    cp -f $T "${DIR}/colors.Xresources"
    
    # Atualiza o banco de dados
    xrdb -remove
    xrdb -merge $RESOURCES
    
    echo "Successfully applied $1 theme."
}


function main {
    if ! [[ "$1" = "--list"  ||  -z "$1" ]]; then
	if "$(_compare $1)"; then
	     _apply $1
	else
	    echo "This theme does not exist."
	    _list
	fi
    else
       _list
    fi
}


# Verifica a existência dos diretórios
for dir in $DIR $PALETTES_DIR; do
    if ! [[ -d $dir ]]; then
        echo "$dir: Not found."
	exit 1
    fi
done

main "$@"
