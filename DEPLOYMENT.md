---
contract_version: 2
kind: tool                          # a Homebrew tap: a distribution channel for Terminus, not a running service
service: terminus (Homebrew formula pantheon-systems/external/terminus)

trigger: merge-to-main
merged_implies_deployed: true       # nothing builds or publishes: Homebrew clients read the tap's main branch directly (verified 2026-11-10: a local tap clone's HEAD is 5962150, the #91 merge commit, and `brew info` reports 4.3.5)
other_paths_to_prod:
  - "editing the Terminus GitHub release the formula points at (deleting or re-uploading terminus.phar) changes what `brew install` downloads with no change here. A different asset no longer matches the pinned sha256, so installs fail instead of installing something unexpected"
  - "re-running the terminus tag's 'Release' job re-uploads terminus.phar to that release"   # inferred, per the terminus contract; same consequence as above if the bytes differ
  # The repo ruleset lets the developer-experience team bypass the repo-level pull_request rule (github-terraform). The org TL3 ruleset still requires an approval. An agent never uses a bypass.

pipeline:
  system: github-actions
  workflow: ".github/workflows/ci.yml"   # workflow name "CI"; on push (any branch) and pull_request. Validation only: it deploys nothing
  jobs_in_order: [audit]            # steps: brew style, brew audit --strict
  typical_minutes: 1                # observed: PR run ~1 min, merge-queue run 23:53:15Z -> 23:54:22Z, main push run 23:53:52Z -> 23:54:38Z (#91)
  minutes_by_change: {}
  watch: "Actions workflow 'CI' push run on main for the merge commit: `gh run list -R pantheon-systems/homebrew-external --workflow ci.yml --branch main --limit 3`"
  concurrency_group: null           # ci.yml has no concurrency block (verified)
  cancel_in_progress: null
  blocked_by_waiting_run: null      # no gate, no concurrency group
  approval_gate: null               # no GitHub Environments in the repo (verified: 0 environments)
  # What CI does NOT check: `brew audit --strict` without --online never downloads the asset, so a wrong sha256 or a dead url passes CI and merges green (verified: the main run's log downloads only Homebrew API data, never terminus.phar). Check the hash by hand (health below).
  upstream:                         # spec feedback: no field for the job in ANOTHER repo that opens this repo's PRs
    repo: pantheon-systems/terminus
    workflow: ".github/workflows/4.x.yml"
    job: "Package a Homebrew release"   # needs: release; skipped for tags containing '-' (pre-releases)
    contract: "https://github.com/pantheon-systems/terminus/blob/4.x/DEPLOYMENT.md"
    observed: "4.3.5 (run 42671697276): the job took 10 s (23:04:58Z -> 23:05:08Z) and opened #91 at 23:05:05Z"

repo_properties:
  observed_at: 2026-11-10
  trust_level: TL3
  ccb_status: exempt                # flipped after SECREV-65 (filed 2026-11-03 for DEVX-8113)
  owner: developer-experience
  repo_type: tool

gating_checks:
  required: ["Wiz IaC Scanner", "Wiz Vulnerability Scanner", "Wiz Data Scanner"]   # org TL3 ruleset; the repo ruleset adds no required checks
  approvals: {required: 1, code_owner: true, last_push_approval: false, strict_up_to_date: true, merge_queue: true}   # org TL3 + repo ruleset; squash only; signed commits required (org)
  run_but_not_required: ["audit", "CodeQL (Analyze actions, Analyze ruby)", "Wiz SAST Scanner", "Wiz Secret Scanner"]   # CodeQL results are still enforced by the org code_scanning rule (errors / high or higher)
  conditional: []
  code_owners: "* @pantheon-systems/developer-experience (.github/CODEOWNERS is managed by github-terraform)"

environments:
  - {name: homebrew-tap, target: "main of pantheon-systems/homebrew-external, read by every user's `brew update`", gates_prod: null}

