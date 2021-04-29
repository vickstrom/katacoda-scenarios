## 1. A server that listens on pull request events 
`pip3 install flask`{{execute interrupt}}

Before telling GitHub, which endpoint we expect the __PUSH event__ to be sent to, we need to start listen on that specific endpoint. To listen, we will make use of the webframework [Flask](https://flask.palletsprojects.com/en/1.1.x/). First, we create a webserver in a file called `server.py` that listens on an arbitrary port, lets say `1337`, and that expects a POST-request on endpoint `/mlops-server`. This is the content: 

<pre class="file" data-filename="server.py" data-target="prepend">
# server.py
from flask import Flask, request

app = Flask(__name__)

@app.route('/mlops-server', methods=['POST'])
def mlops_server_endpoint():
    request_data = request.get_json()
    return 'Awaiting POST'
    
if __name__ == '__main__':
    app.run(debug=False, port=1337)
</pre>

By running `python3 server.py`{{execute interrupt}}, you start the webserver. Now the server awaits a POST request at `???/mlops-server`. The __POST__ request will contain JSON data in its body, which will contain all the data belonging to a pull request event. Lets get GitHub to send us these events to our endpoint.