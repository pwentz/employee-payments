import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Heading, Box, Button } from 'grommet';

const PaymentsHeader = ({ props }) => {
  const handleSubmit = (statusToDelete) => (e) => {
    if (statusToDelete === "4" && !confirm("Are you sure? This process cannot be undone.")) {
      return e.preventDefault()
    }
    document.querySelector(`input[value='${statusToDelete}']`).remove()
  }

  return (
    <form action={`/uploads/${props.uploadId}`} method="POST">
      <input type="hidden" name="_method" value="put" />
      <input type="hidden" name="authenticity_token" value={props.formToken} />
      <input type="hidden" name="upload[status]" id="upload_status" value="1" />
      <input type="hidden" name="upload[status]" id="upload_status" value="4" />

      <Box direction="column" justify="center" align="center" pad="large">
        <Heading level="2">{props.uploadStatus === "pending" ? "Review " : ""}Payments</Heading>
        {props.uploadStatus === "pending" && (
          <Box direction="row" width="medium" justify="between">
            <Button primary type="submit" label="process payments" onClick={handleSubmit("4")} />
            <Button secondary type="submit" label="discard" onClick={handleSubmit("1")} />
          </Box>
        )}
      </Box>
    </form>
  )
}

export default PaymentsHeader
