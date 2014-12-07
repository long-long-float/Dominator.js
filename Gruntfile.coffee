module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compile:
        files:
          "jquery.dominator.js": "jquery.dominator.coffee"

    watch:
      options:
        livereload: true
      dominator:
        files: ["jquery.dominator.coffee"]
        tasks: ['coffee']
    connect:
      server:
        options:
          port: 8080

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
