import React, { useState } from 'react';
import * as ReactDOM from 'react-dom';
import { Box, FileInput } from 'grommet';
import { globalGrommetTheme } from '../styles';

const UploadForm = ({ props }) => {
  const [selectedFile, setSelectedFile] = useState(null)

  return (
    <Box pad={{ top: "medium", bottom: "medium" }} direction="row" width="large">
      <form encType="multipart/form-data" action="/uploads" method="POST">
        <input name="authenticity_token" value={props.formToken} type="hidden" />
        <input type="submit" style={{ display: "none" }} />

        <FileInput
          alignSelf="start"
          width="medium"
          pad={{ left: "small" }}
          name="upload[xml]"
          id="upload_xml"
          multiple={false}
          messages={{
            browse: "upload XML",
            dropPrompt: "Drop or"
          }}
          onChange={e =>
            e.target.files[0] && document.querySelector("input[type='submit']").click()
          }
        />
      </form>
    </Box>
  )
}

export default UploadForm
