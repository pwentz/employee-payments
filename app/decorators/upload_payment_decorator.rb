class UploadPaymentDecorator < SimpleDelegator
  def initialize(payment)
    @payment = payment
    super(payment)
  end

  def as_json(options = {})
    {
      "id" => @payment.id,
      "amount" => @payment.amount.to_s,
      "employee_first_name" => @payment.employee.first_name,
      "employee_last_name" => @payment.employee.last_name,
      "employee_phone_number" => @payment.employee.phone_number,
      "employee_date_of_birth" => @payment.employee.date_of_birth.strftime("%m-%d-%Y"),
      "employee_id" => @payment.employee.corporate_id,
      "employee_branch_id" => @payment.employee.branch_id,
      "employee_account_number" => @payment.employee.account_number,
      "employee_plaid_id" => @payment.employee.plaid_id,
      # spaces aren't being properly escaped
      "payor_name" => (@payment.payor.employer.dba || @payment.payor.employer.name).split(" "),
      "payor_id" => @payment.payor.corporate_id,
      "payor_routing_number" => @payment.payor.routing_number,
      "payor_account_number" => @payment.payor.account_number,
      "payor_address_line_1" => @payment.payor.employer.address_line_1.split(" "),
      "payor_address_line_2" => @payment.payor.employer.address_line_2&.split(" "),
      "payor_address_city" => @payment.payor.employer.address_city.split(" "),
      "payor_address_state" => @payment.payor.employer.address_state,
      "payor_address_zip" => @payment.payor.employer.address_zip
    }
  end
end
