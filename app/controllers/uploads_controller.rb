require "net/http"
class UploadsController < ApplicationController
  def index
    @uploads = Upload.all.map { |u| UploadDecorator.new(u) }
  end

  def create
    file = params["upload"]["xml"]
    xml = Nokogiri::XML(file.open) { |c| c.strict.noblanks }
    upload_id = CreatePayments.run(xml.root.children)
    redirect_to upload_payments_path(upload_id)
  end

  def update
    upload = Upload.find(params["id"])
    new_status = params["upload"]["status"] 

    if new_status == "1"
      # ProcessPaymentsJob.perform_now(params["id"])
      client = MethodfiClient.new(Rails.application.credentials.dig(:methodfi, :api_key))
      upload.payments.each do |payment|
        employee = payment.payee.employee

        employee_entity_params = {
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
        }
        id = client.create_entity(employee_entity_params)

        employee.update!(methodfi_id: id)

        merchant_id = client.get_merchant(payment.payee.plaid_id)

        employee_loan_account_params = {
          "holder_id" => employee.methodfi_id,
          "type" => "liability",
          "liability[mch_id]" => merchant_id,
          "liability[number]" => payment.payee.account_number
        }
        id = client.create_account(employee_loan_account_params)

        payment.payee.update!(methodfi_id: id)
        # iterate through provider_ids.plaid and update cache with { plaid_id: mch_id }

        employer = payment.payor.employer
        corporation_entity_params = {
          "type" => "c_corporation",
          "corporation[name]" => employer.name,
          "corporation[dba]" =>  employer.dba,
          "corporation[ein]" =>  employer.ein_number,
          "corporation[owners]" => [],
          "address[line1]" => employer.address_line_1,
          "address[line2]" => employer.address_line_2,
          "address[city]" => employer.address_city,
          # "address[state]" => employer.address_state,
          "address[state]" => "KS",
          "address[zip]" => employer.address_zip
        }
        id = client.create_entity(corporation_entity_params)

        employer.update!(methodfi_id: id)

        employer_ach_account_params = {
          "holder_id" => employer.methodfi_id,
          "ach[type]" => "checking",
          "ach[routing]" => payment.payor.routing_number,
          "ach[number]" => payment.payor.account_number
        }
        id = client.create_account(employer_ach_account_params)

        payment.payor.update!(methodfi_id: id)

        amt = (payment.amount * 100).to_i 
        payment_params = {
          "amount" => 5000,
          "source" => payment.payor.methodfi_id,
          "destination" => payment.payee.methodfi_id,
          "description" => "loan pmt"
        }
        client.create_payment(payment_params)
      end
    elsif new_status == "4"
      upload.update!(status: :discarded)
    end

    redirect_to "/"
  end
end
