import React, { useState } from 'react';
import * as ReactDOM from 'react-dom';
import { Heading, Grommet, Box, Menu, Text } from 'grommet';
import { globalGrommetTheme } from '../styles';
import { Organization, Atm, Money, DocumentDownload } from 'grommet-icons';
import Upload from "./Upload";
import UploadForm from "./UploadForm";


const Uploads = (props) => {
  const linkStyles = {
    textDecoration: 'none',
    color: 'black'
  }
  return (
    <Grommet full theme={globalGrommetTheme}>
      <Box direction="column" justify="around" align="center">
        <Heading level="2">Uploads</Heading>
        <UploadForm props={{ formToken: props.form_token }} />

        {
          Object.values(props.uploads).map(upload => (
            <Box key={upload.id} direction="row" justify="between" align="start" pad={{ top: "medium" }}>
              <a href={`/uploads/${upload.id}/payments`} style={linkStyles}>
                <Upload props={upload} />
              </a>
              <Menu
                icon={<DocumentDownload />}
                items={[
                  {
                    label: <a href={`/uploads/${upload.id}/reports/payor_totals.csv`} style={linkStyles}><Text>&nbsp; Totals by account</Text></a>,
                    icon: <Atm />
                  },
                  {
                    label: <a href={`/uploads/${upload.id}/reports/branch_totals.csv`} style={linkStyles}><Text>&nbsp; Totals by branch</Text></a>,
                    icon: <Organization />
                  },
                  {
                    label: <a href={`/uploads/${upload.id}/payments.csv`} style={linkStyles}><Text>&nbsp; Payments</Text></a>,
                    icon: <Money />
                  }
                ]}
              />
            </Box>
          ))
        }
    </Box>
    </Grommet>
  )
}

export default Uploads
