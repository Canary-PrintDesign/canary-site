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

*S3 deployment environment variables are stored on Travis*
