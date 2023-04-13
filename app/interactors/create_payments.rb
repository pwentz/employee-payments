class CreatePayments
  def self.run!(xml_rows)
    created_payments = []

      upload = Upload.create!

      xml_rows.each do |row|
        employee_elt = row.at_xpath("Employee")
        payor_elt = row.at_xpath("Payor")
        payee_elt = row.at_xpath("Payee")

        employee = Employee.find_by(corporate_id: employee_elt.at_xpath("DunkinId").text)
        if employee.nil?
          dob = employee_elt.at_xpath("DOB").text
          formatted_dob = dob && Date.strptime(dob, "%m-%d-%Y")
          employee = Employee.create!(
            corporate_id: employee_elt.at_xpath("DunkinId").text,
            branch_id: employee_elt.at_xpath("DunkinBranch").text,
            first_name: employee_elt.at_xpath("FirstName").text,
            last_name: employee_elt.at_xpath("LastName").text,
            date_of_birth: formatted_dob,
            phone_number: employee_elt.at_xpath("PhoneNumber").text,
            plaid_id: payee_elt.at_xpath("PlaidId").text,
            account_number: payee_elt.at_xpath("LoanAccountNumber").text
          )
        end

        employer = Employer.find_by(name: payor_elt.at_xpath("Name").text)
        if employer.nil?
          employer = Employer.create!(
            name: payor_elt.at_xpath("Name").text,
            dba: payor_elt.at_xpath("DBA").text,
            ein_number: payor_elt.at_xpath("EIN").text,
            address_line_1: payor_elt.at_xpath("Address").at_xpath("Line1").text,
            address_line_2: payor_elt.at_xpath("Address").at_xpath("Line2").text,
            address_city: payor_elt.at_xpath("Address").at_xpath("City").text,
            address_state: payor_elt.at_xpath("Address").at_xpath("State").text,
            address_zip: payor_elt.at_xpath("Address").at_xpath("Zip").text
          )
        end

        payor = Payor.find_by(corporate_id: payor_elt.at_xpath("DunkinId").text)
        if payor.nil?
          payor = Payor.create!(
            corporate_id: payor_elt.at_xpath("DunkinId").text,
            routing_number: payor_elt.at_xpath("ABARouting").text,
            account_number: payor_elt.at_xpath("AccountNumber").text,
            employer: employer
          )
        end

        raw_amount = row.at_xpath("Amount").text
        payment = Payment.create!(
          upload: upload,
          employee: employee,
          payor: payor,
          amount: raw_amount.first == "$" ? raw_amount[1..-1] : raw_amount
        )

        created_payments << payment
      rescue ActiveRecord::RecordInvalid
        # we want to ignore row and NOT create payment if information is invalid
        next
      end

      created_payments
  end
end
