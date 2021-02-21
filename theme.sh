#! /usr/bin/env bash


Apply() {
   local SelectedPalette=${THEMES[$1]}
   cp -f $SelectedPalette ./colors.property
   
   # Atualiza o banco de dados
   xrdb -remove
   xrdb -merge ~/.Xresources
}



Format() {
    basename $1 | cut -f1 -d.
}


Menu() {
    count=0
    for i in ${THEMES[@]}; do
	printf "[ %s ]\t%s \\n" "$count" "$(Format $i)"
        ((++count))
    done

    printf "%s" 'Select one option: '; read INPUT
    echo ""
    if [[ $INPUT -ge 0 && $INPUT -lt ${#THEMES[@]} ]] ; then
        return 0
    else
        return 1
    fi
}


Main() {
    Menu
    if [ $? -eq 0 ]; then
        Apply $INPUT
	[ $? -eq 0 ] && printf "*\033[00;32m %s\033[00;m %s\\n" \
            "$(Format ${THEMES[$INPUT]})" \
	    "theme successfully applied"
   else
       printf "\033[1;31m%s\033[00;m\\n"\
              "Invalid option!"
   fi
}


Search() {
   find ./themes/ -name "[[:alpha:]]*[.]property"
} 

# Altera o diretório corrente
if [ -d $HOME/.Xresources.d/themes ]; then
    cd $HOME/.Xresources.d
else
    echo "Directory not found!"
    exit 1
fi

# Implementa o path a um array 
count=0
for i in $(Search); do
    THEMES[$count]=$i
    ((++count))
done 

# Checa se há temas
if [ $count -eq 0 ]; then
    echo "There are no palettes in the directory"
    exit 1 
fi
# Função primária
Main

