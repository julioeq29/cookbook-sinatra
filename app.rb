require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

require_relative 'recipe'
require_relative 'cookbook'


get '/' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  @recipes   = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  recipe     = Recipe.new(params[:name],
                          params[:description],
                          params[:prep_time],
                          params[:difficulty])
  cookbook.add_recipe(recipe)
  redirect to '/'
end

get '/recipes' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  cookbook.remove_recipe(params[:index].to_i)
  redirect to '/'
end

# get '/about' do
#   erb :about
# end

# get '/team/:username' do
#   # binding.pry
#   puts params[:username]
#   "The username is #{params[:username]}"
# end
