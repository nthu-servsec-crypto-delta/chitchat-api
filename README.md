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
* GET `api/v1/events/`: Get a list of events
* POST `api/v1/events/`: Create a new event
* PUT `api/v1/events/[event_id]/applicant`: Apply for an event
* DELETE `api/v1/events/[event_id]/applicant`: Cancel the application for the event
* PUT `api/v1/events/[event_id]/participant`: Make an applicant an participant
* DELETE `api/v1/events/[event_id]/participant`: Remove participant
* PUT `api/v1/events/[event_id]/co_organizer`: Add co-organizer
* DELETE `api/v1/events/[event_id]/co_organizer`: Remove co-organizer
* GET `api/v1/events/[event_id]/accounts`: All the accounts that is in an event

### Accounts Routes

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