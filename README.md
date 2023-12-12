# Tier on Fly.io

This repository provisions tier on fly.io as a private service

## Setup

Create an app out of this template.

```sh
fly launch --no-deploy
```

Then we set the Stripe API key secret.

```sh
fly secrets set STRIPE_API_KEY=sk_live_...
```

Then we deploy it.

```sh
fly deploy
```

The app is now available internally at `http://<app>.internal/`.

## Enable public-facing access

First you have to allocate an IP address.

```sh
fly ips allocate-v4
fly ips allocate-v6
```

Then uncomment the `[http_service]` sections in `fly.toml` and redeploy.

```sh
fly deploy
```

## Test environment

If you want to use a test key, you'll have to remove the `--live` argument from the ENTRYPOINT command in the Dockerfile.
