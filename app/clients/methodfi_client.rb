require "net/http"

class MethodfiError < StandardError
  def initialize(response)
    super(response.body)
  end
end

class MethodfiClient
  def initialize(api_key)
    @base_url = "https://dev.methodfi.com"
    @api_key = api_key
  end

  def create_entity(entity_params)
      uri = URI.parse("#{@base_url}/entities")
      req = Net::HTTP::Post.new(uri, "Authorization" => "Bearer #{@api_key}")
      req.set_form_data(entity_params)
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
      body = JSON.parse(res.body)
      if [false, "false"].include?(body["success"])
        raise MethodfiError.new(res)
      end

      body["data"]
  end

  def create_account(account_params)
      uri = URI.parse("#{@base_url}/accounts")
      req = Net::HTTP::Post.new(uri, "Authorization" => "Bearer #{@api_key}")
      req.set_form_data(account_params)
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
      body = JSON.parse(res.body)
      if [false, "false"].include?(body["success"])
        raise MethodfiError.new(res)
      end

      body["data"]
  end

  def get_merchant(plaid_id)
      uri = URI.parse("#{@base_url}/merchants?provider_id.plaid=#{plaid_id}")
      req = Net::HTTP::Get.new(uri, 'Authorization' => "Bearer #{@api_key}")
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
      body = JSON.parse(res.body)
      if [false, "false"].include?(body["success"])
        raise MethodfiError.new(res)
      end

      body["data"]&.first
  end

  def create_payment(payment_params)
      uri = URI.parse("#{@base_url}/payments")
      req = Net::HTTP::Post.new(
        uri,
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{@api_key}"
      )
      req.body = payment_params.to_json
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
      body = JSON.parse(res.body)
      if [false, "false"].include?(body["success"])
        raise MethodfiError.new(res)
      end

      body["data"]
  end
end
