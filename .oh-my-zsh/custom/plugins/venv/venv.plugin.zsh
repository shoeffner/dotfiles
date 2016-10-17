declare -f + venv-find-in-path > /dev/null || venv-find-in-path() {
  abspath=("${(@s=/=)${1:A}}");
  current_path="/";
  for dir in $abspath; do
    if [[ -f $current_path$dir"/pip-selfcheck.json" || -f $current_path$dir"/pyvenv.cfg" || -d $current_path$dir"/.venv" ]]; then
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

declare -f + venv-activate > /dev/null || venv-activate() {
  abspath=("${(@s=/=)${1:A}}")
  if [[ $VENV_VIRTUAL_ENV != $abspath[-1] ]]; then
    if [[ -f $1/bin/activate ]]; then
      source $1/bin/activate
      export VENV_VIRTUAL_ENV_ROOT=$1
      export VENV_VIRTUAL_ENV=$abspath[-1]
    elif [[ -f $1/.venv/bin/activate ]]; then
      source $1/.venv/bin/activate
      export VENV_VIRTUAL_ENV_ROOT="$abspath/.venv"
      export VENV_VIRTUAL_ENV=$abspath[-1]
    fi
  fi;
}

declare -f + venv-deactivate > /dev/null || venv-deactivate() {
  if [[ -n $VENV_VIRTUAL_ENV ]]; then
    export VENV_VIRTUAL_ENV=""
    export VENV_VIRTUAL_ENV_ROOT=""
    if [[ $(whence deactivate) == "deactivate" ]]; then
      deactivate
      return 0
    fi
  fi
}

# currently only for pyvenv in python3.4+
declare -f + venv-freeze > /dev/null || venv-freeze() {
  if [[ -n $VENV_VIRTUAL_ENV ]]; then
      cat $VENV_VIRTUAL_ENV_ROOT/pyvenv.cfg | grep include-system-site-packages | grep true > /dev/null
      uses_system=$?
      if [ $uses_system -eq 0 ]; then
          venv_path=$VENV_VIRTUAL_ENV_ROOT
          sed -i.bak 's/include-system-site-packages = true/include-system-site-packages = false/g' $venv_path/pyvenv.cfg
          venv-deactivate
          venv-activate $venv_path
      fi
      pip freeze > requirements.txt
      if [ $uses_system -eq 0 ]; then
          sed -i.bak 's/include-system-site-packages = false/include-system-site-packages = true/g' $venv_path/pyvenv.cfg
          rm $venv_path/pyvenv.cfg.bak
          venv-deactivate
          venv-activate $venv_path
      fi
      return 0
  fi
}

declare -f + venv-cd > /dev/null || venv-cd() {
  venv_path=$(venv-find-in-path ${1:A})
  cd $1
  if [[ -z $venv_path ]]; then
    venv-deactivate
  else
    venv-activate $venv_path
  fi
}
alias cd=venv-cd
cd .
