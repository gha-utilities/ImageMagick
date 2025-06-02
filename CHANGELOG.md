# Changelog
[heading__changelog]: #changelog


All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][] and this project adheres to
[Semantic Versioning][].


______


## [0.0.5] - 2025-06-02


### Added

- Started tracking changes via `./CHANGELOG.md` file
- `find` _should_ now use new GitHub Action Inputs

### Changed

Inputs for `find` renamed, and implementations adjusted, to allow for Regular
Expression as well as defining the _flavor_ of RegExp that `find` should use

```diff
-        uses: gha-utilities/ImageMagick@v0.0.4
+        uses: gha-utilities/ImageMagick@v0.0.5
         with:
           source_directory: assets/images
-          source_extension: png
+          find_regex: '*.png'
           destination_extensions: jpeg,avif
```


[Keep a Changelog]: https://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html
