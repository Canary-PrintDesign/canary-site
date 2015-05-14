/*
 * Task for reducing unwanted css via grunt-uncss
 * https://github.com/addyosmani/grunt-uncss
 *
 * Copyright (c) 2015 Addy Osmani
 * Licensed under the MIT license.
 */

'use strict';

module.exports = function(grunt) {

  require('load-grunt-tasks')(grunt, {scope: 'devDependencies'});
  require('time-grunt')(grunt);

  // Project configuration.
  grunt.initConfig({

    uncss: {
      dist: {
        options: {
          ignore: [
            /carousel/,
            /collapse/,
            '.success',
            /header/,
            /product/,
            '.hide',
            '.show',
            '.hidden',
            /rotate/,
            /ajax/,
            /contact/,
            /has/,
            /open/,
            /featherlight/
          ]
        },
        src: ['build/**/*.html'],
        dest: 'build/stylesheets/main_min.css'
      },
    },

  });

  // Actually load this plugin's task(s).
  grunt.loadTasks('tasks');

  // By default, lint and run all tests.
  grunt.registerTask('default', [
    'uncss:dist'
  ]);

};
