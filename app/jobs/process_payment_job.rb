class ProcessPaymentJob < ApplicationJob
  queue_as :default
  # do not retry because failure likely due to bad data
  sidekiq_options retry: false

  def perform(options)
    payment = Payment.find(options["payment_id"])
    client = MethodfiClient.new(Rails.application.credentials.dig(:methodfi, :api_key))

    if payment.payee.employee.methodfi_id.nil?
      create_methodfi_employee(payment.payee.employee, client: client)
    end

    if payment.payee.methodfi_id.nil?
      methodfi_merchant_id = options.dig("merchant_cache", payment.payee.plaid_id)
      create_methodfi_payee(payment.payee, methodfi_merchant_id, client: client)
    end

    if payment.payor.employer.methodfi_id.nil?
      create_methodfi_employer(payment.payor.employer, client: client)
    end

    if payment.payor.methodfi_id.nil?
      create_methodfi_payor(payment.payor, client: client)
    end

    methodfi_payment = client.create_payment({
      "amount" => (payment.amount * 100).to_i ,
      "source" => payment.payor.methodfi_id,
      "destination" => payment.payee.methodfi_id,
      "description" => "loan pmt"
    })

    new_status = methodfi_payment.fetch("status", "failed")

    payment.update!(
      methodfi_id: methodfi_payment["id"],
      status: new_status == "pending" ? "processing" : new_status
    )
  end

  def create_methodfi_employee(employee, client:)
    entity = client.create_entity({
      "type" => "individual",
      "individual[first_name]" => employee.first_name,
      "individual[last_name]" => employee.last_name,
      "individual[phone]" => employee.phone_number,
      "individual[email]" => "#{employee.first_name}.#{employee.last_name}@gmail.com".downcase,
      "individual[dob]" => employee.date_of_birth.strftime("%Y-%m-%d"),
      "address[line1]" => "3300 N Interstate 35",
      "address[line2]" => nil,
      "address[city]" => "Austin",
      "address[state]" => "TX",
      "address[zip]" => "78705"
    })

    employee.update!(methodfi_id: entity["id"])
  end

  def create_methodfi_payee(payee, methodfi_merchant_id, client:)
    account = client.create_account({
      "holder_id" => payee.employee.methodfi_id,
      "type" => "liability",
      "liability[mch_id]" => methodfi_merchant_id,
      "liability[number]" => payee.account_number
    })

    payee.update!(methodfi_id: account["id"])
  end

  def create_methodfi_employer(employer, client:)
    entity = client.create_entity({
      "type" => "c_corporation",
      "corporation[name]" => employer.name,
      "corporation[dba]" =>  employer.dba,
      "corporation[ein]" =>  employer.ein_number,
      "corporation[owners]" => [],
      "address[line1]" => employer.address_line_1,
      "address[line2]" => employer.address_line_2,
      "address[city]" => employer.address_city,
      # received methodfi error about sample zip not matching sample state (IA)
      "address[state]" => "KS",
      "address[zip]" => employer.address_zip
    })

    employer.update!(methodfi_id: entity["id"])
  end

  def create_methodfi_payor(payor, client:)
    account = client.create_account({
      "holder_id" => payor.employer.methodfi_id,
      "ach[type]" => "checking",
      "ach[routing]" => payor.routing_number,
      "ach[number]" => payor.account_number
    })

    payor.update!(methodfi_id: account["id"])
  end
end
