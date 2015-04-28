# How I Work

*(Or more appropriately, Here's A Simple Automation Sequence with AWS CloudFormation and Chef)*

This is an automation example that deploys simple nginx web node that serves as a reverse proxy to two application nodes. For simplicity sake, the application is actually just some static HTML also served by nginx. (The static HTML is just a mirror of marvel.com's front page.)

# Summary

1. It starts with a Ruby script using the [cloudformation-ruby-dsl](https://github.com/bazaarvoice/cloudformation-ruby-dsl) to produce the CloudFormation template and submit it to the AWS APi.
2. The EC2 nodes will start up and execute a bash script set by CloudFormation template. The bootstrap prepares and executes Chef Solo.
3. Chef Solo configures the system, nginx, and fetches the HTML from GitHub.
4. The CloudFormation template has an [output](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html) of the URL to the web node.

# Details

* The Ruby script looks up the latest [Ubuntu Trusty AMI](https://cloud-images.ubuntu.com/query/trusty/server/released.txt) given a few options (hardcoded into the script as constants) to set the EC2 instances with at the CloudFormation stack's creation time.

* Given that this is a simple example and we aren't deploying service discovery or using pre-defined DNS names, the userdata/bootstrap script writes out a "first-boot" JSON file with Chef attributes. The JSON is actually created dynamically during the CloudFormation stack creation by referencing [CloudFormation resource attributes](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-getatt.html) to get the DNS names of the dynamically created application servers. This means that adding more application servers is as simple as changing the `app` count in the constant `COUNT`

* The userdata/bootstrap script fetches the cookbook from GitHub, installs the [Chef Development Kit](https://downloads.chef.io/chef-dk/) and then uses [Berkshelf](http://berkshelf.com/) to download the dependent cookbooks. It then sets the Chef Solo configuration file and executes Chef Solo.

# Improving the Solution

There are a lot of drawbacks, of course, to this setup. The goal was for it to be a demonstration and not necessarily production ready. But the path to a more manageable configuration isn't too far away ...

* Updating the Chef Cookbook would require fetching the userdata from the metadata URL, writing it to a file and then executing it. (And I'm not 100% sure I have it idempotent.) It might work, but would need some testing. And a nice script to do that manuever.

* A more flexible solution would be to move the logic of the bootstrap into an init script. Then, we could add YAML/JSON data to the userdata field in the CloudFormation phase for the init script to read and personalize for the node (i.e. set the Chef environment and Chef run_list).

* Given that the application server details are passed to Chef via the userdata script AND the nodes are empheral storage instead of EBS, adding application nodes through a CloudFormation update would require it to terminate the web node to update the userdata. That, of course, stops the nodes and the site is then down. However, there are a couple of solutions to this issue:
  1. Using a Chef environment file and pre-determined DNS entries (i.e. app1.domain.com, app2.domain.com, etc.) would allow you to have a long running web node that wouldn't have to be terminated for each update. (This would require some changes to the userdata/bootstrap script.) Then you then you'd have a two step process to scale:
    1. Update and commit the environment file with the "new" DNS names for application servers.
    2. Update the constant in the CloudFormation script to increase the `app` count in the COUNT constant to match.
  2. The second (superior but more comples) solution would be service discovery ... something like [Consul](https://www.consul.io/) and [Consul Templates](https://github.com/hashicorp/consul-template) ... would make this configuration easier to manage. The CloudFormation template could be changed to spin up nodes via an Auto-Scaling Group that would install the Consul client and join together in a cluster. Using Consul Template would allow updating the `upstream` server group in the nginx config and reloading as nodes were added and removed.

# Usage

Prerequisites:

* Git
* Ruby
* Rubygem `cloudformation-ruby-dsl`
* Build tools (i.e. `build-essential`)
* Java and `JAVA_HOME` set properly (The rubygem uses the older CloudFormation CLI which uses Java)
* AWS Account
* AWS KeyPair already loaded
* AWS Access Keys with credentials in a file with the format:
```
AWSAccessKeyId=...
AWSSecretKey=...
```
* Set an environment variable called `AWS_CREDENTIAL_FILE` to the path of the above file. (Also, the file needs to be mode `0600`)

Then run the following commands:

```
git clone https://github.com/harlanbarnes/how-i-work.git
cd how-i-work/cloudformation/
AWS_KEYPAIR_NAME=YOUR_KEYPAIR_NAME ./simple-stack.rb cfn-create-stack simple-stack --region us-east-1
```
