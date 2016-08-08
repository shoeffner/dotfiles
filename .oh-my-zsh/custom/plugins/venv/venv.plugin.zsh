find-venv-in-path() {
  abspath=("${(@s=/=)${1:A}}");
  current_path="/";
  for dir in $abspath; do 
    if [[ -d $current_path$dir"/.venv" ]]; then
      print $current_path$dir;
      unset abspath;
      unset current_path;
    fi;
    current_path=$current_path$dir"/";
  done;
  unset abspath;
  unset current_path;
  print "";
}

venv-activate() {
  abspath=("${(@s=/=)${1:A}}");
  if [[ $CURRENT_VENV != $abspath[-1] ]]; then
    source $1/.venv/bin/activate
    export CURRENT_VENV=$abspath[-1];
  fi;
}

venv-deactivate() {
  if [[ $CURRENT_VENV != "" ]]; then
    export CURRENT_VENV="";
    deactivate
  fi;
}

venv-cd() {
  venv_path=$(find-venv-in-path ${1:A})
  cd $1
  if [[ "" == $venv_path ]]; then
    venv-deactivate;
  else
    venv-activate $venv_path;
  fi;
}
alias cd=venv-cd
cd .
