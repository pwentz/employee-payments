import React, { useState } from 'react';
import * as ReactDOM from 'react-dom';
import PayorCard from "./PayorCard";
import { Box, Card, CardHeader, CardBody, CardFooter, Heading, Tabs, Tab, Text } from 'grommet';
import { LinkNext, ContactInfo, CircleInformation, Atm, Tree } from 'grommet-icons';
import { dunkinMagenta, dunkinBrown, dunkinOrange } from "../styles";

const EmployeeCard = ({ props }) => {
  const activeIconProps = { color: dunkinOrange, background: "dark-1" }
  const [iconProps, setIconProps] = useState([activeIconProps, {}, {}, {}])
  const setActiveIcon = activeIdx => {
    const newProps = [{}, {}, {}, {}]
    newProps[activeIdx] = activeIconProps
    setIconProps(newProps)
  }

  return (
    <Card height="small" width="medium">
      <CardHeader
        background={dunkinMagenta}
        pad="medium"
        height="xxsmall"
      >
        <Heading level="4" pad="small">
          {[props.employee_first_name, props.employee_last_name].join(" ")}
        </Heading>
      </CardHeader>

      <CardBody pad="small">
        <Tabs justify="evenly" onActive={setActiveIcon}>

          <Tab pad="small" title={<CircleInformation {...iconProps[0]} />}>
            <CardBody pad="small">
              <Text>{props.employee_id}</Text>
            </CardBody>
          </Tab>

          <Tab pad="small" title={<Tree {...iconProps[1]} />}>
            <CardBody pad="small">
              <Text>{props.employee_branch_id}</Text>
            </CardBody>
          </Tab>

          <Tab pad="small" title={<ContactInfo {...iconProps[2]} />}>
            <CardBody pad="small">
              <Text><strong>DOB</strong> {props.employee_date_of_birth}</Text>
              <Text><strong>Phone</strong> {props.employee_phone_number}</Text>
            </CardBody>
          </Tab>

          <Tab pad="small" title={<Atm {...iconProps[3]} />}>
            <CardBody pad="small">
              <Text><strong>Plaid Id</strong> {props.employee_plaid_id}</Text>
              <Text><strong>Account</strong> {props.employee_account_number}</Text>
            </CardBody>
          </Tab>
        </Tabs>

      </CardBody>
    </Card>
  )
}

export default EmployeeCard
