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
    actual = grouped_assoc_to_h(upload.payments.payor_totals, :account_number)

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
    actual = grouped_assoc_to_h(upload.payments.sent.payor_totals, :account_number)

    assert_equal actual, expected
  end

  test ".branch_totals" do
    upload = Upload.create!

    create_payments(upload)

    expected = {
      "BRC-abc123" => 24.0,
      "BRC-def456" => 12.0,
    }
    actual = grouped_assoc_to_h(upload.payments.branch_totals, :branch_id)

    assert_equal actual, expected
  end

  test ".branch_totals (scoped)" do
    upload = Upload.create!

    create_payments(upload)

    expected = {
      "BRC-abc123" => 10.0,
      "BRC-def456" => 5.0,
    }
    actual = grouped_assoc_to_h(upload.payments.failed.branch_totals, :branch_id)

    assert_equal actual, expected
  end

  def grouped_assoc_to_h(assoc, key)
    assoc
      .group_by(&key)
      .transform_values { |vals| vals.first.amount.to_f }
  end

  def create_payments(upload)
    payees = [["Gus", "Davis", "abc123"], ["Amy", "Ward", "def456"], ["Greg", "Mills", "abc123"]].map.with_index do |(first, last, branch), idx|
      Payee.create!(
        employee: Employee.create!(
          corporate_id: "EMP-abc123#{idx}",
          branch_id: "BRC-#{branch}",
          first_name: first,
          last_name: last,
          date_of_birth: Date.new(1994, 2, 4),
          phone_number: "+1555555555#{idx}"
        ),
        plaid_id: "ins_1234#{idx}",
        account_number: "789#{idx}"
      )
    end

    ["Things N'Stuff", "Toys R We", "ACE Hardware"].each.with_index do |name, idx|
      payor = Payor.create!(
        employer: Employer.create!(
          name: name,
          ein_number: "12345#{idx}",
          address_line_1: "12#{idx} Oak St",
          address_city: "Des Moines",
          address_state: "IA",
          address_zip: "12345"
        ),
        corporate_id: "CORP-123#{idx}",
        routing_number: "1111111#{idx}",
        account_number: "1234#{idx}"
      )

      [[6, :sent], [4, :failed]].each do |amt, status|
        Payment.create!(
          amount: amt + idx,
          status: status,
          upload: upload,
          payor: payor,
          payee: payees[idx],
        )
      end

    end

  end
end
