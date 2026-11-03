# homebrew-external

[![Actively Maintained](https://img.shields.io/badge/Pantheon-Actively_Maintained-yellow?logo=pantheon&color=FFDC28)](https://pantheon.io/docs/oss-support-levels#actively-maintained-support)

The Homebrew tap for [Terminus](https://github.com/pantheon-systems/terminus), Pantheon's CLI. It holds a single formula, `Formula/terminus.rb`, which points at a Terminus release's `terminus.phar` by `url` and `sha256`. It lives in its own repo only because Homebrew requires taps to be named `homebrew-*`. Releasing Terminus is described in the Terminus repo's [DEPLOYMENT.md](https://github.com/pantheon-systems/terminus/blob/4.x/DEPLOYMENT.md).

```bash
brew install pantheon-systems/external/terminus
```

## Rollback

A merge to `main` is the deploy. `brew update` reads the tap's `main` directly, and nothing else runs, so the next `brew upgrade terminus` installs whatever the formula points at.

### When to roll back

- The Terminus release the formula points at has been pulled back (marked as a pre-release), per the Terminus [rollback steps](https://github.com/pantheon-systems/terminus/blob/4.x/README.md#rollback).
- `brew install` or `brew upgrade terminus` fails, e.g. a checksum mismatch, or the formula's `test do` block (`terminus art`) fails.
- Reports in `#ask-hosting` or from Support that the Homebrew-installed Terminus is broken and the previous version works.

### Roll back the formula

1. Open a PR that reverts the formula bump: `git revert <BAD_COMMIT>` on a branch, or set `url` and `sha256` in `Formula/terminus.rb` back to `<PREVIOUS_VERSION>`. The hash of that version's asset is in the file's history, or run:
   ```bash
   curl -sL https://github.com/pantheon-systems/terminus/releases/download/<PREVIOUS_VERSION>/terminus.phar | shasum -a 256
   ```
2. CI runs `brew style` and `brew audit --strict` on the PR. A Developer Experience member other than the author approves it, and it merges through the merge queue.

### What a rollback does not undo

Users who already upgraded keep the bad version until they run `brew update && brew reinstall terminus`. To pull the release back from `terminus self:update` and Composer as well, follow the [Terminus rollback](https://github.com/pantheon-systems/terminus/blob/4.x/README.md#rollback).

### Verify the rollback

- `Formula/terminus.rb` on `main` has the `url` and `sha256` of `<PREVIOUS_VERSION>`.
- After `brew update && brew reinstall terminus`, `terminus --version` prints `Terminus <PREVIOUS_VERSION>`, and the reported symptom is gone.

### Who to page

The owning team is Developer Experience (`@pantheon-systems/developer-experience`). Ask in `#ask-hosting`. Nobody is paged for this tap.

## Releasing

See [RELEASING.md](RELEASING.md).
