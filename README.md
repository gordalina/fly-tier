# Tier on Fly.io

This repository provisions tier on fly.io as a private service

## Setup

Create an app out of this template.

```sh
flyctl launch --no-deploy
```

Then we set the stripe api key secret, and deploy it

```sh
flyctl secrets set STRIPE_API_KEY=sk_live_...
```

## Usage

The app is now available internally at `http://<app>.internal/`.
