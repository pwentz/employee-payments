import React, { useState } from 'react';
import * as ReactDOM from 'react-dom';
import { Heading, Grommet, Box, Menu, Text, Spinner } from 'grommet';
import { globalGrommetTheme } from '../styles';
import { Alert, Organization, Atm, Money, DocumentDownload } from 'grommet-icons';
import Upload from "./Upload";
import UploadForm from "./UploadForm";


const Uploads = (props) => {
  const [uploadDataGettingFetched, setUploadDataGettingFetched] = useState({})
  const [uploadDataFetchError, setUploadDataFetchError] = useState({})

  const fetchAndDownload = (pathSuffix, uploadId) => () => {
    setUploadDataGettingFetched({ ...uploadDataGettingFetched, [uploadId]: true })
    fetch(`/uploads/${uploadId}/${pathSuffix}.json`)
      .then(res => res.json())
      .then(payload => {
        if (payload.length === 0) {
          return
        }

        headers = Object.keys(payload[0])
        rows = payload.map(row => headers.map(
          // workaround for whitespace being improperly escaped
          h => row[h] instanceof Array ? row[h].join(" ") : row[h]
        ).join(","))
        raw_csv = [headers.join(","), ...rows].join("\n")

        const blob = new Blob([raw_csv], { type: "text/csv"} )
        const anchor = document.createElement("a")
        const reportName = pathSuffix.split("/")[pathSuffix.split("/").length - 1]
        anchor.setAttribute('href', window.URL.createObjectURL(blob))
        anchor.setAttribute('download', `${reportName}_${uploadId}.csv`)
        anchor.click()
        anchor.remove()
      })
      .catch(e => setUploadDataFetchError({ ...uploadDataFetchError, [uploadId]: e.message }))
      .finally(() => setUploadDataGettingFetched({ ...uploadDataGettingFetched, [uploadId]: false }))
  }

  return (
    <Grommet full theme={globalGrommetTheme}>
      <Box direction="column" justify="around" align="center">
        <Heading level="2">Uploads</Heading>
        <UploadForm props={{ formToken: props.form_token }} />

        {
          Object.values(props.uploads).map(upload => {
            if (uploadDataFetchError[upload.id]) {
              return (
                <Box pad="small" align="center" key={upload.id}>
                  <Alert size="medium" />
                  <Text size="small"><strong>Error getting report for upload #{upload.id}</strong></Text>
                  <Text color="red" size="small">{uploadDataFetchError[upload.id]}</Text>
                </Box>
              )
            }
            else if (uploadDataGettingFetched[upload.id]) {
              return (
                <Box height="xsmall" pad="small" key={upload.id}>
                  <Spinner pad="medium" />
                </Box>
              )
            }
            else {
              return (
                <Box key={upload.id} direction="row" justify="between" align="start" pad={{ top: "medium" }}>
                  <a href={`/uploads/${upload.id}/payments`} style={{ textDecoration: "none", color: "black" }}>
                    <Upload props={upload} />
                  </a>
                  <Menu
                    icon={<DocumentDownload />}
                    items={[
                      {
                        label: <Text>&nbsp; Totals by account</Text>,
                        icon: <Atm />,
                        onClick: fetchAndDownload("reports/payor_totals", upload.id)
                      },
                      {
                        label: <Text>&nbsp; Totals by branch</Text>,
                        icon: <Organization />,
                        onClick: fetchAndDownload("reports/branch_totals", upload.id)
                      },
                      {
                        label: <Text>&nbsp; Payments</Text>,
                        icon: <Money />,
                        onClick: fetchAndDownload("payments", upload.id)
                      }
                    ]}
                  />
                </Box>
              )
            }
          })
        }
    </Box>
    </Grommet>
  )
}

export default Uploads
