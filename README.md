# Load Secret

Basic secret loader, useful for Self Hosted applications.

## Usage

```javascript
import { load } from 'secret-loader';
const value = load('secretName');
```

It will look for the secret in the following order:

1. Environment variable: `process.env.SECRET_${VARIABLE_NAME_UPPERCASE}`
2. SOPS/Docker Secret: `/run/secrets/secretName`

If the secret begins with 'file:', the loader will read the file content at that path and substitute the secret with the file content.