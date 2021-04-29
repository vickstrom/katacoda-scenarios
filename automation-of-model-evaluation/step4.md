## Evaluating our Pull Requests 

Okay, now we have our server that tells us when someone has created a pull request and we have a model. Let's combine the two; train & evaluate the model when someone has created a pull request!

The plan is to have the server clone the repository, checkout the latest commit, install all the dependencies, evaluate the model against the base. To do this, we can run shell-commands via Python. To do this, we utilize the module subprocess and the method run(). First, we clone and change the folder name to an arbitrary string project_dst, with the help of module uuid; the reason for this is to avoid collisions with folders that already exist. Next, we checkout a specific version of the cloned repository (with cwd we change our current directory inside the project_dst folder). Then, we install the dependencies of the machine learning project, and test the model expecting a result.txt. For future pull requests, we can't use the same cloned directory, so we move the directory to the wastebasket ️️

First, import module subprocess.
<pre class="file" data-filename="server.py" data-target="prepend">
import subprocess 
</pre>

Then add the evaluate pull request function.
<pre class="file">
# ...
def evaluate_pull_request(commit_sha, ssh_url):
    project_dst =  uuid.uuid4().hex
    subprocess.run(["git", "clone", ssh_url, project_dst])
    subprocess.run(["git", "checkout", commit_sha], cwd=f"./{project_dst}")
    subprocess.run(["pip", "install", "-r", f"{project_dst}/requirements.txt"])
    subprocess.run(["python3", f"{project_dst}/ml/demo.py"])
    subprocess.run(["rm", "-rf", project_dst])
    
    with open(f"result.txt", "r") as f:
        return json.load(f) 
# ...
</pre>

What data from the pull request do we need? Well, we need the ssh_url of the repository in order to clone it and then commit_sha in order to checkout the latest changes. Note that we need the ssh_url and commit_sha of both the head and base as we want to compare the changes. Additionally, we need the comments_url to have our application comment the results on the pull request. Let's create two utility functions for this and add this to `server.py`:

<pre class="file">
# ...
def get_commits(data):
    return data["pull_request"]["head"]["sha"], \
           data["pull_request"]["base"]["sha"]

def get_urls(data):
    return data["pull_request"]["comments_url"], \
           data["pull_request"]["head"]["repo"]["ssh_url"], \
           data["pull_request"]["base"]["repo"]["ssh_url"] 
# ...
</pre>

We also need to specify when this could be run. For instance, if we just made a pull request that updated documentation or similar, we don't need to run all of this testing as the model hasn't been changed. To solve this, we will create a label in our repository which is treated as a flag for letting our server know when to evaluate it. We will call this label evaluate. This also means that we need to create some form of validation function that asserts if it's a valid response intended for testing and comparing the model. In the case of GitHub webhooks, we want to listen of the labeled action for a pull_request. We also need to see if it contains our label.

<pre class="file">
# ...
def is_valid_response(data):
    is_valid = False
    keys = data.keys()
    if 'pull_request' in keys and 'action' in keys:
        if data['action'] != 'labeled':
             return False 
        
        for label in data['pull_request']['labels']:
            if 'evaluate' == label['name']: # 'evaluate' corresponds to said label
                is_valid = True 

    return is_valid  
# ...
</pre>

Now, let's glue everything together inside `mlops_server_endpoint()`.

<pre class="file">
# ...
@app.route('/mlops-server', methods=['POST'])
def mlops_server_endpoint():
    response = request.get_json()

    if is_valid_response(response):
        sha_head, sha_base = get_commits(response)
        comments_url, url_head, url_base = get_urls(response)

        head_result = evaluate_pull_request(sha_head, url_head)
        base_result = evaluate_pull_request(sha_base, url_base)

        # TODO: send comment with results to pull request

    return 'Awaiting POST' 
# ...
</pre>