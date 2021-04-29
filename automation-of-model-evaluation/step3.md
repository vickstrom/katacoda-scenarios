## Register a GitHub App

Now we need to create a GitHub App and install in on our machine learning repository. Why you might ask? 🧐 Webhooks can be configured without an app, however commenting on our pull request requires us to communicate via GitHub. So lets create an App. First navigate to their [app page](https://github.com/settings/apps).

![alt text](./images/add_app.png "create_app")

Click __New GitHub App__.

![alt text](./images/create_app.png "create_app")

<!--We need to specify a name for our app. However, they require you to specify a website. No website? Here we could simply input the __ngrok__ url [http://afae4b0b1670.ngrok.io/](http://afae4b0b1670.ngrok.io/).--> 


We are using the default settings for all the options (_Identifying and authorizing users_, _Post installations_, etc.), expect for the following:

### Webhook
Here, we will input the URL we recieved by __ngrok__ with the added `/mlops-server` extension.

![alt text](./images/create_app_webhook.png "create_app")

### Repository permissions
Tell GitHub, that we need access to every pull-request where we install our App.

![alt text](./images/create_app_perm.png "create_app")

### Subscribe to events
For the webhook, we want to listen to specific request regarding pull-requests. 

![alt text](./images/create_app_subscribe.png "create_app")

### Where to install 
We do not plan to install this everywhere and only for our repo. 

![alt text](./images/create_app_where.png "create_app")

Click create. Voilá, we have our first App. 🥳

![alt text](./images/about_app.png "create_app")

Save the __App ID__ inside `.env`{{open}} after the equals sign. It should look something like this (with your own __App ID__):
```
APP_ID=6329884
```

### Get private key
In the future, we need to authenticate as the app through our server, so generate a private-key! This is found at the bottom of the same page.

![alt text](./images/gene_key.png "create_app")

Download it and copy its content. 

![alt text](./images/save_private_key.png "create_app")
Let's create a file for storing it: `touch private-key.pem`{{execute}}. Copy the contents of the key to that file. Additionally, save the path to the key inside `.env`. Now it should look similar to this: 

```bash
APP_ID=6329884
PRIVATE_KEY_PATH=private-key.pem
```

### Install the app

Scroll up, and click on __Install App__. 

Choose that you want to install the app for one of your repositories. 

![alt text](./images/install_app.png "create_app")

Here, select your machine learning repository. Hopefully, your project name is more exciting that `your-ml-project`.

![alt text](./images/select_ml_repo.png "create_app")

Click on __Install__.

![alt text](./images/installation.png "create_app")

Look 👀 See the installation ID in the url? This ID is used when we want to specify which repository we want to add a comment to. Save that as well.

<pre class="file" data-filename=".env" data-target="append">
INSTALL_ID=92312521
</pre>

Wow, that was a lot of steps.😮‍💨 The good news are that we're done with registrering the GitHub App. Let's continue with our server!