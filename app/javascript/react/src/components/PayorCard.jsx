import React, { useState } from 'react';
import * as ReactDOM from 'react-dom';
import { Box, Card, CardHeader, CardBody, CardFooter, Heading, Tabs, Tab, Text } from 'grommet';
import { CircleInformation, Compass, Atm } from 'grommet-icons';
import { dunkinMagenta, dunkinBrown, dunkinOrange } from "../styles";

const PayorCard = ({ props }) => {
  const activeIconProps = { color: dunkinOrange, background: "dark-1" }
  const [iconProps, setIconProps] = useState([activeIconProps, {}, {}])
  const setActiveIcon = activeIdx => {
    const newProps = [{}, {}, {}]
    newProps[activeIdx] = activeIconProps
    setIconProps(newProps)
  }

  return (
    <Card height="small" width={{ min: "medium", max: "large" }}>
      <CardHeader
        background={dunkinBrown}
        pad="medium"
        height="xxsmall"
      >
        <Heading level="4" pad="small">
          {props.payor_name.join(" ")}
        </Heading>
      </CardHeader>
      <CardBody pad="small">
        <Tabs justify="evenly" onActive={setActiveIcon}>
          <Tab pad="small" title={<Compass {...iconProps[0]} />}>
            <CardBody pad="small">
              <Text>
                {props.payor_address_line_1.join(" ")}
              </Text>

              {props.payor_address_line_2 && (
                <Text>
                  {props.payor_address_line_2.join(" ")}
                </Text>
              )}

              <Text>
                {
                  `${props.payor_address_city}, ${props.payor_address_state} ${props.payor_address_zip}`
                }
              </Text>
            </CardBody>
          </Tab>

          <Tab pad="small" title={<CircleInformation {...iconProps[1]} />}>
            <CardBody pad="small">
              <Text>{props.payor_id}</Text>
            </CardBody>
          </Tab>

          <Tab pad="small" title={<Atm {...iconProps[2]} />}>
            <CardBody pad="small">
              <Text><strong>Routing</strong> {props.payor_routing_number}</Text>
              <Text><strong>Account</strong> {props.payor_account_number}</Text>
            </CardBody>
          </Tab>
        </Tabs>
      </CardBody>

    </Card>
  )
}

export default PayorCard
