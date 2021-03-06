# >--------------------------------[ home_page_users ]--------------------------------<

# Application template recipe. Check for a newer version here:
# https://github.com/fortuity/rails-template-recipes/blob/master/home_page_users.rb

# There is Haml code in this script. Changing the indentation is perilous between HAMLs.

say_recipe 'Home Page Showing Users'

after_bundler do

  if extra_recipes.include? 'devise'

    #----------------------------------------------------------------------------
    # Modify the home controller
    #----------------------------------------------------------------------------
    gsub_file 'app/controllers/home_controller.rb', /def index/ do
    <<-RUBY
def index
  @users = User.all
RUBY
    end

    #----------------------------------------------------------------------------
    # Replace the home page
    #----------------------------------------------------------------------------
    if recipe_list.include? 'haml'
      remove_file 'app/views/home/index.html.haml'
      # we have to use single-quote-style-heredoc to avoid interpolation
      create_file 'app/views/home/index.html.haml' do 
      <<-'HAML'
%h3 Home
- @users.each do |user|
  %p User: #{user.name}
HAML
      end
    else
      append_file 'app/views/home/index.html.erb' do <<-ERB
<h3>Home</h3>
<% @users.each do |user| %>
  <p>User: <%= user.name %></p>
<% end %>
ERB
      end
    end

  end

  if extra_recipes.include? 'git'
    git :tag => "home_page_with_users"
    git :add => '.'
    git :commit => "-am 'Added display of users to the home page.'"
  end

end