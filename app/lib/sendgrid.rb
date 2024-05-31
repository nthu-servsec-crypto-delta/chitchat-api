# frozen_string_literal: true

# fronze_string_literal: true

require 'http'
require 'json'

# Lib for SendGrid
class SendGrid
  class NoAPIKeyError < StandardError; end
  class NoSenderAddressError < StandardError; end
  class EmailProviderError < StandardError; end

  @sendgrid_url = 'https://api.sendgrid.com/v3/mail/send'

  def self.setup(api_key, sender_address)
    raise NoAPIKeyError if api_key.nil?
    raise NoSenderAddressError if sender_address.nil?

    @api_key = api_key
    @sender_address = sender_address
  end

  def self.mail_json(to, subject, body) # rubocop:disable Metrics/MethodLength
    {
      personalizations: [{
        to: [{ 'email' => to }]
      }],
      from: { 'email' => @sender_address },
      subject:,
      content: [
        { type: 'text/html',
          value: body }
      ]
    }
  end

  def self.send(to, subject, body)
    res = HTTP.auth("Bearer #{@api_key}")
              .post(@sendgrid_url, json: mail_json(to, subject, body))
    raise EmailProviderError unless res.status.success?

    res
  end
end
