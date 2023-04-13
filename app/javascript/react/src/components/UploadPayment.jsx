import * as React from 'react';
import * as ReactDOM from 'react-dom';

const UploadPayment = ({ props }) => {
  return (
    <li>
      <div style={{ display: 'flex', flexDirection: 'row', justifyContent: 'space-evenly' }}>
        <div>
          <h3>{props.payor_name.join(" ")}</h3>
          <ul>
            <li>ID: {props.payor_id}</li>
            <li>Routing: {props.payor_routing_number}</li>
            <li>Account: {props.payor_account_number}</li>
          </ul>
        </div>

        <div>
          <p>${props.amount}</p>
          <p> ⟶   </p>
        </div>

        <div>
          <h3>{props.employee_first_name} {props.employee_last_name}</h3>
          <ul>
            <li>ID: {props.employee_id}</li>
            <li>Branch: {props.employee_branch_id}</li>
            <li>Account: {props.employee_account_number}</li>
          </ul>
        </div>
      </div>
      <hr></hr>
    </li>
  );
};

export default UploadPayment
