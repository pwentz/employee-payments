import React, { useState } from 'react';
import * as ReactDOM from 'react-dom';
import { Button, Box, Text } from 'grommet';
import { Clipboard } from 'grommet-icons';

const CopiableText = ({ props }) => {
  const [showCopiedTip, setShowCopiedTip] = useState(false)
  return [
    <Text alignSelf="center" truncate={props.truncate || false}>{props.text}</Text>,
    <Box border={{ side: "left" }}>
      <Button
        icon={<Clipboard color="brand" size="medium" />}
        margin={{ right: "xsmall" }}
        tip={showCopiedTip ? "Copied!" : ""}
        onClick={() => {
          navigator.clipboard.writeText(props.text)
          setShowCopiedTip(true)
          setTimeout(() => setShowCopiedTip(false), 700)
        }}
      />
    </Box>
  ]
}

export default CopiableText
