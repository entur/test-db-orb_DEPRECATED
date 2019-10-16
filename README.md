# Entur - CircleCI Database Test Orb

> This is a work in progress, not yet available as a pulic release.

This orb is a utility orb for other orbs to easily authenticate with GCP

https://circleci.com/orbs/registry/orb/entur/gcp-auth

## Requirements

An executor that has `gcloud` pre-installed. One is available as `gcp-auth/entur-cci-toolbox`

## Usage

Use the orb like this:

```yaml
version: 2.1

orbs: # This makes the gcp-auth orb available in your config
  gcp-auth: entur/db-test@volatile # Use volatile if you always want the newest version.

TODO
```

Available commands can be found in `src/commands`. Usage examples in `examples` and in `text/install-test.yml`

## Pack and publish orb

Make sure you have the CircleCI CLI:

```bash
curl -fLSs https://circle.ci/cli | bash
```

Pack the contents of src/ to a single orb file:

```bash
circleci config pack ./src > orb.yml
```

Validate that the orb is valid:

```bash
circleci orb validate orb.yml
```

After commit & push to the repository, the orb will be automatically published as part of the workflow in CircleCI.

A dev-orb will be published as: `entur/gcp-auth@dev:YOUR-BRANCH-NAME`. Release orbs are created on push to the master branch.

You can read more here: https://circleci.com/docs/2.0/creating-orbs/
