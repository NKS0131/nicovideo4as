nicovideo4as (DMC support custom)
=================================

This is an ActionScript library for accessing nicovideo.jp API, maintained only for **[NNDD-5ch][]**.

**NOT ACTIVELY MAINTAINED.**

## Important: API Updates

Niconico's APIs have been updated. Please see [API_UPDATES.md](API_UPDATES.md) for details on:
- Deprecated APIs (getflv, getwaybackkey, getbgm)
- Migration guide to new API format
- Current API endpoints and usage

## Key Changes

- **flapi.nicovideo.jp** endpoints are deprecated
- Use `WatchVideoPage` + `WatchDataAnalyzer` for video information
- Supports both old and new JSON data formats
- Updated User-Agent to latest Chrome version


Authors
-------

### Original Author
* **MineAP** - the original author ([LICENSE0][]) - https://ja.osdn.net/projects/nndd/
* **SSW-SCIENTIFIC** - NNDD+DMC ([LICENSE1][]) - https://github.com/SSW-SCIENTIFIC/NNDD


License
-------
This software is distributed under [MIT License][].

[NNDD-5ch]:https://github.com/nndd-reboot/NNDD
[LICENSE0]:https://github.com/SSW-SCIENTIFIC/nicovideo4as/blob/master/LICENSE0
[LICENSE1]:https://github.com/SSW-SCIENTIFIC/nicovideo4as/blob/master/LICENSE1
[MIT License]:https://github.com/SSW-SCIENTIFIC/nicovideo4as/blob/master/LICENSE
