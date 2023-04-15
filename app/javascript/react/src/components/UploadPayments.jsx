import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Grommet, Box } from 'grommet';
import { globalGrommetTheme } from '../styles';
import UploadPayment from './UploadPayment';

const UploadPayments = (payments) => {
  return (
    <Grommet full theme={globalGrommetTheme}>
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
