selection=$(fd . --hidden --type file $HOME 2>/dev/null | \
    sed "s;$HOME;~;" | \
    rofi -sort -sorting-method fzf -disable-history -dmenu -no-custom -p "" | \
    sed "s;\~;$HOME;"
)

#open "$selection" 
