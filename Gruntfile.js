module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffee: {
      compile: {
        options: {
          bare: true
        },
        files: {
          'js/jquery.film_roll.js': 'coffee/jquery.film_roll.coffee'
        }
      }
    },
    uglify: {
      js: {
        files: {
          'js/jquery.film_roll.min.js': 'js/jquery.film_roll.js',
          '../film_roll_page/js/jquery.film_roll.min.js': 'js/jquery.film_roll.js'
        }
      }
    },
    watch: {
      scripts: {
        files: ['coffee/*.coffee'],
        tasks: ['coffee','uglify:js']
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.registerTask('default', ['coffee','uglify:js']);
};
