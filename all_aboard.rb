@template = template

def file_template(filename)
  template_string = open(File.join(File.dirname(@template), "/file-templates/", filename)).read
  eval("\"" + template_string.gsub('"','\\"') + "\"")
end

# Initialize git repo
git :init

run "echo 'TODO add readme content' > README"
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "cp config/database.yml config/example_database.yml"

# Delete unnecessary files
run "rm public/index.html"

file ".gitignore", <<-END
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

git :add => "."
git :commit => "-m 'initial commit'"


# HAML / Compass
gem 'haml'
gem 'chriseppstein-compass', :lib => 'compass'

run "haml --rails ."
run "echo -e 'y\nn\n' | compass --rails -f blueprint ."

git :add => "."
git :commit => "-m 'Added haml and compass with blueprint.'"


# Shoulda
gem 'thoughtbot-shoulda', :lib => "shoulda", :source => "http://gems.github.com"
rake "gems:install", :sudo => true
git :add => '.'
git :commit => "-a -m 'Added shoulda for testing.'"


# Factory girl
gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"
rake "gems:install", :sudo => true
git :add => '.'
git :commit => "-a -m 'Added factory girl.'"


# jQuery
git :rm => "public/javascripts/*"
 
file 'public/javascripts/jquery.js',
  open('http://code.jquery.com/jquery-latest.js').read
file 'public/javascripts/jquery.min.js',
  open('http://code.jquery.com/jquery-latest.min.js').read

file "public/javascripts/application.js", <<-JS
$(function() {
// ...
});
JS
 
git :add => "."
git :commit => "-a -m 'Added the latest version of jQuery'"


# Showoff
plugin "showoff", :git => "git://github.com/adamlogic/showoff.git"
generate :showoff
git :add => "."
git :commit => "-a -m 'Added Showoff for mocking up the UI.'"

# Layout / Templates / Basic Routes
file 'app/views/layouts/application.html.haml', 
  file_template("application.html.haml")

file 'app/stylesheets/screen.sass', 
  file_template("screen.sass")

file 'app/stylesheets/partials/_base.sass', 
  file_template("_base.sass")

file 'app/controllers/welcome_controller.rb', 
  file_template("welcome_controller.rb")

file 'app/views/welcome/index.html.haml', 
  file_template("index.html.haml")

route 'map.root :controller => "welcome"'
git :add => "."
git :commit => "-a -m 'Added application template/styles.'"

