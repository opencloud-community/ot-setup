# OpenTalk deployment (lite)

[[_TOC_]]

This guide will take you through a quick installation to run a simple OpenTalk installation for a **small** setup on your own server. Be sure, that your network, firewall, domain names and certificates are configured properly before you start the OpenTalk services.

For more information, please also refer our [documentation pages](https://https://docs.opentalk.eu).

To stay informed about the latest releases, please visit our [Releases page](https://docs.opentalk.eu/releases/). There, you'll find detailed information on new features, bug fixes, and version changes.

## Prepare your deployment environment

To run an OpenTalk instance, we assume that a certain infrastructure configuration already exists.
Please ensure, that the following resources are prepared.

### Note for existing installations

Starting with product version 1.4, the directory structure has changed. The 'lite' directory is no longer used. If necessary, move persistent data from `./lite/data/*` to `./data/`

### Server

We recommend a virtual machine with a minimum configuration of:

- CPU: 2 Cores
- RAM: 4GB
- HDD: 20GB
- 1 public network interface
- 1 private network interface

Installed with a Linux distribution of your choice.

### Services

To run OpenTalk with this deployment method, you need to have the `docker engine` and the plugin `compose` to be installed.
Please refer to the official documentation for **[docker engine](https://docs.docker.com/engine/install)** and the **[docker compose plugin](https://docs.docker.com/compose/install/linux)**.

We define the running application stack via a `docker-compose.yaml` file and we use the feature **[profiles](https://docs.docker.com/compose/profiles/)** to handle different deployment scenarios.

In the current state, the configuration that is ready to use out-of-the-box, covers the services tagged with the profile `core`.

| Service      | core      |
|--------------|-----------|
| Keycloak     | X         |
| postgresql   | X         |
| autoheal     | X         |
| rabbitmq     | X         |
| redis        | X         |
| web-frontend | X         |
| controller   | X         |
| minio        | X         |
| janus-gateway| X         |
| obelisk      |           |
| smtp-mailer  |           |
| spacedeck    |           |
| etherpad     |           |
| recorder     |           |

Of course, you can **extend** the OpenTalk lite setup to run all services available in the `docker-compose.yaml` file. However, this requires further configuration steps that are not part of this quick install guide. We will provide instructions for an extended setup later.

### open Firewall ports

Ensure, that the ports `80/tcp`, `443/tcp` and `20000-40000/udp` are opened in your firewall and accessible from public.

### DNS records

OpenTalk consists of several services. To make them work together, some services need a specific DNS record.
If your domain is for example `example.com`, you have to create the following DNS records and point them to your public IP-address.

- example.com (OpenTalk Web-UI)
- accounts.example.com (Keycloak instance)
- controller.example.com (OpenTalk controller service)

### Reverse-Proxy and SSL certificates

Get valid SSL certificates for your DNS records at the certificate authority of your choice. We recommend using [letsencrypt](https://letsencrypt.org/) in combination with [certbot](https://certbot.eff.org/) for this purpose.

Set up a reverse proxy that terminates the SSL connections and forward the requests to the appropriate OpenTalk upstream services.
When you use the default ports, the services listen on the following ports on the local interface:

- frontend:    localhost:8080
- controller:  localhost:8090
- keycloak:    localhost:8087

We recommend using nginx as reverse-proxy. Please refer the [official nginx documentation](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/) for further information.

As an inspiration, we provide configuration examples in the directory `./extras/nginx-samples`. Customize it to your needs.

## Setup OpenTalk services

### Clone the `ot-setup` repository

Clone the git repository to a location of your choice. Since we are using directory based docker volumes in this deployment guide, make sure there is enough storage on that location. We recommend using `/opt/opentalk` for this.

Specify a release tag when you clone the git repository. Pick the current stable version from our [release page](https://docs.opentalk.eu/releases).

```bash
git clone --branch v24.10.0 https://gitlab.opencode.de/opentalk/ot-setup.git /opt/opentalk
```

Change to the root of this repository, and use it as base directory for the next steps.

```bash
cd /opt/opentalk
```

### Prepare `docker compose` configuration

Create a `.env` file from the provided `.env.sample`. The `.env` file is used to configure the OpenTalk services deployed by `docker compose`.

```bash
cp env.sample .env
```

### Prepare the controller configuration

Create the controller configuration from the sample file `controller.toml.sample` located in `config/` directory.

```bash
cp extras/opentalk-samples/controller.toml.sample config/controller.toml
```

#### Edit the `.env` file settings

Customize the variables in `.env` according to your needs. In most cases, it is sufficient to adjust the values listed under `common variables`. You should always leave the `docker-compose.yaml` file unchanged to have an easier update process in future.

You absolutely *have to* set `OT_DOMAIN` yourself to a domain you or your organization control.

You can generate the secrets with the `gen-secrets.sh` helper script and simply copy + paste the secrets into the `.env` file.

- Using the helper script is optional, you can also set the secrets manually.
- Note: The script needs to have the package pwgen installed!

```bash
bash extras/gen-secrets.sh
```

It produces an output that you can use to replace the header area in the `.env` file.

**Sample output:**

```bash
POSTGRES_PASSWORD=eeDowieghaiph6cootheitheethaJoob
KEYCLOAK_ADMIN_PASSWORD=aepooghedeshe6eepo1ohth8aeGhu6La
KEYCLOAK_CLIENT_SECRET_CONTROLLER=Cuipheich3imooch8si6uhie6Saph8so
KEYCLOAK_CLIENT_SECRET_OBELISK=Aiyo5ooceilee6einguk6Egheiquaiph
KEYCLOAK_CLIENT_SECRET_RECORDER=itoo2pieyohh6Aighiebietee7iefae7
SPACEDECK_API_TOKEN=ohP2AeBirineimohS6Pha1oaphoapoM2
SPACEDECK_INVITE_CODE=eij9weipaxohYiexoh1loo5zae8ic2ah
ETHERPAD_API_KEY=iethae9aulo0ung6Tida6uquahmahphi
```

#### Add the secretes to the `config/controller.toml`

Add your or the generated secrets to `config/controller.toml` stored in the `.env` file.
Use the following sed snippets or as an alternative you can also edit the `config/controller.toml` manually.

```bash
source .env; sed -i "s/postgrespw/$POSTGRES_PASSWORD/g" config/controller.toml 
source .env; sed -i "s/keycloakclientsecretforcontroller/$KEYCLOAK_CLIENT_SECRET_CONTROLLER/g" config/controller.toml 
source .env; sed -i "s/spacedeckapitoken/$SPACEDECK_API_TOKEN/g" config/controller.toml 
source .env; sed -i "s/etherpadapikey/$ETHERPAD_API_KEY/g" config/controller.toml 
```

#### Final adjustments to the `config/controller.toml`

Open the `config/controller.toml` with your favorite editor.

```bash
vi config/controller.toml
```

Change the following values to fit your needs:

```txt
[http]
cors.allowed_origin = ["https://example.org"]

[keycloak]
base_url = "https://accounts.example.org/auth"
```

#### Optional: Advanced configuration method using environment variables

It is also possible to set configuration options using environment variables. In this case, the environment variables take precedence over the settings defined in the `*.toml` configuration files. The `docker-compose.yaml` and `.env` files contain predefined variables with common defaults. It is best practice to use the `.env` file to overwrite the default values and keep the `docker-compose.yaml` file untouched if possible. Please refer to the official [Docker Compose documentation](https://docs.docker.com/compose/environment-variables/set-environment-variables/) for further information about using environment variables in the `docker-compose.yaml` file. The available environment variables and limitations are described in the configuration section in the [admin documentation](https://docs.opentalk.eu/admin/) for each OpenTalk service.

### Run the OpenTalk stack

```bash
docker compose up -d
```

## Post installation tasks

After your configuration has been finished and the services are up and running, you probably want to create users to login into your new OpenTalk installation. We use Keycloak for the user management. You can find documentation about user management in Keycloak in the official [Keycloak administration](https://www.keycloak.org/docs/latest/server_admin/#assembly-managing-users_server_administration_guide) guide.

### Log in to Keycloak web interface and create users for OpenTalk

By default, the Keycloak web interface for OpenTalk is available at e.g. `https://accounts.example.com/auth`.
Use the credentials `admin` and the password, that you have defined with `KEYCLOAK_ADMIN_PASSWORD` the `.env` file.

After login to Keycloak administration, switch to the **realm** `opentalk` and create a new user with the default role `default-roles-opentalk`. As reference you can refer the `testuser` provided for demo purposes. You can also `enable` the testuser and reset the password for testing OpenTalk.

### Log in to your OpenTalk instance

If you have successfully created an OpenTalk user, you can now use it to log in to your new OpenTalk installation.
By default, the OpenTalk web interface is available at the root of your domain e.g. `https://example.com`.
