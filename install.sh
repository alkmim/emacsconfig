date=$(date +%D%T | sed s#:##g | sed s#/##g)
cp -v ~/.emacs ~/.emacs-$date
cp -v emacs ~/.emacs

exit 0
