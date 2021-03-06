# canary-site
:hatched_chick: The front-end website for Canary Print + Design

[![Build Status](https://travis-ci.org/Canary-PrintDesign/canary-site.svg?branch=master)](https://travis-ci.org/Canary-PrintDesign/canary-site)

## Getting Started

1. `bower install`
2. `bundle install`
3. `middleman server`

## Deployment

Deployment is handled by [Travis CI](https://travis-ci.org/Canary-PrintDesign).

1. Pushing to canary-site*production will deploy to [www.canaryprint.ca](https://www.canaryprint.ca/).
2. Pushing to canary-site*master will deploy to [staging.canaryprint.ca](https://staging.canaryprint.ca/).
3. Pushing to any other branch will deploy to [dev.canaryprint.ca](https://dev.canaryprint.ca/).

An deploy script has been added to the build steps instead of a [script deployment](https://docs.travis-ci.com/user/deployment/script/)
due to an apparent [outstanding issue](https://github.com/travis-ci/travis-ci/issues/5538).

*Commits that have [ci skip] anywhere in the commit messages are ignored by Travis CI.*

### Icons

We are using a custom build of [Fontello](http://fontello.com/) which is
described by [config.json][1]. We are using [railslove/fontello_rails_converter][2]
to update/convert the fontello assets to SCSS.

The current glyph set can be seen at http://localhost:4567/fontello-demo.html.

#### To Update Fontello

1. `sh bin/fontello_open.sh` to open our custom glyph set in the Fontello web app.
2. Change selected glyphs as needed and save your session.
3. `sh bin/fontello_convert.sh` to fetch those changes and update vendor assets.


[1]: https://github.com/Canary-PrintDesign/canary-site/blob/master/data/fontello.json
[2]: https://github.com/railslove/fontello_rails_converter
