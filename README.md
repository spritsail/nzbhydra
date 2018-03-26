[hub]: https://hub.docker.com/r/spritsail/nzbhydra
[git]: https://github.com/spritsail/nzbhydra
[drone]: https://drone.spritsail.io/spritsail/nzbhydra
[mbdg]: https://microbadger.com/images/spritsail/nzbhydra

# [Spritsail/NZBHydra][hub]
[![Layers](https://images.microbadger.com/badges/image/spritsail/nzbhydra.svg)][mbdg]
[![Latest Version](https://images.microbadger.com/badges/version/spritsail/nzbhydra.svg)][hub]
[![Git Commit](https://images.microbadger.com/badges/commit/spritsail/nzbhydra.svg)][git]
[![Docker Stars](https://img.shields.io/docker/stars/spritsail/nzbhydra.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/spritsail/nzbhydra.svg)][hub]
[![Build Status](https://drone.spritsail.io/api/badges/spritsail/nzbhydra/status.svg)][drone]

NZBHydra 2 is a meta search for NZB indexers. It provides easy access to a number of raw and newznab based indexers. You can search all your indexers from one place and use it as indexer source for tools like Sonarr or CouchPotato.
This image uses a user with UID 907. Make sure this user has write access to the `/config` folder.

## Example Run Command

```bash
docker run -d --restart=on-error:10 --name nzbhydra -v /host/path/to/config:/config -p 5076:5076 spritsail/nzbhydra
```
