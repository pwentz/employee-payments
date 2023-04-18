import React, { useState } from 'react';
import * as ReactDOM from 'react-dom';
import Payor from "./Payor";
import Payee from "./Payee";
import { Box, Heading, Text } from 'grommet';
import { LinkNext } from 'grommet-icons';
import { dunkinMagenta, dunkinBrown, dunkinOrange } from "../styles";
import StatusTag from "./shared/StatusTag"

const Payment = ({ props }) => {
  const activeIconProps = { color: dunkinOrange, background: "dark-1" }
  const [iconProps, setIconProps] = useState([activeIconProps, {}, {}, {}])
  const setActiveIcon = activeIdx => {
    const newProps = [{}, {}, {}, {}]
    newProps[activeIdx] = activeIconProps
    setIconProps(newProps)
  }
  const getStatusColor = () => {
    switch(props.status) {
      case "processing":
        return dunkinOrange
      case "canceled":
        return "grey"
      case "sent":
        return "green"
      case "failed":
        return "red"
      case "invalidated":
        return "red"
      default:
        return "grey"
    }
  }

  const [dollars, cents] = String(props.amount).split(".")

  return (
    <Box width="xlarge" alignSelf="center" direction="row" pad="small" justify="evenly" border={{ size: "xsmall", side: "bottom" }}>
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

      <Box width="small" direction="column" pad="small" align="center">
        <StatusTag props={{ status: props.status }} />
        <Heading size="5">
          ${[dollars, cents.padEnd(2, "0")].join(".")}
        </Heading>
        <LinkNext size="large" color={getStatusColor()} />
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
