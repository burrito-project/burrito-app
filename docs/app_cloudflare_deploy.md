# Deploying the app in the web using Cloudflare Pages

Cloudflare Pages deployment is already configured as a GitHub workflow that
is triggered on every push to the `main` branch.

For details see the `.github/workflows/deploy.yml` file.

## Using a custom domain

By default, Cloudflare Pages are deployed to the `*.pages.dev` domain.
To use a custom domain, follow the instructions provided by Cloudflare
in the Pages dashboard.

## Manually building the Web App

Build the app for web with:

```console
flutter build web -t lib/main.dart
```
