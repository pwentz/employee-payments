import React, { useState } from 'react';
import * as ReactDOM from 'react-dom';
import { Card, CardHeader, CardBody, Heading, Tabs, Tab, Text } from 'grommet';
import { ContactInfo, CircleInformation, CreditCard, Organization } from 'grommet-icons';
import CopiableText from "./shared/CopiableText";
import { dunkinMagenta, dunkinOrange } from "../styles";

const Payee = ({ props }) => {
  const activeIconProps = { color: dunkinOrange, background: "dark-1" }
  const [iconProps, setIconProps] = useState([activeIconProps, {}, {}, {}])
  const setActiveIcon = activeIdx => {
    const newProps = [{}, {}, {}, {}]
    newProps[activeIdx] = activeIconProps
    setIconProps(newProps)
  }

  return (
    <Card background="white" elevation="large" height="small" width="medium">
      <CardHeader
        background={dunkinMagenta}
        pad="medium"
        height="xxsmall"
      >
        <Heading level="4" pad="small">
          {[props.employeeFirstName, props.employeeLastName].join(" ")}
        </Heading>
      </CardHeader>

      <CardBody pad="small">
        <Tabs justify="evenly" onActive={setActiveIcon}>

          <Tab pad="small" title={<CircleInformation {...iconProps[0]} />}>
            <CardBody>
              <CopiableText props={{ text: props.employeeId, truncate: "tip" }} />
            </CardBody>
          </Tab>

          <Tab pad="small" title={<Organization {...iconProps[1]} />}>
            <CardBody>
              <CopiableText props={{ text: props.employeeBranchId, truncate: "tip" }} />
            </CardBody>
          </Tab>

          <Tab pad="small" title={<ContactInfo {...iconProps[2]} />}>
            <CardBody pad="small">
              <Text><strong>DOB</strong> {props.employeeDob}</Text>
              <Text><strong>Phone</strong> {props.employeePhone}</Text>
            </CardBody>
          </Tab>

          <Tab pad="small" title={<CreditCard {...iconProps[3]} />}>
            <CardBody pad="small">
              <Text><strong>Plaid Id</strong> {props.plaidId}</Text>
              <Text><strong>Account</strong> {props.accountNumber}</Text>
            </CardBody>
          </Tab>
        </Tabs>

      </CardBody>
    </Card>
  )
}

export default Payee
