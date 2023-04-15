require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  """
  {
    12340 => 
    12341
    12342
  }
  """
  test ".payor_totals" do
    upload = Upload.create!

    create_payments(upload)

    expected = {
      "12340" => 10.0,
      "12341" => 12.0,
      "12342" => 14.0
    }
    actual = grouped_assoc_to_h(upload.payments.payor_totals)

    assert_equal actual, expected
  end

  test ".payor_totals (scoped)" do
    upload = Upload.create!

    create_payments(upload)

    expected = {
      "12340" => 6.0,
      "12341" => 7.0,
      "12342" => 8.0
    }
    actual = grouped_assoc_to_h(upload.payments.processed.payor_totals)

    assert_equal actual, expected
  end

  def grouped_assoc_to_h(assoc)
    assoc
      .group_by(&:account_number)
      .transform_values { |vals| vals.first.amount.to_f }
  end

  def create_payments(upload)
    employee = Employee.create!(
      corporate_id: "EMP-abc123",
      branch_id: "BRC-abc123",
      first_name: "Gus",
      last_name: "Davis",
      date_of_birth: Date.new(1994, 2, 4),
      phone_number: "+15555555555"
    )

    payee = Payee.create!(
      employee: employee,
      plaid_id: "ins_1234",
      account_number: "1234567"
    )

    ["Things N'Stuff", "Toys R We", "ACE Hardware"].each.with_index do |name, idx|
      e = Employer.create!(
        name: name,
        ein_number: "12345#{idx}",
        address_line_1: "12#{idx} Oak St",
        address_city: "Des Moines",
        address_state: "IA",
        address_zip: "12345"
      )

      payor = Payor.create!(
        employer: e,
        corporate_id: "CORP-123#{idx}",
        routing_number: "1111111#{idx}",
        account_number: "1234#{idx}"
      )

      [[6, :processed], [4, :failed]].each do |amt, status|
        Payment.create!(
          amount: amt + idx,
          status: status,
          upload: upload,
          payor: payor,
          payee: payee,
        )
      end

    end

  end
end
