# chitchat-api
This is the ChitChat API.

## API Spec
WIP

## Install
Install required gems through `bundle`.  

```bash
bundle install
```

## Test
Run database migrations to setup test database
```
export RACK_ENV=test
rake db:migrate
rake spec
```

## Run
Run migration files to setup development database
```
RACK_ENV=development rake db:migrate
```

Run this API server using `puma` at project root.

```bash
puma
```

Server would listen on http://0.0.0.0:9292.