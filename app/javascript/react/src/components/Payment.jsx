import React, { useState } from 'react';
import * as ReactDOM from 'react-dom';
import Payor from "./Payor";
import Payee from "./Payee";
import { Box, Heading, Tag } from 'grommet';
import { LinkNext } from 'grommet-icons';
import { dunkinMagenta, dunkinBrown, dunkinOrange } from "../styles";

const Payment = ({ props }) => {
  const activeIconProps = { color: dunkinOrange, background: "dark-1" }
  const [iconProps, setIconProps] = useState([activeIconProps, {}, {}, {}])
  const setActiveIcon = activeIdx => {
    const newProps = [{}, {}, {}, {}]
    newProps[activeIdx] = activeIconProps
    setIconProps(newProps)
  }

  return (
    <Box direction="row" pad="small" justify="evenly">
      <Payor
        props={{
          employerId: props.employer_id,
          employerName: props.employer_name,
          employerEin: props.employer_ein,
          employerAddressLine1: props.employer_address_line_1,
          employerAddressLine2: props.employer_address_line_2,
          employerAddressCity: props.employer_address_city,
          employerAddressState: props.employer_address_state,
          employerAddressZip: props.employer_address_zip,
          routingNumber: props.payor_routing_number,
          accountNumber: props.payor_account_number
        }}
      />

      <Box width="small" direction="column" pad="small" align="center" justify="start">
        <Tag value={props.status.split("_").join(" ")} />
        <Heading size="5">${props.amount}</Heading>
        <LinkNext size="large" color={dunkinOrange} />
      </Box>

      <Payee
        props={{
          employeeId: props.employee_id,
          employeeFirstName: props.employee_first_name,
          employeeLastName: props.employee_last_name,
          employeeBranchId: props.employee_branch_id,
          employeeDob: props.employee_date_of_birth,
          employeePhone: props.employee_phone_number,
          plaidId: props.payee_plaid_id,
          accountNumber: props.payee_account_number
        }}
      />
    </Box>
  );
};

export default Payment
