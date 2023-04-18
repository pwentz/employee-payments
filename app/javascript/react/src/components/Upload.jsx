import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Menu, Text, Box, Card, CardHeader, CardBody } from 'grommet';
import { DocumentTime, DocumentVerified, DocumentMissing } from 'grommet-icons';
import { dunkinMagenta, dunkinBrown, dunkinOrange } from "../styles";
import StatusTag from "./shared/StatusTag"

const Upload = ({ props }) => {
  const [Icon, bgColor] = {
    "pending": [DocumentTime, dunkinBrown],
    "in_progress": [DocumentTime, dunkinOrange],
    "processed": [DocumentVerified, "green"],
    "failed": [DocumentMissing, "red"],
    "discarded": [DocumentMissing, "grey"]
  }[props.status];

  return (
    <Card background="white" elevation="large" height="xsmall" width="large" direction="row" justify="around" align="center">
      <Box pad="medium">
        <Icon size="large" color={bgColor} />
      </Box>

      <Box>
        <CardHeader>
          <StatusTag props={{ status: props.status }} />
        </CardHeader>

        <CardBody pad={{ top: "small" }}>
          <Text alignSelf="center" size="small"><strong>payments</strong> {props.payments}</Text>
        </CardBody>
      </Box>

      <Box>
        {["processed", "failed", "discarded", "in_progress"].includes(props.status) && (
          <CardHeader>
            <Text size="small" color={bgColor}>
              <strong>{props.status.split("_").join(" ")}</strong> {[props.updated_at_time.join(" "), props.updated_at_date.join(" ")].join(" ")}
            </Text>
          </CardHeader>
        )}

        <CardBody pad={{ top: "small" }}>
          <Text size="small"><strong>uploaded</strong> {[props.created_at_time.join(" "), props.created_at_date.join(" ")].join(" ")}</Text>
        </CardBody>
      </Box>
    </Card>
  )
}

export default Upload
