# README

## Requirements

- ruby 3.0.0 (see `.ruby-version`)
  - bundler 2.1.4
- yarn 1.22.10

## Start the development server

1. Run `bundle install`
1. Run `bin/yarn install`
1. Run `bin/rails db:migrate`
1. Run `bin/rails server`

## Configuring local auth

The Client ID and Secret should be used instead of `[REDACTED]`. Please don't
save the Client ID or Client Secret anywhere online or locally other than in the
`.env` file.

### Google

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Go to "APIs & Services" -> "Credentials"
3. Click on the AsyncGo OAuth client
4. Copy the Client ID and Client Secret
5. Open the `.env` file in the root of your local copy of the project
6. Enter the Client ID as the `GOOGLE_CLIENT_ID`
7. Enter the Client Secret as the `GOOGLE_CLIENT_SECRET`

Here's what a `.env` file looks like

```bash
GOOGLE_CLIENT_ID=[REDACTED]
GOOGLE_CLIENT_SECRET=[REDACTED]
```

You need to be a member of the AsyncGo Google Cloud project to be able to access
this.

### GitHub

1. Go to [GitHub Application](https://github.com/organizations/async-go/settings/applications)
2. Click on the AsyncGo OAuth app
3. Copy the Client ID
4. Obtain the Client Secret
5. Open the `.env` file in the root of your local copy of the project
6. Enter the Client ID as the `GITHUB_CLIENT_ID`
7. Enter the Client Secret as the `GITHUB_CLIENT_SECRET`

Here's what a `.env` file looks like

```bash
GITHUB_CLIENT_ID=[REDACTED]
GITHUB_CLIENT_SECRET=[REDACTED]
```
