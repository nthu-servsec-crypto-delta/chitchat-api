# chitchat-api
This is the ChitChat API.

## Routes

* GET `/`: Root route shows if Web API is running

### Postit Routes

* GET `api/v1/postits/[postit_id]`: Get a postit
* POST `api/v1/postits/[postit_id]`: Create a new postit
* GET `api/v1/postits/`: Get a list of postits

### Event Routes

* GET `api/v1/events/[event_id]`: Get an event
* POST `api/v1/events/[event_id]`: Create a new event
* GET `api/v1/events/`: Get a list of events

## TODO Routes

* GET `api/v1/accounts/[username]`: Get account details
* POST `api/v1/accounts`: Create a new account

## Install
Install required gems through `bundle`.  

```bash
bundle install
```

## Setup
Create a `secrets.yml` file in the config folder, see example at `config/secrets.example.yml`

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