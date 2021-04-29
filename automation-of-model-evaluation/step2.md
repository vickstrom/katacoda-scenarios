## Storing environment variables
Communicating with an API requires authenication and IDs specific to your project. The various keys and IDs we will collect in the coming parts should __not__ be uploaded to any public repository. We will handle these by a creating an environment file called `.env`. 
`touch .env`{{execute interrupt}}

The data we need to store there is the __app ID__, the __install ID__, and the path to the __private key__.  

```bash
# .env
APP_ID=<OUR APP ID>
PRIVATE_KEY_PATH=<OUR PATH TO PRIVATE KEY>
INSTALL_ID=<OUR INSTALL ID>
```

As said above, these will be filled in later. To then access these variables, we will make use of the `os` & `dotenv` module. Let's install `dotenv` (`os` is standard to python)      

`pip3 install python-dotenv`{{execute interrupt}}

Then add these to `server.py`{{open}}

<pre class="file">
# ...
import os
from dotenv import load_dotenv

load_dotenv()

INSTALL_ID = os.getenv('INSTALL_ID')
APP_ID = os.getenv('APP_ID')
PRIVATE_KEY_PATH = os.getenv('PRIVATE_KEY_PATH')

# ...
</pre> 