artifact:
  image: null                       # nothing is built. The formula pins a Terminus release asset by url + sha256
  formula: "Formula/terminus.rb"
  points_at: "https://github.com/pantheon-systems/terminus/releases/download/<version>/terminus.phar"
  tag_scheme: none                  # the tap has no tags or releases; the version is in the formula's url
  tag_mutable: null                 # n/a. The pointed-at release asset is replaceable by anyone with write on terminus; the sha256 pin turns that into an install failure
  retention: "every formula version stays in git history; Terminus release assets are kept indefinitely"   # inferred for the assets
  version_signal: "formula url on main"
  tag_to_sha: "git log -1 --format=%H -- Formula/terminus.rb on main"

runtime:
  - kind: other
    name: "Homebrew clients: each user's local git clone of this tap"
    picked_up_by: "`brew update`, which also runs automatically before `brew install` / `brew upgrade` (at most once per HOMEBREW_AUTO_UPDATE_SECS, default 24 h)"   # inferred: Homebrew default, not observed
    caveat: "Homebrew's Tap Trust: until a user runs `brew trust --formula pantheon-systems/external/terminus`, `brew upgrade` silently skips the update (per docs.pantheon.io's Terminus install page). So a merge reaches only users who trusted the formula or install fresh"   # brew 7.0.13 has the `trust` command (verified); the silent skip is not observed

deployed_when:                      # ALL must hold
  - "the PR is merged and Formula/terminus.rb on main has url .../download/<version>/terminus.phar"
  - "the formula's sha256 == `shasum -a 256` of that release asset (CI does not check this)"
  - "the CI push run on main for the merge commit concluded success"
  - "on a Mac with the tap: after `brew update`, `brew info --json=v2 pantheon-systems/external/terminus` shows versions.stable == <version> and tap_git_head == the merge commit"

health:
  soak_minutes: 0                   # nothing runs. Health is: the formula installs and the binary it installs works
  baseline: "none. Homebrew does not publish install analytics for third-party taps, and nothing in this repo emits telemetry"   # inferred for analytics
  checks:
    - name: pinned hash matches the release asset
      kind: command
      run: |
        F=$(gh api repos/pantheon-systems/homebrew-external/contents/Formula/terminus.rb -H 'Accept: application/vnd.github.raw')
        URL=$(echo "$F" | sed -n 's/^  url "\(.*\)"$/\1/p'); SHA=$(echo "$F" | sed -n 's/^  sha256 "\(.*\)"$/\1/p')
        echo "$SHA  pinned"; curl -sSL "$URL" | shasum -a 256
      healthy: "the two hashes are identical (ran 2026-11-10 for 4.3.5: both b5653c9e…c8d2)"
    - name: formula style and audit
      kind: command
      run: "gh run list -R pantheon-systems/homebrew-external --workflow ci.yml --branch main --limit 1 --json conclusion,headSha"
      healthy: "conclusion success for the merge commit (ran 2026-11-10: run 42724097675, success, 5962150)"
    - name: clients see the new version
      kind: command
      run: "brew update && HOMEBREW_NO_AUTO_UPDATE=1 brew info --json=v2 pantheon-systems/external/terminus | jq -r '.formulae[0]|[.versions.stable,.tap_git_head]|@tsv'"
      healthy: "<version> and the merge commit (ran 2026-11-10 with an already-updated tap: 4.3.5, 5962150ec498…)"
    - name: install and formula test
      kind: command
      run: "brew upgrade terminus (or brew install pantheon-systems/external/terminus) && brew test pantheon-systems/external/terminus && terminus --version"
      healthy: "install succeeds, `brew test` (runs `terminus art`) passes, and --version prints 'Terminus <version>'"
      # TODO(verify-on-deploy): run on a Mac on the next formula bump; not run while drafting because it changes the local install
  delegate: "whether the Terminus release itself works is the terminus contract's health section"
  known_baseline_errors: []
  dashboards: []                    # checked: none exist
  alerts: []                        # checked: nothing watches the tap

