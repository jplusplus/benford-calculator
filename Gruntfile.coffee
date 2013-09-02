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

    grunt.loadNpmTasks 'grunt-contrib-coffee'

    grunt.registerTask 'build', [ 'coffee' ]
    grunt.registerTask 'default', [ 'build' ]