# homebrew-external

[![Actively Maintained](https://img.shields.io/badge/Pantheon-Actively_Maintained-yellow?logo=pantheon&color=FFDC28)](https://pantheon.io/docs/oss-support-levels#actively-maintained-support)

The Homebrew tap for [Terminus](https://github.com/pantheon-systems/terminus), Pantheon's CLI. It holds a single formula, `Formula/terminus.rb`, which points at a Terminus release's `terminus.phar` by `url` and `sha256`. It lives in its own repo only because Homebrew requires taps to be named `homebrew-*`. Releasing Terminus is described in the Terminus repo's [DEPLOYMENT.md](https://github.com/pantheon-systems/terminus/blob/4.x/DEPLOYMENT.md).

```bash
brew install pantheon-systems/external/terminus
```

## Rollback

A merge to `main` is the deploy: `brew update` reads the tap's `main` directly, and nothing else runs. The full procedure is in [DEPLOYMENT.md](DEPLOYMENT.md#rollback).

- **When:** the Terminus release the formula points at was pulled back, `brew install` / `brew upgrade terminus` fails (e.g. a checksum mismatch), or the Homebrew-installed Terminus is reported broken while the previous version works.
- **Recover:** open a PR that reverts the formula bump (or sets `url` and `sha256` in `Formula/terminus.rb` back to the previous version); another Developer Experience member approves, and it merges through the merge queue. Users who already upgraded need `brew update && brew reinstall terminus`.
- **Verify:** `Formula/terminus.rb` on `main` has the previous version's `url` and `sha256`, its hash matches the release asset, and `terminus --version` prints that version after a reinstall.
- **Who to page:** nobody is paged. The owner is Developer Experience (`@pantheon-systems/developer-experience`); ask in `#ask-hosting`.

## Releasing

See [DEPLOYMENT.md](DEPLOYMENT.md#how-a-change-reaches-production).
