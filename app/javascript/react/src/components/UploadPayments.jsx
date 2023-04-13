import * as React from 'react';
import * as ReactDOM from 'react-dom';
import UploadPayment from './UploadPayment';

const UploadPayments = (payments) => {
  return (
    <div>
      Payments
      <ul style={{ listStyleType: 'none' }}>
      {
        Object.values(payments).map(payment => (
          <UploadPayment props={payment} key={payment.id} />
        ))
      }
      </ul>
    </div>
  );
};
                                        
export default UploadPayments
