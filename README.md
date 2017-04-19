# Hapi Bisect Script

## To Run:

Make sure you have the `heroku` toolbelt installed: https://devcenter.heroku.com/articles/heroku-cli

Log in to your Heroku account:

```
> heroku login
Enter your Heroku credentials.
Email: adam@example.com
Password (typing will be hidden):
Authentication successful.
```

Check out this repository:

```
https://github.com/jmorrell/heroku-hapi-H18-bisect.git
cd heroku-hapi-H18-bisect
```

Create a Heroku app and update the `HEROKU_APP_NAME` variable in `bisect-script.sh`

```
❯ heroku create      
Creating app... done, ⬢ murmuring-eyrie-93839
https://murmuring-eyrie-93839.herokuapp.com/ | https://git.heroku.com/murmuring-eyrie-93839.git
```

```
HEROKU_APP_NAME=murmuring-eyrie-93839
```

Start the bisect script

```
sh ./bisect-script.sh
```

Output:

```
98d34046392006540b64a799b6ca58150d08df2c is the first bad commit
commit 98d34046392006540b64a799b6ca58150d08df2c
Author: Eran Hammer <eran@hammer.io>
Date:   Mon Oct 26 00:49:23 2015 -0700

    Skip most lifecycle on not found and bad path. Closes #2867

:100755 100755 1cd1680739ce6bf95b76abe496e26534d094beaa 2decb33f2a69bb7d22862c6c5b54fef83c437e21 M      API.md
:040000 040000 87075a6a7a8ab1d85b4b4d259ce14a2b16870dab 481e5da93ba66490cc62ca1fc242d6f153daa701 M      lib
:040000 040000 84db0ba536bb4f4e8290b5c29ce88d7f6ce1c1c7 00ed8d03c69ce0759262669c81c882dc1c20d890 M      test
bisect run success
```

