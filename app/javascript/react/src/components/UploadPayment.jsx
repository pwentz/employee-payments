import React, { useState } from 'react';
import * as ReactDOM from 'react-dom';
import PayorCard from "./PayorCard";
import EmployeeCard from "./EmployeeCard";
import { Box, Card, CardHeader, CardBody, CardFooter, Heading, Tabs, Tab, Text } from 'grommet';
import { LinkNext, ContactInfo, CircleInformation, Atm, Tree } from 'grommet-icons';
import { dunkinMagenta, dunkinBrown, dunkinOrange } from "../styles";

const UploadPayment = ({ props }) => {
  const activeIconProps = { color: dunkinOrange, background: "dark-1" }
  const [iconProps, setIconProps] = useState([activeIconProps, {}, {}, {}])
  const setActiveIcon = activeIdx => {
    const newProps = [{}, {}, {}, {}]
    newProps[activeIdx] = activeIconProps
    setIconProps(newProps)
  }

  return (
    <Box direction="row" pad="small" justify="evenly">
      <PayorCard props={props} />

      <Box width="small" direction="column" pad="small" align="center" justify="start">
        <Heading size="5">${props.amount}</Heading>
        <LinkNext size="large" color={dunkinOrange} />
      </Box>

      <EmployeeCard props={props} />
    </Box>
  );
};

export default UploadPayment
