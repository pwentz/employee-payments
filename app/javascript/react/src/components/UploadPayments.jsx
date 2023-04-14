import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Grommet, Box } from 'grommet';
import UploadPayment from './UploadPayment';

const theme = {
  global: {
    font: {
      family: "Roboto",
      size: "18px",
      height: "20px",
    },
  },
};

const UploadPayments = (payments) => {
  return (
    <Grommet full theme={theme}>
      <Box direction="column" justify="evenly">
      {
        Object.values(payments).map(payment => (
          <UploadPayment props={payment} key={payment.id} />
        ))
      }
      </Box>
    </Grommet>
  );
};
                                        
export default UploadPayments
