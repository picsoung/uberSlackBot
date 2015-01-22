# Uber Slack Bot

Get Uber price estimates directly in Slack.

# How-to
Command to post in a Slack channel

`uber price start=ADDRESS OF START POINT end=ADDRESS OF END POINT`

### examples
`uber price start=ATT park, san francisco end=dolores park, san francisco`

result:

![Screenshot Uber estime ATT Park to Dolores](http://i.imgur.com/kFbvEk8.png?1)

Failed request `uber price Heaven to Hell`

![Screenshot failed request](https://i.imgur.com/SRYaBRW.png)

Request in a city that does not have Uber availble

![Screenshot not available](https://i.imgur.com/8lxkiia.png)

## Installation guide

### Pre-requisite
  - Uber API account, [create one](https://developer.uber.com/)
  - Google Maps API account, [create one](https://console.developers.google.com/)
  - Slack organization, [create one](https://slack.com/)
  - APItools account, [create one](https://apitools.com)
  - Time :)

  
### Slack part
#### 1. Create outgoing webhook
Outgoing webhook is used to "listen" what's happening on channels.
To create a new one go on `https://YOUR_ORG.slack.com/services/new`

On the next page you will select on which channel of your organization you want to bot to be active. And the triggered words. Triggered words are the words that will make the bot react. In our case *breez*.

At the bottom of the page you can give a cute name to your bot as well as an avatar.
We will come back later to this page to fill the other fields.

#### 2. Create incoming webhook
Incoming webhook is used to send data to channels.
Again we go on `https://YOUR_ORG.slack.com/services/new`
And create an `incoming webhook`.

Define on which channel you want to post, change the name of the bot and it's icon. All these could be overide later.

Keep the `Webhook URL` somewhere we will need it later to send a `POST` request and send data to slack.

### APItools
Using APItools is a great way to avoid maintaining servers for something as simple as webhooks. It's also free to use.

#### Google API
Create a new service with the *API URL* `https://maps.googleapis.com/maps/api/`
This service will be used to make all the requests to Google Maps API.

We don't have any middleware code for this service.

#### Uber API
Create a new service with the *API URL* `https://api.uber.com/v1/`
This service will be used to make all the requests to Uber API.

We now are going to add two middlewares. First one will be used to convert street names to latitude longitude coordinates using service previously created.
Code for this middleware could be found in `uber_getLatLngFromGoogle.lua` file.

In this file change:

- `GOOGLE_API_KEY` by your own Google API key
- `APITOOLS_GOOGLE_SERVICEURL` by the APItools service URL for the Google Maps API.
- `UBER_TOKEN` by your Uber Token

Then add the second middleware that will send the message to slack. Code could be found in `uber_slackNotification.lua` file.

In the code change `SLACK_INCOMING_URL` to your slack incoming webhook URL created before

Your pipeline should look like this:

![APItools pipeline](https://i.imgur.com/IY8uiZK.png)

#### Handling webhook
Anytime our triggered word is used in a channel, slack will make a request to an URL. We want to URL to be an API service. This service will handle the outgoing webhook request from slack.

Use the echo-api as *API URL* `https://echo-api.herokuapp.com`

Copy *APItool URL* that should look like `https://SOMETHING.my.apitools.com/`.
Go back to the *Outgoing webhook* config page you previsouly created. Pasted the APItools URL in the *URLs* field.

![Add APItools URL to outgoing webhook](https://i.imgur.com/QCL5rHP.png)

On APItools, on your newly created service, go in the pipeline and paste the code found in the file `echo_hookmanagement.lua` of this repo.

In this snippet change placeholders:

- `SLACK_INCOMING_HOOK_URL` by the Incoming Webhook URL you created in Slack.
- `APITOOLS_UBER_SERVICE_URL` by APItools service URL for Uber API.
