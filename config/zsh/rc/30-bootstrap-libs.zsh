# bootstrap libs
for rc_file in $ZDOTDIR/rc/libs/[0-9][0-9]*; do
  [[ -f $rc_file ]] && source "$rc_file"
done
