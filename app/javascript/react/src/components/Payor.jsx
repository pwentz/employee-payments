import React, { useState } from 'react';
import * as ReactDOM from 'react-dom';
import { Card, CardHeader, CardBody, Heading, Tabs, Tab, Text } from 'grommet';
import { Clipboard, CircleInformation, MapLocation, CreditCard } from 'grommet-icons';
import { dunkinBrown, dunkinOrange } from "../styles";
import CopiableText from "./shared/CopiableText"

const PayorCard = ({ props }) => {
  const activeIconProps = { color: dunkinOrange, background: "dark-1" }
  const [iconProps, setIconProps] = useState([activeIconProps, {}, {}])
  const setActiveIcon = activeIdx => {
    const newProps = [{}, {}, {}]
    newProps[activeIdx] = activeIconProps
    setIconProps(newProps)
  }

  return (
    <Card height="small" width="medium">
      <CardHeader
        background={dunkinBrown}
        pad="medium"
        height="xxsmall"
      >
        <Heading level="4" pad="small">
          {props.employerName.join(" ")}
        </Heading>
        <Text>{props.employerEin}</Text>
      </CardHeader>
      <CardBody pad="small">
        <Tabs justify="evenly" onActive={setActiveIcon}>
          <Tab pad="small" title={<MapLocation {...iconProps[0]} />}>
            <CardBody pad="small" justify="center">
              <Text>
                {props.employerAddressLine1.join(" ")}
              </Text>

              {props.employerAddressLine2 && (
                <Text>
                  {props.employerAddressLine2.join(" ")}
                </Text>
              )}

              <Text>
                {
                  `${props.employerAddressCity}, ${props.employerAddressState} ${props.employerAddressZip}`
                }
              </Text>
            </CardBody>
          </Tab>

          <Tab pad="small" title={<CircleInformation {...iconProps[1]} />}>
            <CardBody>
              <CopiableText props={{ text: props.employerId, truncate: "tip" }} />
            </CardBody>
          </Tab>

          <Tab pad="small" title={<CreditCard {...iconProps[2]} />}>
            <CardBody pad="small">
              <Text><strong>Routing</strong> {props.routingNumber}</Text>
              <Text><strong>Account</strong> {props.accountNumber}</Text>
            </CardBody>
          </Tab>
        </Tabs>
      </CardBody>

    </Card>
  )
}

export default PayorCard
