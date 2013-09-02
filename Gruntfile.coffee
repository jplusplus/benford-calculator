path = require 'path'

module.exports = (grunt) ->
    grunt.initConfig
        pkg    : grunt.file.readJSON 'package.json'
        coffee :
            glob_to_multiple :
                expand : yes
                cwd    : 'src'
                src    : [ '**/*.coffee' ]
                dest   : 'lib'
                ext    : '.js'
        clean  : [ 'lib/' ]

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-clean'

    grunt.registerTask 'build', [ 'coffee' ]
    grunt.registerTask 'default', [ 'build' ]