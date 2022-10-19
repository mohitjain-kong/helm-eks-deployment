# Environment scripts

The scripts here will populate environment variables which are used by the creation and load generator scripts through settings for PROXY_PORT and/or ADMIN_PORT

You must always also execute the `shared.sh` script too

They also will output all hosts and ports as well as providing the typical Kong settings (like Portal URL and similar) for copy & pasting

Note: start the scripts with a prefixed . - for example 

```
. ./docker-compose.sh
. ./shared.sh
```

Otherwise the environment variables may only be shown but not set in your shell environment.

