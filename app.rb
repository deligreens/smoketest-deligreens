require 'sinatra'
require 'stripe'
require 'dotenv'
require 'pony'

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

get '/error' do
  erb :three_d_secure, :layout => false
end

post '/bienvenue' do
  @amount = 9000
  @amount_humanize = @amount / 100.0

  customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :card  => params[:stripeToken]
  )

  if customer.cards.first.three_d_secure.supported == "required"
    email_body = erb :message, :layout => false
    Pony.options = {
      :subject => "Erreur dans ton paiement à l'abonnement Deligreens",
      :body => email_body,
      :via => :smtp,
      :via_options => {
        :address              => 'smtp.gmail.com',
        :port                 => '587',
        :enable_starttls_auto => true,
        :user_name            => 'vincent@deligreens.com',
        :password             => ENV["SMTP_PASSWORD"],
        :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
        :domain               => "deligreens.com"
      }
    }

    Pony.mail(:to => params[:stripeEmail])

    erb :three_d_secure, :layout => false
  else
    charge = Stripe::Charge.create(
      :amount      => @amount,
      :description => 'Abonnement Deligreens 6 mois au prix de 3 mois',
      :currency    => 'eur',
      :customer    => customer
    )

    erb :charge, :layout => false
  end

end
