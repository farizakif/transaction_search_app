
## What the app does

- Collects search filters for transactions, including date range, MID (required), and optional identifiers.
- Validates inputs (length and numeric checks) before sending a request.
- Generates an auth token from MID, TID, beneficiary account, and the merchant key.
- Sends a JSON report request to the configured API endpoint.
- Displays results in a scrollable list and shows a full detail sheet per transaction.
- Handles empty results and API errors with clear UI states.


## Configuration

API settings are defined in [lib/config/api_config.dart]

- `baseUrl`: API endpoint for report requests
- `merchantKey`: Used to generate the auth token
- `opName`, `reportType`, `channel`: Included in the request payload
- `dateFormat`: API date format
- `requestTimeout`: HTTP timeout
- The HTTP client currently accepts all certificates. 