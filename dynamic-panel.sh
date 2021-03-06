#!/bin/bash

testCurrentColor() {
	if [ $2 -gt 179 ]; then
		STYLE="clean"
		changeTheme "$1" "$STYLE" "`echo "$1" | sed 's/[^0-9]//g'`"
	else
		STYLE="dark"
		changeTheme "$1" "$STYLE" "`echo "$1" | sed 's/[^0-9]//g'`"
	fi
}

changeTheme() {
	rm -rf "$THEME"*
	cat "/usr/share/dynamic-panel/$2.diff" | sed "s/HEADER_COLOR/$1/g" > "/tmp/current.diff"
	cp -r "$OR_THEME" "$THEME$3"
	patch -s "$THEME$3/gnome-shell/gnome-shell.css" "/tmp/current.diff"
	gsettings set org.gnome.shell.extensions.user-theme name "$( basename "$THEME$3" )"
}

OR_THEME="/usr/share/themes/Dynamic"
THEME="$HOME/.local/share/themes/Dynamic-"
if [ "`gsettings get org.gnome.shell.extensions.user-theme name`" == "'`basename $OR_THEME`'" ] && [ "$1" == "--reset" ]; then
		exit
elif [ "$1" == "--reset" ]; then
		rm -rf "$THEME"*
		gsettings set org.gnome.shell.extensions.user-theme name "$( basename "$OR_THEME" )"
		exit
fi
testCurrentColor "$1" "$2"
