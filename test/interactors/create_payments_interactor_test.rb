require "test_helper"

class CreatePaymentsInteractorTest < ActiveSupport::TestCase
  test "it creates the necessary objects" do
    assert_equal Employee.count, 0
    assert_equal Payee.count, 0
    assert_equal Employer.count, 0
    assert_equal Payor.count, 0
    assert_equal Payment.count, 0
    assert_equal Upload.count, 0

    upload_id = CreatePaymentsInteractor.run([DummyXMLRow.new(sample_xml_row)])

    assert Upload.exists?(upload_id)
    assert_equal Upload.find(upload_id).payments.length, 1
    assert_equal Upload.count, 1

    employee = Employee.first
    assert_equal Employee.count, 1
    assert_equal employee.corporate_id, "EMP-abc123"
    assert_equal employee.branch_id, "BRC-abc123"
    assert_equal employee.first_name, "Bob"
    assert_equal employee.last_name, "Johnson"
    assert_equal employee.date_of_birth, Date.new(1994, 12, 5)

    payee = Payee.first
    assert_equal payee.plaid_id, "ins_123"
    assert_equal payee.account_number, "54321"
    assert_equal payee.employee_id, employee.id

    employer = Employer.first
    assert_equal Employer.count, 1
    assert_equal employer.name, "Dunkin' Donuts LLC"
    assert_equal employer.dba, "Dunkin' Donuts"
    assert_equal employer.ein_number, "3122"
    assert_equal employer.address_line_1, "555 Hayes Lights"
    assert_equal employer.address_city, "Des Moines"
    assert_equal employer.address_state, "IA"
    assert_equal employer.address_zip, "67485"

    payor = Payor.first
    assert_equal Payor.count, 1
    assert_equal payor.corporate_id, "CORP-abc123"
    assert_equal payor.routing_number, "98765"
    assert_equal payor.account_number, "7777"
    assert_equal payor.employer_id, employer.id

    payment = Payment.first
    assert_equal Payment.count, 1
    assert_equal payment.upload_id, upload_id
    assert_equal payment.payee_id, payee.id
    assert_equal payment.payor_id, payor.id
    assert_equal payment.amount, 8.15
  end

  test "it does not create multiple records for duplicate employer, employee, or payor" do
    assert_equal Employee.count, 0
    assert_equal Payee.count, 0
    assert_equal Employer.count, 0
    assert_equal Payor.count, 0
    assert_equal Payment.count, 0
    assert_equal Upload.count, 0

    upload_id = CreatePaymentsInteractor.run(
      # duplicate rows
      [DummyXMLRow.new(sample_xml_row), DummyXMLRow.new(sample_xml_row)]
    )

    assert_equal Upload.find(upload_id).payments.length, 2
    assert_equal Employee.count, 1
    assert_equal Payee.count, 1
    assert_equal Employer.count, 1
    assert_equal Payor.count, 1
    assert_equal Upload.count, 1
    assert_equal Payment.count, 2
  end

  test "it will not create payment if row contains invalid information" do
    assert_equal Employee.count, 0
    assert_equal Payee.count, 0
    assert_equal Employer.count, 0
    assert_equal Payor.count, 0
    assert_equal Payment.count, 0
    assert_equal Upload.count, 0

    invalid_row = sample_xml_row
    invalid_row["Employee"]["DunkinId"] = nil
    upload_id = CreatePaymentsInteractor.run([DummyXMLRow.new(sample_xml_row), DummyXMLRow.new(invalid_row)])

    assert_equal Upload.find(upload_id).payments.length, 1
    assert_equal Employee.count, 1
    assert_equal Payee.count, 1
    assert_equal Employer.count, 1
    assert_equal Payor.count, 1
    assert_equal Payment.count, 1
    assert_equal Upload.count, 1
  end

  def sample_xml_row
    {
      "Employee" => {
        "DunkinId" => "EMP-abc123",
        "DunkinBranch" => "BRC-abc123",
        "FirstName" => "Bob",
        "LastName" => "Johnson",
        "DOB" => "12-05-1994",
        "PhoneNumber" => "1234567890"
      },
      "Payor" => {
        "DunkinId" => "CORP-abc123",
        "ABARouting" => "98765",
        "AccountNumber" => "7777",
        "Name" => "Dunkin' Donuts LLC",
        "DBA" => "Dunkin' Donuts",
        "EIN" => "3122",
        "Address" => {
          "Line1" => "555 Hayes Lights",
          "City" => "Des Moines",
          "State" => "IA",
          "Zip" => "67485"
        }
      },
      "Payee" => {
        "PlaidId" => "ins_123",
        "LoanAccountNumber" => "54321"
      },
      "Amount" => "$8.15"
    }
  end

  class DummyXMLRow
    def initialize(children)
      @children = children
    end

    def at_xpath(path)
      self.class.new(@children[path])
    end

    def text
      return @children unless @children.is_a?(Hash)
      @children.values.join("")
    end
  end
end
