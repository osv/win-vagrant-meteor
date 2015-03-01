#!/bin/bash
# ------------------------------------------------------------------
# inspired https://gist.github.com/gabrielhpugliese/5855677
#
# Meteor-Vagrant-Win Environment.
# After meteor create app script to move .meteor/local dir to VM FS.
#
# The idea is to move the .meteor/local folder out of the shared directory and link it back in.
# MongoDB cannot run in the shared folder because of permission problems.
# Create all apps in the ~/shared folder to make their code available to the Windows host.
#
# Install: 1) Put it in the ~/shared dir.
# 2) run: chmod +x new-project.bash
# ------------------------------------------------------------------
VERSION=0.1.0

MOUNTFILE="./mountall.sh"

if [ -z $1 ]; then
    echo "Usage: $0 app_name"
    exit
fi

APP=$1
APP=${1%/}                      # remove "/" if exist
STARTSCRIPT="$APP/start.sh"
MOCKDIR="/home/vagrant/mockmeteor"

# purge old
if [ -d $MOCKDIR/$APP ]; then
    echo "=> Remove old meteor/local ($MOCKDIR/$APP)"
    rm -rf "$MOCKDIR/$APP"
fi
mkdir -p "$MOCKDIR/$APP"

# move local
if [ -d "$APP/.meteor/local" ]; then
    echo "=> Moving current $APP/.meteor/local => $MOCKDIR/$APP"
    mv "$APP/.meteor/local" "$MOCKDIR/$APP/local"
else
    mkdir -p "$MOCKDIR/$APP/local"
fi

# touch local dir
if [ ! -d "$APP/.meteor/local" ]; then
    mkdir "$APP/.meteor/local"
fi
 
# Add mount to the all-apps mount shell script.
echo "=> Add mount to $MOUNTFILE script"
cat <<EOF>> $MOUNTFILE

# $1 internal meteor directory mount 
sudo mount --bind $MOCKDIR/$APP/local ~/shared/$APP/.meteor/local
EOF

chmod +x $MOUNTFILE

echo "=> Create start script $STARTSCRIPT"

# Create a meteor-start shell script that performs individual mount and runs meteor.

cat <<EOF> $STARTSCRIPT
#!/bin/sh
echo "Start $1"
sudo mount --bind $MOCKDIR/$APP/local ~/shared/$APP/.meteor/local
meteor
EOF

chmod +x $STARTSCRIPT
 
cat & cat <<EOF

---8<------------------8<------------------8<----

Now you can mount all dir:

$MOUNTFILE

and them

cd $APP
meteor

or mount only $APP:

cd $APP
./start.sh
---8<------------------8<------------------8<----
EOF
