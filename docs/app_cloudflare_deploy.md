# Deploying the app in the web using Cloudflare Pages

## 1. Prepare Github Actions for Deployment
Make sure your GitHub repository has a configured GitHub Actions workflow that triggers on every push to the ```main``` branch for the ```web/**``` and ```lib/**``` directories. The provided workflow automates the process.
## 3. Build the Web App
Use the ```flutter build web -t lib/main.dart``` command in the workflow to build the app for the web.
## 2. Store and Deploy
- Archive the web build artifact and download it in the ```deploy``` step.
- Deploy to Cloudflare Pages using the ```cloudflare/pages-action@v1``` with the required Cloudflare credentials (```apiToken```, ```accountId```, and ```projectName```).

Now, everytime you push to the ```main``` branch, the app will automatically deploy to Clouflare Pages.