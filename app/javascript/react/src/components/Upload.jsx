import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Menu, Text, Tag, Box, Card, CardHeader, CardBody } from 'grommet';
import { DocumentTime, DocumentVerified, DocumentMissing } from 'grommet-icons';
import { dunkinMagenta, dunkinBrown, dunkinOrange } from "../styles";

const Upload = ({ props }) => {
  const [Icon, bgColor] = {
    "pending": [DocumentTime, dunkinBrown],
    "in_progress": [DocumentTime, dunkinOrange],
    "processed": [DocumentVerified, "green"],
    "failed": [DocumentMissing, "red"],
    "discarded": [DocumentMissing, "grey"]
  }[props.status];

  return (
    <Card height="xsmall" width="large" direction="row" justify="around" align="center">
      <Box pad="medium">
        <Icon size="large" color={bgColor} />
      </Box>

      <Box>
        <CardHeader>
          <Tag value={props.status} size="small" color={bgColor} />
        </CardHeader>

        <CardBody pad={{ top: "small" }}>
          <Text size="small"><strong>Payments</strong> {props.payments}</Text>
        </CardBody>
      </Box>

      <Box>
        {props.status === "processed" && (
          <CardHeader>
            <Text size="small" color="green">
              <strong>Processed</strong> {[props.processed_at_time.join(" "), props.processed_at_date.join(" ")].join(" ")}
            </Text>
          </CardHeader>
        )}

        <CardBody pad={{ top: "small" }}>
          <Text size="small"><strong>Uploaded</strong> {[props.uploaded_at_time.join(" "), props.uploaded_at_date.join(" ")].join(" ")}</Text>
        </CardBody>
      </Box>
    </Card>
  )
}

export default Upload
