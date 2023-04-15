require "net/http"

class MethodfiClient
  def initialize(api_key)
    @api_key = api_key
  end

  def create_entity(entity_params)
      uri = URI.parse("https://dev.methodfi.com/entities")
      req = Net::HTTP::Post.new(uri, "Authorization" => "Bearer #{@api_key}")
      req.set_form_data(entity_params)
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
      JSON.parse(res.body).dig("data", "id")
  end

  def create_account(account_params)
      uri = URI.parse("https://dev.methodfi.com/accounts")
      req = Net::HTTP::Post.new(uri, "Authorization" => "Bearer #{@api_key}")
      req.set_form_data(account_params)
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
      JSON.parse(res.body).dig("data", "id")
  end

  def get_merchant(plaid_id)
      uri = URI.parse("https://dev.methodfi.com/merchants?provider_id.plaid=#{plaid_id}")
      req = Net::HTTP::Get.new(uri, 'Authorization' => "Bearer #{@api_key}")
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
      JSON.parse(res.body)["data"].first["mch_id"]
  end

  def create_payment(payment_params)
      uri = URI.parse("https://dev.methodfi.com/payments")
      req = Net::HTTP::Post.new(
        uri,
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{@api_key}"
      )
      req.body = payment_params.to_json
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
      puts "-----------------------"
      puts res.body.inspect
      puts id = JSON.parse(res.body)&.dig("data", "id")
      puts "-----------------------"
  end
end
