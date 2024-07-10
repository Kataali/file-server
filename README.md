# File Server
This a file server project that AmaliTech assigned to prospective National Service Personnels as part of their NSS pre-preselection program.
## The server is supposed to have the following features:
### For Users:
- User signup with email and password with verification.
- User login. 
- Password reset.
- File download.
- Send files to an email address.
- Search the server for files.

### For the Admin:
- Upload files with a title and a description.
- See the number of downloads and the number of emails sent for each file

## Using Express with node.js and a Postgres database, I have been able to implement all the above and the following additional functionalities:
### For Users:
- Update password
- Logout
- Delete account
### For the Admin:
- Login with a password
- Update password
- Logout

### The server is live on render at [https://dashboard.render.com/web/srv-cq6hhaaju9rs73e7ut6g/deploys/dep-cq6o1rbgbbvc73auipsg]

## The Client App
I also wrote a client web app with Flutter Web to interact with the server and demonstrate all these features
### The Link to the Flutter application is [https://github.com/Kataali/file_server_client]
### The web app is live at https://amali-file-server.netlify.app
