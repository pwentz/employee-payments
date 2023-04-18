class ProcessPaymentsInteractor
  def self.run(payments)
    merchant_cache = {}

    payments.each do |payment|
      plaid_id = payment.payee.plaid_id

      # cache merchants to avoid excess fetches
      if payment.payee.methodfi_id.nil? && merchant_cache[plaid_id].nil?
        client = MethodfiClient.new(Rails.application.credentials.dig(:methodfi, :api_key))
        methodfi_merchant = client.get_merchant(plaid_id)
        # can't find merchant means we received an invalid plaid_id
        if methodfi_merchant.nil?
          payment.update!(status: :invalidated)
          next
        end

        (methodfi_merchant.dig("provider_ids", "plaid") || []).each do |plaid|
          merchant_cache[plaid] = methodfi_merchant["mch_id"]
        end
      end

      ::ProcessPaymentJob.perform_later(
        "payment_id" => payment.id,
        "merchant_cache" => merchant_cache
      )
    end
  end
end
