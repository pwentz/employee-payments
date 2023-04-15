require "net/http"

class ProcessPaymentsJob < ApplicationJob
  queue_as :default

  """
  For each payment
  1. if payment.employee.methodfi_id.nil?
    a. create individual entity and save response id as methodfi_id
  2. if payment.employee.methodfi_account_id.nil?
    a. grab merchant using payment.employee.plaid_id
    b. using mch_id and account_number, create a liability account and save as methodfi_account_id
  3. if payment.payor.employer.methodfi_id.nil?
    a. create corporation entity and save response id as methodfi_id
  4. if payment.payor.methodfi_id.nil?
    a. create ach account for corporation using account and routing number
    b. save resulting account as payment.payor.methodfi_id
  """
  def perform(upload_id)
    upload = Upload.find(upload_id)
    # plaid_id : merchant_id
    merchant_cache = {}

    upload.payments.each do |payment|
      employee = payment.payee.employee

      employee_entity_params = {
        "type" => "individual",
        "individual[first_name]" => employee.first_name,
        "individual[last_name]" => employee.last_name,
        "individual[phone]" => employee.phone_number,
        "individual[dob]" => employee.date_of_birth.strftime("%Y-%m-%d")
      }
      individual_entity_response = Net::Http.post_form(
        "https://dev.methodfi.com/accounts",
        employee_entity_params
      )

      # get merchant /merchant?provider_id.plaid=#{payment.payee.plaid_id}
      # iterate through provider_ids.plaid and update cache with { plaid_id: mch_id }

      employer = payment.payor.employer
      corporation_entity_params = {
        "type" => "c_corporation",
        "corporation" => {
          "name"   => employer.name,
          "dba"    => employer.dba,
          "ein"    => employer.ein_number,
          "owners" => []
        },
        "address" => {
          "line1" => employer.address_line_1,
          "line2" => employer.address_line_2,
          "city"  => employer.address_city,
          "state" => employer.address_state,
          "zip"   => employer.address_zip
        }
      }

    end

    upload.update!(status: :processed)
  end
end
