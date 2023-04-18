import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Tag, Text } from 'grommet';
import { dunkinOrange } from "../../styles";

const StatusTag = ({ props: { status } }) => {
  const getStatusColor = () => {
    switch(status) {
      case "processing":
        return dunkinOrange
      case "sent":
        return "green"
      case "processed":
        return "green"
      case "failed":
        return "red"
      case "in_progress":
        return dunkinOrange
      case "discarded":
        return "grey"
      case "canceled":
        return "grey"
      case "invalidated":
        return "red"
      default:
        return "dark-1"
    }
  }

  return (
    <Tag background={getStatusColor()} value={
      <Text color="white">{status.split("_").join(" ")}</Text>
    } />
  )
}

export default StatusTag
