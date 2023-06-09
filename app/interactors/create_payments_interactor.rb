class CreatePaymentsInteractor
  def self.run(xml_rows)
    upload = Upload.create

    xml_rows.each do |row|
      employee_elt = row.at_xpath("Employee")
      payor_elt = row.at_xpath("Payor")
      payee_elt = row.at_xpath("Payee")
      raw_amount = row.at_xpath("Amount")&.text
      next if [employee_elt, payor_elt, payee_elt, raw_amount].any?(&:nil?)

      employee = Employee.find_by(corporate_id: employee_elt.at_xpath("DunkinId")&.text)
      if employee.nil?
        dob = employee_elt.at_xpath("DOB")&.text
        formatted_dob = dob && Date.strptime(dob, "%m-%d-%Y")
        employee = Employee.create!(
          corporate_id: employee_elt.at_xpath("DunkinId")&.text,
          branch_id: employee_elt.at_xpath("DunkinBranch")&.text,
          first_name: employee_elt.at_xpath("FirstName")&.text,
          last_name: employee_elt.at_xpath("LastName")&.text,
          date_of_birth: formatted_dob,
          # must use this phone for receiving funds permission
          phone_number: "5121231111"
          # phone_number: employee_elt.at_xpath("PhoneNumber")&.text
        )
      end

      payee = Payee.find_by(account_number: payee_elt.at_xpath("LoanAccountNumber")&.text)
      if payee.nil?
        payee = Payee.create!(
          plaid_id: payee_elt.at_xpath("PlaidId")&.text,
          account_number: payee_elt.at_xpath("LoanAccountNumber")&.text,
          employee: employee
        )
      end

      employer = Employer.find_by(name: payor_elt.at_xpath("Name")&.text)
      if employer.nil?
        employer = Employer.create!(
          name: payor_elt.at_xpath("Name")&.text,
          dba: payor_elt.at_xpath("DBA")&.text,
          ein_number: payor_elt.at_xpath("EIN")&.text,
          address_line_1: payor_elt.at_xpath("Address")&.at_xpath("Line1")&.text,
          address_line_2: payor_elt.at_xpath("Address")&.at_xpath("Line2")&.text,
          address_city: payor_elt.at_xpath("Address")&.at_xpath("City")&.text,
          address_state: payor_elt.at_xpath("Address")&.at_xpath("State")&.text,
          address_zip: payor_elt.at_xpath("Address")&.at_xpath("Zip")&.text
        )
      end

      payor = Payor.find_by(corporate_id: payor_elt.at_xpath("DunkinId")&.text)
      if payor.nil?
        payor = Payor.create!(
          corporate_id: payor_elt.at_xpath("DunkinId")&.text,
          routing_number: payor_elt.at_xpath("ABARouting")&.text,
          account_number: payor_elt.at_xpath("AccountNumber")&.text,
          employer: employer
        )
      end

      payment = Payment.create!(
        upload: upload,
        payee: payee,
        payor: payor,
        amount: raw_amount.first == "$" ? raw_amount[1..-1] : raw_amount
      )
    rescue ActiveRecord::RecordInvalid
      # we want to ignore row and NOT create payment if row is invalid or malformed
      next
    end

    upload.id
  end
end
