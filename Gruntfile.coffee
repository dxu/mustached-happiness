module.exports = (grunt) ->
  grunt.initConfig
    concurrent:
      src:
        tasks: ['newer:coffee:src', 'newer:copy:src', 'newer:less:src']
      dev:
        tasks: ['watch:src', 'nodemon:dev']
        options:
          logConcurrentOutput: true
    # if any of the src files change, should rerun concurrent:src
    watch:
      src:
        files: ['src/**/*']
        tasks: 'concurrent:src'

    coffee:
      src:
        expand: true
        cwd: 'src/coffee'
        src: '**/*.coffee'
        dest: 'dist/scripts'
        ext: '.js'
    copy:
      src:
        expand: true
        cwd: 'src/'
        src: ['templates/**/*', 'assets/**/*']
        dest: 'dist/'

    less:
      src:
        expand: true
        cwd: 'src/stylesheets'
        src: '**/*.less'
        dest: 'dist/stylesheets'
        ext: '.css'
    nodemon:
      dev:
        script: 'server/app.coffee'
        options:
          args: []
          nodeArgs: []
          callback: (nodemon) ->
            nodemon.on 'log', (event) ->
              console.log event.colour
          env:
            PORT: 3000
          cwd: __dirname
          ignore: []
          ext: 'coffee, html'
          # dist is created from watch task
          watch: ['./server', './dist/templates']
          delay: 1000
          legacyWatch: true
    clean: ['dist/']


  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-nodemon'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-newer'
  grunt.loadNpmTasks 'grunt-contrib-clean'


  grunt.registerTask 'build', ['copy:src', 'coffee:src', 'less:src']
  grunt.registerTask 'dev', 'concurrent:dev'

