# docker-smw-lablsk
Build a Semantic MediaWiki docker image (on top of docker-openresearch-stack) for LabLSK projects.

## Local test with the ELN adapter

The local stack (`docker-compose.yml`) includes the [ELN SMW adapter](https://github.com/TIBHannover/eln-smw-adapter)
service and enables the `ELNSMWAdapterUI` extension for local testing. The extension is installed in the image but not
loaded by default; `eln/LocalSettings.Runtime.php` loads and configures it for this setup only.

```shell
make down build up
make eln-sandbox
```

`make eln-sandbox` creates two sandbox accounts in the local test wiki: the bot `ElnBot` (bot password `ElnBot@adapter`,
used by the service) and the user `ElnTester` (log in with it to use `Special:ELNSMWAdapterUI`). The passwords are
throwaway values for the local wiki, see the `Makefile` and `docker-compose.yml`. Never use them, or put real
credentials into this repository, for anything else.

What the setup contains:

- The service runs with the `Excel-local` upload plugin. Uploaded files are stored by the wiki in a volume shared with
  the service.
- Apache in the wiki container forwards `/eln-smw-adapter/job/` to the service, because the browser polls the job status
  under the wiki's own host (`$wgELNSMWAdapterUIJobStatusPath`).
- The login throttle is disabled: the service logs in on every request, and a wrong bot password would otherwise lock it
  out for up to an hour.

To check the service, open `Special:ELNSMWAdapterUI`, upload a spreadsheet and look at the service logs:

```shell
docker compose logs eln-smw-adapter                                    # requests
docker compose exec eln-smw-adapter tail -f /app/log/$(date +%F).log   # import log
```
