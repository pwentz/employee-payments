import React, { useState } from 'react';
import * as ReactDOM from 'react-dom';
import { Grommet, Box, Spinner } from 'grommet';
import { globalGrommetTheme } from '../styles';
import Payment from './Payment';
import PaymentsHeader from "./PaymentsHeader"

const Payments = (props) => {
  const { payments, upload_id, upload_status, form_token } = props

  return (
    <Grommet full background="light-3" theme={globalGrommetTheme}>
      <PaymentsHeader
        props={{
          uploadStatus: upload_status,
          uploadId: upload_id,
          formToken: form_token
        }}
      />
      <Box direction="column" justify="between" gap="medium">
        {
          Object.values(payments).map(payment => (
            <Payment props={payment} key={payment.id} />
          ))
        }
      </Box>
    </Grommet>
  );
};
                                        
export default Payments
