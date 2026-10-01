# Changelog

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](https://semver.org/) and
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed
- ELNSMWAdapterUI: 2.0.0 → 2.0.1
  - The import forms on `Special:ELNSMWAdapterUI` now look and behave like standard MediaWiki forms, with a standard message box for the service status and a progress bar for the import.
  - A failed form submission now names the actual cause (e.g. a host that is not allowed) instead of a generic failure message.
  - All remaining English texts on the import pages are translated, and the missing permission messages are added.

## [3.2.0] - 2026-09-30

### Added
- OpenIDConnect: REL1_39-5ae6ab2
  - Wikis can offer login through an OpenID Connect provider (e.g. ORCID or a university single sign-on).
  - The extension is installed but not active by default; a wiki enables it in its own settings with `wfLoadExtension( 'OpenIDConnect' )`.
- PluggableAuth: 7.1.0
  - Required by OpenIDConnect; installed but not active by default and enabled by a wiki with `wfLoadExtension( 'PluggableAuth' )`.

## [3.1.0] - 2026-09-29

### Added
- ELNSMWAdapterUI: 2.0.0
  - New special page `Special:ELNSMWAdapterUI` to import spreadsheet files (and eLabFTW experiments) into the wiki through the ELN adapter service.
  - The extension is installed but not active by default; a wiki enables it in its own settings with `wfLoadExtension( 'ELNSMWAdapterUI' )`.
- ELN adapter service in the local compose stack, with ELNSMWAdapterUI enabled locally, and `make eln-sandbox` to create the sandbox accounts.

### Fixed
- The version reported by the image (`smw-lablsk-version.txt`, `$wgSmwLabLskVersion`) was still 3.0.0 in release 3.0.1.

## [3.0.1] - 2026-09-28

### Changed
- OpenResearch Stack: 1.39.17-001 → 1.39.17-002
  - Security fix: A vulnerability in ExternalData (CVE-2026-100382) that allowed unauthenticated remote code execution is fixed.
  - PageForms (2.1.3 → 2.1.12):
    - Forms no longer crash with a fatal error in several cases: `runquery` with `format=leaflet` or embedded forms without field tags, `Special:FormEdit` when a stored value was a number, and form submissions with `{num}` page-name formulas.
    - Dropdown, combobox, tokens, checkbox and radio-button fields now show clean display titles instead of raw, namespace-prefixed page names. This includes saved values that are not among the suggested options.
    - Radio buttons no longer silently blank out a saved value on save.
    - Fields with `mapping template=` and `SF_Select` fields with `function=` show their resolved result instead of raw markup.
    - The edit/preview page no longer breaks for forms with a numeric-rating mapping field.
    - Mutually exclusive alternative rows in "show on select" forms no longer stay visible at the same time.
    - Large value lists (category, namespace, concept, property) are no longer loaded in full on every page view.

## [3.0.0] - 2026-09-25

### Changed
- **BREAKING:** Renamed the image and its internal contract from SFB1153/crc1153-specific naming to the generic LabLSK naming, so it can be shared across multiple lab projects
  - `ghcr.io/tibhannover/smw-crc1153` → `ghcr.io/tibhannover/smw-lablsk`
  - `LocalSettings.SMW1153/` → `LocalSettings.LabLSK/`
  - `mediawiki.smw1153.{media,styles}` → `mediawiki.lablsk.{media,styles}`
  - `$wgSmwCrc1153Version` → `$wgSmwLabLskVersion`
  - Consumers (smw-box, smw-config) need matching updates before deploying this image. The previous SMW1153-based contract remains available on the `2.x` branch.

[Unreleased]: https://github.com/TIBHannover/docker-smw-lablsk/compare/3.0.1...HEAD
[3.0.1]: https://github.com/TIBHannover/docker-smw-lablsk/compare/3.0.0...3.0.1
[3.0.0]: https://github.com/TIBHannover/docker-smw-lablsk/compare/2.1.0...3.0.0
