SCRIPTSDIR="$(cd "$(dirname "$0")"; pwd -P)"
LOKIDIR="$SCRIPTSDIR/.."

ls -f1A $LOKIDIR/current | xargs -L 1 -I % cp -rn $LOKIDIR/current/% $LOKIDIR/reference/%