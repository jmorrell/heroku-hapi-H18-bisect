# Run `heroku create` and add the app name here
HEROKU_APP_NAME=warm-earth-42482


HEROKU_APP_URL=https://git.heroku.com/$HEROKU_APP_NAME.git

KNOWN_GOOD_COMMIT=10451d2ca10cb5681cc3bc38100e5bd0091b39b1
KNOWN_BAD_COMMIT=0c8109e1b573528bfebea771da6a83d1f5bf7043

BASE_DIR=$(pwd)
TMP_DIR=$BASE_DIR/bisect-tmp

# Create our temp directory where we will create one-off apps
mkdir $TMP_DIR

# Make sure this app installs fresh node modules each time
heroku config:set NODE_MODULES_CACHE=false --app $HEROKU_APP_NAME

# Get Hapi
git clone https://github.com/hapijs/hapi.git
cd hapi

# Kick things off
git bisect start $KNOWN_BAD_COMMIT $KNOWN_GOOD_COMMIT
git bisect run $BASE_DIR/hapi-bisect-script.sh

# clean up
rm -rf bisect-tmp hapi

