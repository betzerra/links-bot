# frozen_string_literal: true
require 'logger'

class LinksController
  def initialize(bot)
    @bot = bot
    @logger = Logger.new(STDOUT)
  end

  def help(message)
    chat_id = message['chat']['id']
    return if chat_id.nil?

    text = 'Hi! Send me any text with links and I will replace them with [Link](https://www.youtube.com/watch?v=dQw4w9WgXcQ) markdown.'

    @bot.api.send_message(
      chat_id: chat_id,
      text: text,
      parse_mode: 'markdown'
    )
  end

  def handle_message(message)
    chat_id = message['chat']['id']
    return if chat_id.nil?

    text = message['text'].gsub(%r{(https?:\/\/\S*)}) { |c| "[Link](#{c})" }

    @bot.api.send_message(
      chat_id: chat_id,
      text: text,
      parse_mode: 'markdown'
    )
  end

  def handle_data(data)
    @logger.debug("Received data: #{data.inspect}")
    return if data['message']

    message = data['message']

    case message['text']
    when %r{^/help}
      help(message)
    when %r{^/start}
      help(message)
    else
      handle_message(message)
    end
  end
end
