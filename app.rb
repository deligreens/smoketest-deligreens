require 'sinatra'
require 'stripe'
require 'dotenv'

Dotenv.load

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

get '/' do
  @amount = 8997
  @amount_humanize = @amount / 100.0

  erb :index
end

post '/bienvenue' do
  @amount = 8997
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

  erb :charge
end
