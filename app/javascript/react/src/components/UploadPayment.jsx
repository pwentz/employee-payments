import * as React from 'react';
import * as ReactDOM from 'react-dom';

const UploadPayment = ({ props }) => {
  return (
    <li>
      Payment#{props.id}: ${props.amount}
    </li>
  );
};

export default UploadPayment
