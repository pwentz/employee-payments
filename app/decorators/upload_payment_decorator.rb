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
      "employee_id" => @payment.employee.corporate_id,
      "employee_branch_id" => @payment.employee.branch_id,
      "employee_account_number" => @payment.employee.account_number,
      # spaces aren't being properly escaped
      "payor_name" => (@payment.payor.employer.dba || @payment.payor.employer.name).split(" "),
      "payor_id" => @payment.payor.corporate_id,
      "payor_routing_number" => @payment.payor.routing_number,
      "payor_account_number" => @payment.payor.account_number
    }
  end
end
