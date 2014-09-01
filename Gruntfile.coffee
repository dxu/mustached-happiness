module.exports = (grunt) ->
  grunt.initConfig
    copy:
      src:
        expand: true
        cwd: 'src'
        src: 'assets/**'
        dest: 'src/dist'
    concurrent:
      src:
        tasks: ['newer:coffee:src', 'newer:less:src', 'newer:copy:src']
      dev:
        tasks: ['watch:src']
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
        dest: 'src/dist/scripts'
        ext: '.js'
    less:
      src:
        expand: true
        cwd: 'src/less'
        src: '**/*.less'
        dest: 'src/dist/styles'
        ext: '.css'
    clean: ['dist/']


  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-newer'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'


  grunt.registerTask 'build', ['coffee:src', 'less:src', 'copy:src']
  grunt.registerTask 'dev', 'concurrent:dev'

