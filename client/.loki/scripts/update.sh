SCRIPTSDIR="$(cd "$(dirname "$0")"; pwd -P)"
LOKIDIR="$SCRIPTSDIR/.."

ls -f1A $LOKIDIR/difference | xargs -I % cp -rf $LOKIDIR/current/% $LOKIDIR/reference/%
