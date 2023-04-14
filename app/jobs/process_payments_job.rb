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
    upload.update!(status: :processed)
  end
end
