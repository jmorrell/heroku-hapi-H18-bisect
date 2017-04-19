#!/bin/sh

# Known good: 10451d2ca10cb5681cc3bc38100e5bd0091b39b1
# Known bad: 0c8109e1b573528bfebea771da6a83d1f5bf7043

# git bisect start 0c8109e1b573528bfebea771da6a83d1f5bf7043 10451d2ca10cb5681cc3bc38100e5bd0091b39b1

APP_NAME=hapi

# Copy this directory to a temp directory 
CURRENT_DIR=$(pwd)
TMP_DIR=$CURRENT_DIR/../bisect-tmp
echo $TMP_DIR/$APP_NAME
mkdir $TMP_DIR/$APP_NAME
cp -r . $TMP_DIR/$APP_NAME
cd $TMP_DIR/$APP_NAME

# delete the git repo and start a new one
rm -rf .git
git init

# Generate the files that we need to run on Heroku

# app.js
cat >./app.js <<EOL
const Hapi = require('./lib');
const server = new Hapi.Server();

server.connection({ host: '0.0.0.0', port: process.env.PORT || 8000 })
server.start((err) => {
  if (err) throw err;

  console.log('Server listening .. ');
});
EOL

# Procfile
cat >./Procfile <<EOL
web: node app
EOL

# Add Heroku as a remote
git remote add heroku $HEROKU_APP_URL

# Add the new changes
git add .
git commit -m "init"

# Push to Heroku, ignore that we might be behind the existing HEAD
git push --force heroku master

# Test the app!
touch ./log

# Run 40 curl commands just to be sure in sequence and save off the output
for i in `seq 1 40`;
do
  curl -s -d'a' https://$HEROKU_APP_NAME.herokuapp.com/ | tee -a ./log
done

# If we see this url at any point in the output we know that the commit is bad
if grep -q "www.herokucdn.com/error-pages/application-error.html" ./log; then
  GOOD_COMMIT=false
else
  GOOD_COMMIT=true
fi

# cleanup
cd $CURRENT_DIR
rm -rf $TMP_DIR/$APP_NAME

# exit code
if $GOOD_COMMIT; then
  echo "GOOD COMMIT"
  exit 0
else
  echo "BAD COMMIT"
  exit 1
fi


