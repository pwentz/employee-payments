import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Grommet, Box } from 'grommet';
import { globalGrommetTheme } from '../styles';
import Payment from './Payment';

const Payments = (payments) => {
  return (
    <Grommet full theme={globalGrommetTheme}>
      <Box direction="column" justify="evenly">
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