rollback:
  options:
    - when: always                  # there is no faster path: every change to main is a PR through the merge queue
      kind: revert-and-merge
      steps: "PR that reverts the formula bump (git revert <merge commit>) or sets url + sha256 back to <PREVIOUS_VERSION>; CI; approval by a DevX member other than the author; merge queue"
      time_to_rollback_minutes: 10  # inferred: CI ~1 min, queue to merge 51 s on #91, plus however long an approval takes (formula PRs waited 43-48 min, #89 and #91)
  not_restored:
    - "copies users already installed or upgraded: `brew upgrade` won't downgrade, so they need `brew update && brew reinstall terminus`"   # inferred: Homebrew behavior, per the terminus README
    - "the Terminus release itself: self:update and Composer users are covered by the terminus rollback, not this one"
  one_way_changes: []
  currently_blocked: null
  last_exercised: "2021-12-03: #6 reverted the 3.0.0-rc1 bump (#5), the only formula revert in history (https://github.com/pantheon-systems/homebrew-external/pull/6). Same revert-and-merge path, before the merge queue and signed-commit rules existed"
  capture_before_merge: "gh api repos/pantheon-systems/homebrew-external/contents/Formula/terminus.rb -H 'Accept: application/vnd.github.raw' | grep -E '^  (url|sha256) '   # record the url and sha256 on main before merging"
  who_can:
    - "open the PR: anyone with write (the developer-experience team; the pantheon-ci-bot user is a write collaborator)"
    - "approve it: a member of @pantheon-systems/developer-experience who is not the PR author"
  verify: "Formula/terminus.rb on main has <PREVIOUS_VERSION>'s url and sha256, the hash check above passes, and after `brew update && brew reinstall terminus`, `terminus --version` prints 'Terminus <PREVIOUS_VERSION>'"

escalation:
  slack: "#ask-hosting"
  owner_team: developer-experience
  paged: false                      # nobody is paged for this tap

preflight:
  - "gh auth status (read on pantheon-systems/homebrew-external and pantheon-systems/terminus)"
  - "for the client checks: a Mac with Homebrew and the tap (`brew tap pantheon-systems/external`; tapping and installing change the local machine)"

automation_blockers:
  - blocker: "the formula PR that the terminus release job opens has an unsigned commit (it commits through the REST contents API with a personal token). The org ruleset requires signed commits, which blocks merging it as opened [inferred: GitHub blocks unsigned PR commits even for squash merges; not tried]. On #91 the approver replaced the commit with a signed one by force-pushing before queueing it (verified from the PR timeline and commit signatures)"
    clears_when: "the job creates a signed commit, e.g. the GraphQL createCommitOnBranch mutation or a GitHub App token (both produce GitHub-signed commits)"   # inferred: fix not tried
  - blocker: "CI never downloads the asset, so a wrong sha256 or url merges green"
    clears_when: "CI hashes the url and compares it with the formula (or runs `brew audit --online` / `brew fetch` plus `brew test` on a macOS runner)"

release:
  mechanism: "a merge to main is the release; no tag, no GitHub release, no bottles. Normally the terminus 'Package a Homebrew release' job opens the PR (branch terminus-release-<version>, title 'terminus <version>'); RELEASING.md's manual steps are the fallback"
  never: "point the formula at a pre-release (a tag containing '-'); the job skips them on purpose"
consumers:
  - {who: "macOS users following docs.pantheon.io (Terminus install page recommends Homebrew)", pin: none, picked_up_by: "`brew upgrade terminus` after `brew update`, if they ran `brew trust`"}
  - {repo: customer-secrets, pin: "Brewfile: tap pantheon-systems/external; brew pantheon-systems/external/terminus", picked_up_by: "brew bundle"}
  - {repo: pantheonapi, pin: "Brewfile (same lines)", picked_up_by: "brew bundle"}
  - {repo: pantheon-skills, pin: none, picked_up_by: "the using-terminus skill tells agents to install from this tap"}   # found by code search, not opened
  - {repo: terminus, pin: none, picked_up_by: "README install instructions; the release workflow opens the bump PRs here"}

verified:
  at: null
  by: null
  change: null
  running_digest: null              # n/a for a tap: record the merge commit and the formula's sha256 instead
---

# Deployment

