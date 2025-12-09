# Deploying Overleaf CE on Railway

Use Railway to run Overleaf CE with Mongo + Redis + a Web container built from this repository. The Web filesystem is ephemeral, so all project data must live in Mongo. Railway free/trial can sleep or be stopped when over quota, so back up regularly.

## Files in this repository
- `examples/railway/Dockerfile` updates the Overleaf nginx config to listen on the `$PORT` provided by Railway.
- `examples/railway/railway.env.example` lists the environment variables you need to set in Railway.

## Prerequisites
- A Railway account with a new Project.
- GitHub repo containing this toolkit plus the files above (this repository layout works).

## Steps
1. **Create services**
   - Add Mongo: `New → Database → MongoDB`. Note the internal URL (user/pass/host/port).
   - Add Redis: `New → Redis`. Note host/port/password (from `REDIS_URL`).
2. **Add the Web service**
   - `New → GitHub Repo` → pick this repo. Railway builds `examples/railway/Dockerfile`.
3. **Set environment variables** (Web service)
   - **Important**: Overleaf CE 5.0+ uses `OVERLEAF_` prefix (not `SHARELATEX_`).
   - `OVERLEAF_MONGO_URL`: Railway Mongo URL, e.g. `mongodb://user:pass@host:port/sharelatex`.
   - `OVERLEAF_REDIS_HOST`, `OVERLEAF_REDIS_PORT`, `OVERLEAF_REDIS_PASSWORD` (if set).
   - `OVERLEAF_SITE_URL`: public Railway URL (e.g. `https://<app>.up.railway.app`). Update after first deploy, then redeploy.
   - `OVERLEAF_APP_NAME`, `OVERLEAF_ADMIN_EMAIL`.
   - SMTP (recommended for invites): `OVERLEAF_EMAIL_FROM_ADDRESS`, `OVERLEAF_SMTP_HOST`, `OVERLEAF_SMTP_PORT` (587), `OVERLEAF_SMTP_USER`, `OVERLEAF_SMTP_PASS`, `OVERLEAF_SMTP_SSL=false`, `OVERLEAF_SMTP_TLS=true`.
   - Optional: `OVERLEAF_MAX_UPLOAD_SIZE=50mb`.
4. **Deploy**
   - Railway builds the image and starts the Web service. Check Logs to confirm nginx is listening on `$PORT`.
5. **Create admin**
   - Open the Railway URL, register the first account → becomes admin.
6. **Backups**
   - Mongo holds all projects. From a shell with access to Mongo (e.g. local machine using the provided URI):
     ```sh
     mongodump --uri "$OVERLEAF_MONGO_URL" --archive=backup.archive
     ```
   - Store the archive securely; Railway free services can be reclaimed.

## Notes and limitations
- Web filesystem is temporary; do not store files there. Only Mongo (and Redis for sessions) persist.
- Free tier may sleep or stop; expect downtime if idle or over quota.
- Railway domains include HTTPS by default; custom domains can be added in the Domains tab (certs are automatic).
- Keep projects small (limited RAM/CPU); large LaTeX builds may time out. Monitor Logs. 

