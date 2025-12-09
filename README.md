# AWS for Lambda checking

`~/.aws/config`

```ini
[sso-session kism]
sso_start_url = https://d-9767bc2ecf.awsapps.com/start#/
sso_region = ap-southeast-2
sso_registration_scopes = sso:account:access
[profile kism]
sso_session = kism
sso_account_id = 471112518165
sso_role_name = AdministratorAccess
region = ap-southeast-2
```
