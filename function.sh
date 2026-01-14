function mcd(){
	mkdir $1
	cd $?
}

# open dictrectoy
function o(){
	if [[ $# -eq 0 ]];then
		open .
	else
		open "$@"
	fi
}