This repo is the Homebrew tap for [Terminus](https://github.com/pantheon-systems/terminus). It holds one formula, `Formula/terminus.rb`, which pins a Terminus release's `terminus.phar` by `url` and `sha256`. Nothing is built or published from here. **A merge to `main` is the deploy**: Homebrew clients clone the tap's `main` and read the formula on their next `brew update`.

## How a change reaches production

Normally a Terminus release drives it. The Terminus contract ([DEPLOYMENT.md](https://github.com/pantheon-systems/terminus/blob/4.x/DEPLOYMENT.md)) covers the release itself.

1. A `4.x` tag in terminus runs the `Terminus 4.x` workflow. After the GitHub release is public, its **Package a Homebrew release** job hashes the published `terminus.phar`, commits the new `url` and `sha256` to `Formula/terminus.rb` on branch `terminus-release-<version>` here, and opens a PR titled `terminus <version>`. Tags containing `-` (pre-releases) are skipped. On 4.3.5 the job took 10 seconds.
2. **The PR's commit is unsigned**, and the org ruleset requires signed commits, so expect it not to merge as opened [inferred]. Re-create it as a signed commit on the same branch, e.g. `git fetch origin terminus-release-<version> && git checkout terminus-release-<version> && git commit --amend --no-edit -S && git push --force-with-lease`. That's what happened on [#91](https://github.com/pantheon-systems/homebrew-external/pull/91). TODO(owner): is amend-and-force-push the intended interim step until the job signs its commit, or should a hand-made PR replace the job's PR? The PR is authored by the GitHub user who owns the token the job uses, so that user can't approve it.
3. CI (`CI` / `audit`: `brew style` and `brew audit --strict`) runs in about a minute. It does **not** download the asset or check the hash; do that yourself (see health below).
4. A member of `@pantheon-systems/developer-experience` other than the author approves. The branch must be up to date with `main`. Only the Wiz scanners are required checks.
5. Add it to the merge queue (squash only). On #91, queued to merged took 51 seconds; CI ran on the `gh-readonly-queue/...` branch and again on `main` after the merge.
6. Users get it on their next `brew update` (which `brew install` and `brew upgrade` run automatically, at most once a day by default [inferred]).

If the job fails, follow the manual steps in [Releasing by hand](#releasing-by-hand).

Other ways what users install can change: anyone who replaces or deletes `terminus.phar` on the Terminus GitHub release changes what the formula downloads. Because the formula pins `sha256`, that shows up as a checksum failure on install, not as a silently different binary.

No GitHub Environment, approval gate or concurrency group applies. The repo has no secrets of its own.

### Releasing by hand

When the Terminus job fails to open the PR:

1. Find the release on the [Terminus releases page](https://github.com/pantheon-systems/terminus/releases). Never use a pre-release.
2. Hash the asset:
   ```bash
   curl -sL https://github.com/pantheon-systems/terminus/releases/download/<version>/terminus.phar | shasum -a 256
   ```
3. Update `url` and `sha256` in `Formula/terminus.rb` and open a PR (signed commit). CI runs `brew style` and `brew audit`.
4. After merge, users get it with `brew update && brew upgrade terminus`.

## How to confirm it deployed

All of these, in order:

1. The PR is merged and `Formula/terminus.rb` on `main` has `url ".../download/<version>/terminus.phar"`.
2. The pinned hash matches the asset:
   ```bash
   F=$(gh api repos/pantheon-systems/homebrew-external/contents/Formula/terminus.rb -H 'Accept: application/vnd.github.raw')
   URL=$(echo "$F" | sed -n 's/^  url "\(.*\)"$/\1/p'); SHA=$(echo "$F" | sed -n 's/^  sha256 "\(.*\)"$/\1/p')
   echo "$SHA  pinned"; curl -sSL "$URL" | shasum -a 256
   ```
3. The `CI` push run on `main` for the merge commit succeeded: `gh run list -R pantheon-systems/homebrew-external --workflow ci.yml --branch main --limit 1 --json conclusion,headSha`.
4. On a Mac with the tap: `brew update && HOMEBREW_NO_AUTO_UPDATE=1 brew info --json=v2 pantheon-systems/external/terminus | jq -r '.formulae[0]|[.versions.stable,.tap_git_head]|@tsv'` prints `<version>` and the merge commit.

## How to confirm it's healthy

There is nothing running to watch, and no install analytics for a third-party tap. Health means the formula installs and the binary it installs works:

- The hash check above passes.
- `brew upgrade terminus` (or a fresh `brew install pantheon-systems/external/terminus`), then `brew test pantheon-systems/external/terminus` (runs `terminus art`) and `terminus --version` prints `Terminus <version>`. TODO(verify-on-deploy): run this on a Mac on the next bump.
- No reports in `#ask-hosting` or from Support that the Homebrew install is broken.

Whether the Terminus release itself works is the [Terminus contract](https://github.com/pantheon-systems/terminus/blob/4.x/DEPLOYMENT.md)'s job.

Users who haven't trusted the formula (`brew trust --formula pantheon-systems/external/terminus`, a newer Homebrew requirement for third-party taps) don't get upgrades: per the [Terminus install docs](https://docs.pantheon.io/terminus/install), `brew upgrade` silently skips it. A merge reaching "production" therefore means reaching trusting users and fresh installs.

## Rollback

**When:** the Terminus release the formula points at was pulled back (see the [Terminus rollback](https://github.com/pantheon-systems/terminus/blob/4.x/README.md#rollback)); `brew install` / `brew upgrade terminus` fails (checksum mismatch, the formula's `test do` fails); or reports that the Homebrew-installed Terminus is broken while the previous version works.

**Before merging any formula change**, record what `main` points at now:

```bash
gh api repos/pantheon-systems/homebrew-external/contents/Formula/terminus.rb -H 'Accept: application/vnd.github.raw' | grep -E '^  (url|sha256) '
```

**Steps** (revert and merge; there is no faster path, every change to `main` goes through a PR and the merge queue):

1. Open a PR that reverts the bump (`git revert <BAD_COMMIT>` on a branch), or sets `url` and `sha256` in `Formula/terminus.rb` back to `<PREVIOUS_VERSION>`. The previous values are in the file's history, or hash the asset: `curl -sL https://github.com/pantheon-systems/terminus/releases/download/<PREVIOUS_VERSION>/terminus.phar | shasum -a 256`.
2. CI runs `brew style` and `brew audit --strict`; run the hash check yourself, since CI doesn't.
3. A Developer Experience member other than the author approves it, and it merges through the merge queue. Expect about 10 minutes plus the wait for an approval [inferred: never exercised].

**Verify:** `Formula/terminus.rb` on `main` has `<PREVIOUS_VERSION>`'s `url` and `sha256`, the hash check passes, and after `brew update && brew reinstall terminus`, `terminus --version` prints `Terminus <PREVIOUS_VERSION>` and the reported symptom is gone.

**What it doesn't undo:** users who already upgraded keep the bad version until they run `brew update && brew reinstall terminus` (`brew upgrade` won't downgrade). To pull the release back from `terminus self:update` and Composer as well, follow the [Terminus rollback](https://github.com/pantheon-systems/terminus/blob/4.x/README.md#rollback).

**Who:** anyone on the Developer Experience team can open the PR; another DevX member approves.

## Escalation

Owner: Developer Experience (`@pantheon-systems/developer-experience`). Ask in `#ask-hosting`. Nobody is paged for this tap.

## Suggested pipeline changes

- **Sign the bump commit.** The terminus `Package a Homebrew release` job commits through the REST contents API, which leaves the commit unsigned, so a human has to re-create it before the PR can merge. Creating the commit with GraphQL `createCommitOnBranch` or a GitHub App token would produce a GitHub-signed commit [inferred]. The change belongs in terminus `.github/workflows/4.x.yml`.
- **Check the hash in CI.** Add a step that downloads the formula's `url` and compares it with `sha256` (or run `brew fetch` / `brew audit --online` and `brew test` on a macOS runner). Today a wrong hash merges green.
- **Delete merged branches.** `delete_branch_on_merge` is off, and every `terminus-release-<version>` branch is still there. Re-running the terminus job for a version whose branch exists fails when it creates the branch [inferred]. Turn it on through github-terraform, or make the job reuse the branch.
- **Dependabot PR [#88](https://github.com/pantheon-systems/homebrew-external/pull/88)** (bumps `Homebrew/actions/setup-homebrew`) has been open since 2026-10-05; its only CI run was cancelled after about 15 minutes.
