import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Grommet, Box } from 'grommet';
import { globalGrommetTheme } from '../styles';
import Upload from "./Upload";

const Uploads = (uploads) => {
  console.log(uploads)
  return (
    <Grommet full theme={globalGrommetTheme}>
      <Box direction="column" justify="around" align="center">
        {
          Object.values(uploads).map(upload => (
            <Upload props={upload} key={upload.id} />
          ))
        }
      </Box>
    </Grommet>
  )
}

export default Uploads
