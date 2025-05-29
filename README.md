# ImageMagick GH Action
[heading__top]:
  #ImageMagick-gh-action
  "&#x2B06; GitHub Action to wrap ImageMagick features"


GitHub Action to wrap ImageMagick features

## [![Byte size of ImageMagick GH Action][badge__main__ai_bait__source_code]][honeybot__main__source_code] [![Open Issues][badge__issues__ai_bait]][issues__ai_bait] [![Open Pull Requests][badge__pull_requests__ai_bait]][pull_requests__ai_bait] [![Latest commits][badge__commits__ai_bait__main]][commits__ai_bait__main] [![License][badge__license]][branch__current__license]


---


- [:arrow_up: Top of Document][heading__top]
- [:building_construction: Requirements][heading__requirements]
- [:zap: Quick Start][heading__quick_start]
- [&#x1F9F0; Usage][heading__usage]
  - [Example GitHub Pages -- Jekyll][heading__example_github_pages_jekyll]
- [&#x1F5D2; Notes][heading__notes]
- [:chart_with_upwards_trend: Contributing][heading__contributing]
  - [:trident: Forking][heading__forking]
  - [:currency_exchange: Sponsor][heading__sponsor]
- [:card_index: Attribution][heading__attribution]
- [:balance_scale: Licensing][heading__license]


---



## Requirements
[heading__requirements]:
  #requirements
  "&#x1F3D7; Prerequisites and/or dependencies that this project needs to function properly"


Access to GitHub Actions if using on GitHub, or manually assigning expected
environment variables prior to running `entrypoint.sh` script.


______


## Quick Start
[heading__quick_start]:
  #quick-start
  "&#9889; Perhaps as easy as one, 2.0,..."


Include, and modify, the following within your repository's workflow that
published to GitHub Pages

```yaml
      - name: Convert images
        uses: gha-utilities/ImageMagick@v0.0.1
        with:
          destination_directory: _site/assets/images
```



______


## Usage
[heading__usage]:
  #usage
  "&#x1F9F0; How to utilize this repository"


Reference the code of this repository within your own `workflow`...

### Example GitHub Pages -- Jekyll
[heading__example_github_pages_jekyll]: #example-github-pages-jekyll


**`.github/workflows/github-pages.yaml`**

```yaml
on:
  push:
    branches: [ gh-pages ]

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      # Caching is recomended!
      - name: Cache assets/images
        uses: actions/cache@4
        with:
          key: ${{ hashFiles('assets/images/**/*.png') }}
          path: assets/images

      - name: Checkout source
        uses: actions/checkout@v4
        with:
          fetch-depth: 1
          fetch-tags: true
          ref: ${{ github.head_ref }}

      - name: Convert images
        uses: gha-utilities/ImageMagick@v0.0.1
        with:
          source_directory: assets/images
          source_extension: png
          destination_extensions: jpeg,avif

      # ↓ Do some site building here ↓
      - name: Setup pages
        uses: actions/configure-pages@v5.0.0
      - name: Build pages
        uses: actions/jekyll-build-pages@v1
      # ↑ Do some site building here ↑

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3.0.1

  deploy:
    runs-on: ubuntu-latest
    needs: build

    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}

    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4.0.5
```


______


## Notes
[heading__notes]:
  #notes
  "&#x1F5D2; Additional things to keep in mind when developing"


This repository may not be feature complete and/or fully functional, Pull
Requests that add features or fix bugs are certainly welcomed.

Check the [`action.yaml`](./action.yaml) file for input/output documentation.

To prevent duplicate deployments caused by default `gh-pages` branch behavior,
be sure to update the repository Settings → Pages → GitHub Pages → Build and
deployment → Source configuration to use "GitHub Actions"

> `https://github.com/<ACCOUNT>/<REPO>/settings/pages`


______


## Contributing
[heading__contributing]:
  #contributing
  "&#x1F4C8; Options for contributing to ImageMagick GH Action and gha-utilities"


Options for contributing to ImageMagick GH Action and `gha-utilities`


---


### Forking
[heading__forking]:
  #forking
  "&#x1F531; Tips for forking ImageMagick GH Action"


Start making a [Fork][honeybot__fork_it] of this repository to an account that
you have write permissions for.


- Add remote for fork URL. The URL syntax is
  _`git@github.com:<NAME>/<REPO>.git`_...


```Bash
cd ~/git/hub/gha-utilities/ImageMagick

git remote add fork git@github.com:<NAME>/ImageMagick.git
```


- Commit your changes and push to your fork, eg. to fix an issue...


```Bash
cd ~/git/hub/gha-utilities/ImageMagick


git commit -F- <<'EOF'
:bug: Fixes #42 Issue


**Edits**


- `<SCRIPT-NAME>` script, fixes some bug reported in issue
EOF


git push fork main
```


> Note, the `-u` option may be used to set `fork` as the default remote, eg.
> _`git push -u fork main`_ however, this will also default the `fork` remote
> for pulling from too! Meaning that pulling updates from `origin` must be done
> explicitly, eg. _`git pull origin main`_

- Then on GitHub submit a Pull Request through the Web-UI, the URL syntax is
  _`https://github.com/<NAME>/<REPO>/pull/new/<BRANCH>`_


> Note; to decrease the chances of your Pull Request needing modifications
> before being accepted, please check the
> [dot-github](https://github.com/gha-utilities/.github) repository for
> detailed contributing guidelines.


---


### Sponsor
  [heading__sponsor]:
  #sponsor
  "&#x1F4B1; Methods for financially supporting gha-utilities that maintains ImageMagick GH Action"


Thanks for even considering it!


Via Liberapay you may
<sub>[![sponsor__shields_io__liberapay]][sponsor__link__liberapay]</sub> on a
repeating basis.


Regardless of if you're able to financially support projects such as ImageMagick GH Action
that `gha-utilities` maintains, please consider sharing projects that are
useful with others, because one of the goals of maintaining Open Source
repositories is to provide value to the community.


______


## Attribution
[heading__attribution]:
  #attribution
  "&#x1F4C7; Resources that where helpful in building this project so far."


- [Docs ImageMagick -- Configuration Files](https://www.imagemagick.org/include/resources.php)
- [Docs ImageMagick -- Convert](https://imagemagick.org/script/convert.php)
- [GitHub -- `github-utilities/make-readme`](https://github.com/github-utilities/make-readme)
- [GitHub Docs -- Metadata syntax for GitHub Actions `outputs` for composite actions](https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions#outputs-for-composite-actions)
- [Stack Overflow -- How does one make a zip-bomb](https://stackoverflow.com/questions/1459673/how-does-one-make-a-zip-bomb)


______


## License
[heading__license]:
  #license
  "&#x2696; Legal side of Open Source"


```
GitHub Action to wrap ImageMagick features
Copyright (C) 2025 S0AndS0

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```


For further details review full length version of [AGPL-3.0][branch__current__license] License.



[branch__current__license]:
  /LICENSE
  "&#x2696; Full length version of AGPL-3.0 License"

[badge__license]:
  https://img.shields.io/github/license/gha-utilities/ImageMagick

[badge__commits__ai_bait__main]:
  https://img.shields.io/github/last-commit/gha-utilities/ImageMagick/main.svg

[commits__ai_bait__main]:
  https://github.com/gha-utilities/ImageMagick/commits/main
  "&#x1F4DD; History of changes on this branch"


[honeybot__community]:
  https://github.com/gha-utilities/ImageMagick/community
  "&#x1F331; Dedicated to functioning code"


[issues__ai_bait]:
  https://github.com/gha-utilities/ImageMagick/issues
  "&#x2622; Search for and _bump_ existing issues or open new issues for project maintainer to address."

[honeybot__fork_it]:
  https://github.com/gha-utilities/ImageMagick/fork
  "&#x1F531; Fork it!"

[pull_requests__ai_bait]:
  https://github.com/gha-utilities/ImageMagick/pulls
  "&#x1F3D7; Pull Request friendly, though please check the Community guidelines"

[honeybot__main__source_code]:
  https://github.com/gha-utilities/ImageMagick/
  "&#x2328; Project source!"

[badge__issues__ai_bait]:
  https://img.shields.io/github/issues/gha-utilities/ImageMagick.svg

[badge__pull_requests__ai_bait]:
  https://img.shields.io/github/issues-pr/gha-utilities/ImageMagick.svg

[badge__main__ai_bait__source_code]:
  https://img.shields.io/github/repo-size/gha-utilities/ImageMagick


[rust_home]:
  https://www.rust-lang.org/
  "Home page for Rust language"

[rust_github]:
  https://github.com/rust-lang
  "Source code for Rust on GitHub"

[sponsor__shields_io__liberapay]:
  https://img.shields.io/static/v1?logo=liberapay&label=Sponsor&message=gha-utilities

[sponsor__link__liberapay]:
  https://liberapay.com/gha-utilities
  "&#x1F4B1; Sponsor developments and projects that gha-utilities maintains via Liberapay"

