# Changelog

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](https://semver.org/) and
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed
- OpenResearch Stack: 1.39.17-005 → 1.39.17-006
  - PHP: 8.1 → 8.2
    - The wiki now runs on PHP 8.2, using a newer base image that also contains security fixes.
    - Custom code, local extensions or settings that rely on PHP 8.1 behaviour should be checked, for example for dynamic properties, which PHP 8.2 reports as deprecated.
    - The build of the image uses the newer package manager of the PHP 8.2 base image; its stricter default package checks are switched off for the composer step, because the pinned package versions are required for MediaWiki 1.39 compatibility.
  - PageForms: 2.3.2 → 2.4.0
    - Date inputs now store dates as ISO dates (`2026`, `2026-09`, `2026-09-30`, and `2026-09-30 14:05:00` with a time), regardless of input type, wiki language and `$wgAmericanDates`. Formats written before are still understood and are rewritten as ISO dates when the form is saved. Templates that take a stored date apart themselves, for example by splitting it at `/`, need to be adjusted.
    - The month dropdown of the `date` and `datetime` inputs shows month names in the user's language, and the day, month and year entries follow the date format chosen in the user's preferences.
    - The calendar and spreadsheet displays read and write ISO dates and no longer depend on `$wgAmericanDates`.
    - Saving a form no longer drops a date its input cannot show: a year or month on its own is kept in a text field, and a value that is not a date is kept with a note instead of being emptied.
    - A `datetime` input no longer shows 12:00:00 AM for a stored value that has no time.
    - Values typed into the day, month and year entries are shown as typed when the form is shown again, even if they contain characters such as `<` and `"`.
    - A day that the month does not have, like the 31st of February, is rejected by the `date` input.
    - The calendar display (`display=calendar`) is shown again; before, the calendar stayed empty and saving the form removed all calls of the template from the page.
    - Fixed a page of a category going missing from the values of a `values from category` field when its name equals the display title of another page of the category.
    - Opening a form with a field whose values come from a number property (`values from property`) works again instead of failing with an error.
    - A form tag such as `{{{standard input|save}}}` at the end of a parser function works again: the parser function is evaluated instead of being shown as text.

## [3.3.2] - 2026-10-14

### Changed
- OpenResearch Stack: 1.39.17-004 → 1.39.17-005
  - PageForms: 2.1.12 → 2.3.2
    - Fixed `#autoedit` and the `pfautoedit` API removing or corrupting entries of multiple-instance templates, dropping undefined template parameters and reporting false edit conflicts.
    - Fixed forms removing a page's Semantic MediaWiki properties when opened or saved right after a purge.
    - Fixed several form problems: templates created from forms storing a leading `0:` in field values, the "Minor edit" checkbox being ignored, random numbers in page names, section text being stored twice, and permission errors on forms denied by a hook.
    - Forms with several fields using the same value source or mapping template now open faster.
    - Added additional hardening.

## [3.3.1] - 2026-10-06

### Changed
- OpenResearch Stack: 1.39.17-003 → 1.39.17-004
  - EditAccount: 3.1.0 → 3.1.1
    - Fixed an error on Special:Contributions that made the page unusable; the notice for disabled accounts is displayed again.

## [3.3.0] - 2026-10-01

### Changed
- OpenResearch Stack: 1.39.17-002 → 1.39.17-003
  - Additional hardening

## [3.2.1] - 2026-10-01

### Fixed
- The local ELN test setup no longer prevents a freshly installed wiki from starting: the login throttle is now switched off with a value that MediaWiki 1.39 accepts.

### Changed
- The LabLSK settings files are copied into the image with `COPY` instead of `ADD`; the resulting image is unchanged.
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

[Unreleased]: https://github.com/TIBHannover/docker-smw-lablsk/compare/3.3.2...HEAD
[3.3.2]: https://github.com/TIBHannover/docker-smw-lablsk/compare/3.3.1...3.3.2
[3.3.1]: https://github.com/TIBHannover/docker-smw-lablsk/compare/3.3.0...3.3.1
[3.3.0]: https://github.com/TIBHannover/docker-smw-lablsk/compare/3.2.1...3.3.0
[3.2.1]: https://github.com/TIBHannover/docker-smw-lablsk/compare/3.2.0...3.2.1
[3.2.0]: https://github.com/TIBHannover/docker-smw-lablsk/compare/3.1.0...3.2.0
[3.1.0]: https://github.com/TIBHannover/docker-smw-lablsk/compare/3.0.1...3.1.0
[3.0.1]: https://github.com/TIBHannover/docker-smw-lablsk/compare/3.0.0...3.0.1
[3.0.0]: https://github.com/TIBHannover/docker-smw-lablsk/compare/2.1.0...3.0.0
