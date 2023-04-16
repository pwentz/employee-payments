class PaymentDecorator < SimpleDelegator
  def initialize(payment)
    @payment = payment
    super(payment)
  end

  def as_json(options = {})
    {
      "id" => @payment.id,
      "amount" => @payment.amount.to_s,
      "status" => @payment.status,
      "employee_first_name" => @payment.payee.employee.first_name,
      "employee_last_name" => @payment.payee.employee.last_name,
      "employee_phone_number" => @payment.payee.employee.phone_number,
      "employee_date_of_birth" => @payment.payee.employee.date_of_birth.strftime("%m-%d-%Y"),
      "employee_id" => @payment.payee.employee.corporate_id,
      "employee_branch_id" => @payment.payee.employee.branch_id,
      "payee_account_number" => @payment.payee.account_number,
      "payee_plaid_id" => @payment.payee.plaid_id,
      # spaces aren't being properly escaped
      "employer_name" => @payment.payor.employer.name.split(" "),
      "employer_id" => @payment.payor.corporate_id,
      "employer_ein" => @payment.payor.employer.ein_number,
      "employer_address_line_1" => @payment.payor.employer.address_line_1.split(" "),
      "employer_address_line_2" => @payment.payor.employer.address_line_2&.split(" "),
      "employer_address_city" => @payment.payor.employer.address_city.split(" "),
      "employer_address_state" => @payment.payor.employer.address_state,
      "employer_address_zip" => @payment.payor.employer.address_zip,
      "payor_routing_number" => @payment.payor.routing_number,
      "payor_account_number" => @payment.payor.account_number,
    }
  end
end
