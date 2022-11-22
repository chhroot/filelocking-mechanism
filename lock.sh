# Values required

action="lock"
nullcmd="/bin/true"
retries="10"
 
#l - lock , u- unlock, retries-current optrang value(10)
 
while getopts "lur:" opt; do
 case $opt in
   l ) action="lock"      ;;
   u ) action="unlock"    ;;
   r ) retries="$OPTARG"  ;;
 esac
done
shift $(($OPTIND - 1))

if [ $# -eq 0 ] ; then
 cat << EOF >&2
$0 [-l|-u] [-r ] nameofthefile
EOF
 exit 1
fi

# Checks whether filelock is available in path

if [ -z "$(which lockfile | grep -v '^no ')" ] ; then
 echo "FILE LOCK NOT FOUND"
 exit 1
fi
if [ "$action" = "lock" ] ; then
 if ! lockfile -1 -r $retries "$1" 2> /dev/null;
   then echo "FILE LOCK COULDN'T CONNECT"
   exit 1
 fi
else    # action = unlock
 if [ ! -f "$1" ] ; then
   echo "NOTHING TO UNLOCK"
   exit 1
 fi
 rm -f "$1"
fi
exit 0