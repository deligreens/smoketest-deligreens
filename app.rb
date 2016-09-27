require 'sinatra'
require 'stripe'
require 'dotenv'

Dotenv.load

set :publishable_key, ENV['PUBLISHABLE_KEY_LIVE']
set :secret_key, ENV['SECRET_KEY_LIVE']

Stripe.api_key = settings.secret_key

get '/' do
  erb :index, :layout => false
end

get '/abonnement' do
  @amount = 9000
  @amount_humanize = @amount / 100.0

  erb :abonnement, :layout => false
end

post '/bienvenue' do
  @amount = 9000
  @amount_humanize = @amount / 100.0

  customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :card  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Abonnement Deligreens 3 mois',
    :currency    => 'eur',
    :customer    => customer
  )

  erb :charge, :layout => false
end
