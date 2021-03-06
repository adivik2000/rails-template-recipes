# >--------------------------------[ seed_database ]--------------------------------<

# Application template recipe. Check for a newer version here:
# https://github.com/fortuity/rails-template-recipes/blob/master/seed_database.rb

say_recipe 'Seed Database'

after_bundler do
  
  if extra_recipes.include? 'devise'
  
    if recipe_list.include? 'mongoid'
      # create a default user
      say_wizard "creating a default user"
      append_file 'db/seeds.rb' do <<-FILE
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'First User', :email => 'user@test.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user.name
FILE
      end
    end
  
    run 'rake db:seed'
  
  end

  if extra_recipes.include? 'git'
    git :tag => "database_seed"
    git :add => '.'
    git :commit => "-am 'Create a database seed file with a default user.'"
  end

end
