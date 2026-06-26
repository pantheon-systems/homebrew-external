# Releasing

When a new Terminus version is published, update the formula manually:

1. Find the new release on the [Terminus releases page](https://github.com/pantheon-systems/terminus/releases)
2. Download the `.phar` file and compute its SHA256:
   ```
   curl -L https://github.com/pantheon-systems/terminus/releases/download/<version>/terminus.phar | shasum -a 256
   ```
3. Update `Formula/terminus.rb` with the new version, URL, and SHA256
4. Open a PR -- CI will run `brew style` and `brew audit` to validate the formula
5. After merge, users get the update via `brew update && brew upgrade terminus`
