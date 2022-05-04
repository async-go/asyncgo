# README

AsyncGo: More mindful collaboration

AsyncGo helps your team improve how you work, no meetings necessary.
Simply raise a tension, have a discussion, and make a change.

[User Documentation](./docs/index.md)

## Requirements

- ruby 3.1.0 (see `.ruby-version`)
  - bundler 2.1.4
- yarn 1.22.10
- chrome (for headless rspec tests)

## Set up the development database

1. Install PostgreSQL 13
1. Create a passwordless postgresql superuser with a username that matches your
   system user (if it doesn't exist already)

## Start the development server

1. Run `bundle install`
1. Run `bin/yarn install`
1. Run `bin/rails db:create`
1. Run `bin/rails db:migrate` (you can also use `bin/rails db:seed` if you want
   sample data loaded.)
1. Run `bin/rails server`

## Configuring auth

The Client ID and Secret should be used instead of `[REDACTED]`. Please don't
save the Client ID or Client Secret anywhere online or locally other than in the
`.env` file.

Client IDs and secrets are set up in the developer tooling for each service.

### Google

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Go to "APIs & Services" -> "Credentials"
3. Copy or create the Client ID and Client Secret
4. Open the `.env` file in the root of your local copy of the project
5. Enter the Client ID as the `GOOGLE_CLIENT_ID`
6. Enter the Client Secret as the `GOOGLE_CLIENT_SECRET`

Here's what a `.env` file looks like

```bash
GOOGLE_CLIENT_ID=[REDACTED]
GOOGLE_CLIENT_SECRET=[REDACTED]
```

### GitHub

1. Go to
   [GitHub Application](https://github.com/organizations/async-go/settings/applications)
2. Copy or create a Client ID
3. Obtain the Client Secret
4. Open the `.env` file in the root of your local copy of the project
5. Enter the Client ID as the `GITHUB_CLIENT_ID`
6. Enter the Client Secret as the `GITHUB_CLIENT_SECRET`

Here's what a `.env` file looks like

```bash
GITHUB_CLIENT_ID=[REDACTED]
GITHUB_CLIENT_SECRET=[REDACTED]
```

## Rake tasks

- `rake send_digest_emails` emails a list of unread notifications to every user

## Blazer authentication

Blazer uses hard-coded user authentication. It checks if the user email ends
with `@asyncgo.com`, but you can change this to meet your needs.

## Container builds

Dockerfiles are in the root of this repo. If you update the versions, update the
versions in the container label.

If you are using an M1 Mac you need to
[build for Linux](https://blog.jaimyn.dev/how-to-build-multi-architecture-docker-images-on-an-m1-mac/)

```bash
docker buildx build --platform linux/amd64 --push -t\
j4yav/ruby-yarn:3.1.0-1.22.18-1 . -f Dockerfile
```

```bash
docker buildx build --platform linux/amd64 --push -t\
j4yav/ruby-yarn-chromium:3.1.0-1.22.18-1-99.0.4844.51-1 . -f Dockerfile.system
```
