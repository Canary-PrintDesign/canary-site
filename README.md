# canary-site
:hatched_chick: The front-end website for Canary Print + Design

## Getting Started

1. `bower install`
2. `bundle install`
3. `middleman server`


## Deploying
1. `middleman build` (Will create website at /build)
2. `npm install` (install dependencies for grunt unCSS process)
3. `grunt` (Runs Grunt-unCSS and cssmin)
4. There will be 4 files located at /build/stylesheets/ now
  * main-HASHCODE.min.css (Ignore this file)
  * main-HASHCODE.css (The original minified CSS file created by Middleman)
  * main_uncss.css (The unCSS reduced file, but un-minified)
  * main_uncss.min.css (The unCSS reduced + Minified file)
5. Rename main_uncss.min.css to replace main-HASHCODE.css
6. Deploy to server
