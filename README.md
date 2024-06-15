# Docker SSH Tunnel

This is a Docker image used by Disco to create an ad hoc SSH tunnel when the
user needs to access services that are not exposed.

As it is, it's just Alpine with OpenSSH installed.

It's configured when it's needed.

The goal of the image is just to speed up the parts that could be slow or unreliable otherwise.

## Build and push

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64/v8 \
  --tag letsdiscodev/sshtunnel \
  --push \
  .
```

## Usage

This is used internally by Disco, but the concept looks like this.

It creates a temporary container from the image, connected to the Docker network, and publishing a port for SSH, but with a random port instead of `2222`, and a random password instead of `Password1`.
```bash
docker run -it --network disco-main --publish 2222:22 --env PASSWORD=Password1 letsdiscodev/sshtunnel
```

Then the CLI can create an SSH tunnel to, for example, Postgres, with the equivalent of this command:

```bash
ssh -L 5432:postgres-instance-pallid-knot-postgres:5432 root@disco.example.com -p 2222
```

And that's it. Postgres is now accessible from `localhost` while the tunnel is connected.

For example,
```bash
disco env:get DATABASE_URL --project my-project --disco disco.example.com
```
outputs
```
postgresql://so72kvhxban57ro9:OYOJ7AbYrUvamTbc@postgres-instance-pallid-knot-postgres/twsoh0a61sc3xfve
```
so you can connect to this database by replacing `postgres-instance-pallid-knot-postgres` with `localhost`

```bash
pgcli postgresql://so72kvhxban57ro9:OYOJ7AbYrUvamTbc@localhost/twsoh0a61sc3xfve
```
