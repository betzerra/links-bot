require 'sinatra'
require 'telegram/bot'

require './links_controller'

bot = Telegram::Bot::Client.new(ENV['TELEGRAM_TOKEN'])

links_controller = LinksController.new(bot)

post '/tg' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  links_controller.handle_data(data)

  '{}'
end
