require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative( '../models/car.rb' )
require_relative( '../models/customer.rb' )
require_relative( '../models/shop.rb' )
also_reload( '../models/*' )

## INDEX ##
get '/shops' do
  @shops = Shop.all
  erb( :"shops/index" )
end

## CREATE ##
get '/shops/new' do
  erb(:"shops/new")
end

post '/shops' do
  shop = Shop.new(params)
  shop.save
  redirect to("/shops")
end

## SHOW ##
get('/shops/:id') do
  id = params[:id].to_i
  @shop = Shop.find(id)
  erb(:"shops/show")
end

## EDIT ##
get('/shops/:id/edit') do
  @id = params[:id].to_i
  @shop = Shop.find(@id)
  erb(:"shops/edit")
end

## UPDATE ##
post('/shops/:id') do
  shop = Shop.new(params)
  shop.update
  redirect to ('/shops')
end

# ## DELETE ##
# post '/shops/:id/delete' do
#   Shop.delete(params[:id])
#   redirect to('/shops')
# end
