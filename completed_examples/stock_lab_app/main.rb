require 'pry-byebug'
require 'sinatra'
require 'yahoofinance'

get '/' do
  if params[:symbol]
    @symbol = params[:symbol].upcase
    @quote  = get_standard_quotes(@symbol)
  end
  binding.pry
  # Render the layout in views/quote.erb
  erb :quote
end

def get_standard_quotes(symbol)
  YahooFinance::get_standard_quotes(symbol)[symbol] rescue nil
end