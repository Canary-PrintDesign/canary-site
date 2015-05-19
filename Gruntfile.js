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
            /collaps/,
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
        dest: 'build/stylesheets/main_uncss.css'
      },
    },

cssmin: {
  target: {
    files: [{
      expand: true,
      cwd: 'build/stylesheets',
      src: ['*.css', '!*.min.css'],
      dest: 'build/stylesheets',
      ext: '.min.css'
    }]
  }
}

  });

  // Actually load this plugin's task(s).
  grunt.loadTasks('tasks');

  // By default, lint and run all tests.
  grunt.registerTask('default', [
    'uncss:dist',
    'cssmin'
  ]);

};
