# Authentication Milter Docker
Docker container that uses [fastmail / authentication_milter](https://github.com/fastmail/authentication_milter) for SPF, SenderID, DKIM and DMARC authentication. It can save result data to an SQLite database and send daily RFC compliant aggregate reports using its own SMTP integration or through a smarthost.

## Database
If a database cannot be found, it is automatically created (data/dmarc_reports.sqlite).

## Installation
```bash
git clone https://github.com/freddieleeman/authmilter_docker.git
cd authmilter_docker
docker build -t freddieleeman/authmilter_docker .
```
## Data/ folder
The `data/` folder contains the configuration files for both Mail::DMARC and Mail::Milter::Authentication. This folder is attached as a shared volume to the docker container. This folder is also used for storing the SQLite database and log file. It can also be used to share a private key for DKIM signing the aggregate report emails (see mail-dmarc.ini).

## Configuration
data/mail-dmarc.ini = [Mail::DMARC](https://github.com/msimerson/mail-dmarc) configuration file

data/authentication_milter.json = [Mail::Milter::Authentication](https://github.com/fastmail/authentication_milter) configuration file

## Logging
Set 'logtoerr' to 1 in the authentication_milter.json configuration file. The log file authentication_milter.err is saved to the shared volume (docker: /config, host: ./data)

## Start container (in restart modus)
Replace `/path/to/data` in the command below with the location of the data folder containing the configuration files.
```
docker run -d \
  -v /path/to/data:/config:rw \
  -p 12345:12345 \
  --name authmilter_docker \
  --restart unless-stopped \
  freddieleeman/authmilter_docker
```

## Add to Postfix configuration
add `inet:localhost:12345` to `smtpd_milters =` in the Postfix main.cf configuration file

## Example crontab
To enable daily (at 4am) sending of aggregate reports add a crontab to the host with the following command:

`0 4 * * * docker exec authmilter_docker sh -c "dmarc_send_reports"`

Use `"dmarc_send_reports --verbose"` for more verbose output.

## View reports in database
`docker exec authmilter_docker sh -c "dmarc_view_reports"`
