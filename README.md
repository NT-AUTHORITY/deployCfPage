# `deployCfPage.ps1`
> A simple powershell script to retry & build the specified project.

## Usage
```powershell
.\deployCfPage.ps1 -apiKey "<Your API Key>" -siteName "<Your Project Name>" -accountId "<Your account ID>"
```
### How to get these params?
#### API Key
1. Open the [Cloudflare Dashboard](https://dash.cloudflare.com).
2. Navigate to Manage Account => Account API Tokens.
   Or just use [this link](https://dash.cloudflare.com/?to=/:account/api-tokens)
3. Click `Create token`.
4. Create a new token with the `Edit Cloudflare Workers` template.
5. Copy your token and store it carefully in your notepad.
#### Site Name
1. Open the [Cloudflare Dashboard](https://dash.cloudflare.com).
2. Navigate to Workers and Pages => <Your project>.  
   Or just use [this link](https://dash.cloudflare.com/?to=/:account/workers-and-pages)
3. Copy the name of the project. For example: `ntblog`.
4. Store it carefully in your notepad.
#### Account ID
1. Open the [Cloudflare Dashboard](https://dash.cloudflare.com).
2. Copy the link in the browser.  
   Example: `https://dash.cloudflare.com/xxxxxxxxxxxxxxxxxxxxxx/home/domains`.
3. Copy the 32-digits ramdom account id and store it in your notepad.  
   Example: `xxxxxxxxxxxxxxxxxxxxxx`.
