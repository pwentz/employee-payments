class PaymentDecorator < SimpleDelegator
  def initialize(payment)
    @payment = payment
    super(payment)
  end

  def as_json(options = {})
    {
      "id" => @payment.id,
      "amount" => @payment.amount.to_s,
      "status" => @payment.status.humanize,
      "employee_first_name" => @payment.payee.employee.first_name,
      "employee_last_name" => @payment.payee.employee.last_name,
      "employee_phone_number" => @payment.payee.employee.phone_number,
      "employee_date_of_birth" => @payment.payee.employee.date_of_birth.strftime("%m-%d-%Y"),
      "employee_id" => @payment.payee.employee.corporate_id,
      "employee_branch_id" => @payment.payee.employee.branch_id,
      "payee_account_number" => @payment.payee.account_number,
      "payee_plaid_id" => @payment.payee.plaid_id,
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
