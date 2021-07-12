# Guide To Deploy Your Applications On Akash Cloud

## Pre-Requisites:
* Install Docker on your machine
* Install GO on your Machine
* Install Akash CLI on your machine

# Containerizing Your Application:

For Demonstration Purposes, clone this repo <a  href="https://github.com/TanishqDsharma/EmailAnalyzer-Akash-CLoud.git">Link to Repo</a>

<b>In your Terminal Type:</b>
* git clone https://github.com/TanishqDsharma/EmailAnalyzer-Akash-CLoud.git
* cd EmailAnalyzer-Akash-Cloud

<b>Now,To deploy our application on Akash, we need to first containerize it.</b>
To containerize your application follow the below steps:
* Inside your Application Directory "Create a DockerFile" 
  ```docker
  {
  FROM python:3.8 
  WORKDIR /EmailAnalyzer-Akash-Cloud
  COPY . . 
  RUN pip install -r 
  requirments.txt 
  ENTRYPOINT ["python"] 
  CMD ["EmailInspector-Web.py"] 
  }
  ```  
* To build the image execute the below command:
  ```docker build -t emalianalyzer-akash-cloud . ```
  * <b>Note:</b>In this case I used the image name as emalianalyzer-akash-cloud ,but you can give your own image name.

* To test your image execute the below command
  ```docker run -p 80:80 emailanalyzer-akash-cloud ```
  
## PUSH IMAGE TO DOCKERHUB:

After creating the docker image we need to make it publicly available so that it can be used with Akash Cloud.So, to push the docker image follow the below steps:

* The above command would have created a container id, to view the container id issue the command: <b><b>docker ps -a</b></b> and check the container id corresponding to the image name <b>emailanalyzer-akash-cloud</b>
* docker commit container-id dockerhub-username/image-name
* docker push dockerhub-username/image-name

* NOTE: in place of tanishq512 and emailanalyzer-akash-cloud:1 (you have to use your own dockerhub-username and image-name)

Finally, we are finish with pushing our docker image to dockerhub, now this image is publicly available and can be used by Akash for deployment purposes.

# Deploying Your Application on Akash-Cloud:

After containerizing your application, deploying to Akash simply involves writing small configuration file and executing a couple of commands.Follow the below steps to successfully deploy your application on Akash:

* Create an Account:
  * You can give any name to your wallet in this case I used "TanishqWallet" 
  * akash keys add TanishqWallet
  Read the output and save mnemonic phrase in a safe place.
  * In terminal also set your AKASH_KEY_NAME=TanishqWallet, in your case name could be different.


* Setup your Account Address in the terminal so that we can easily use it later:
  * export AKASH_ACCOUNT_ADDRESS="$(akash keys show TanishqWallet -a)"
  * echo $AKASH_ACCOUNT_ADDRESS

* Fund Your Akash Account:
  * You can buy some AKT tokens from the exchanges like AscendEX, Osmosis, Bitmart. Find the full list of exchanges <a href="https://akash.network/token">here.</a> 

* Connect to the Network":
  * Run the below commands in your terminal to connect yourself to the network:
    * AKASH_NET="https://raw.githubusercontent.com/ovrclk/net/master/mainnet"
    * AKASH_VERSION="$(curl -s "$AKASH_NET/version.txt")"
    * export AKASH_CHAIN_ID="$(curl -s "$AKASH_NET/chain-id.txt")"
    * export AKASH_NODE="$(curl -s "$AKASH_NET/rpc-nodes.txt" | head -1)"
    * echo $AKASH_NODE $AKASH_CHAIN_ID $AKASH_KEYRING_BACKEND

* Check your Account Balance:
  * Run the below command in your terminal to check the account balance:
    * akash query bank balances --node $AKASH_NODE $AKASH_ACCOUNT_ADDRESS

* Create your Configuration:
  * Create a deployment configuration named as deploy.yml in the root directory
    ```{--
version: "2.0"

services:
  web:
    image: tanishq512/tanishq512/emailanalyzer-akash-cloud:1
    expose:
      - port: 5000
        as: 80
        to:
          - global: true
profiles:
  compute:
    web:
      resources:
        cpu:
          units: 0.1
        memory:
          size: 512Mi
        storage:
          size: 512Mi
  placement:
    westcoast:
      attributes:
        host: akash
      signedBy:
        anyOf:
          - "akash1365yvmc4s7awdyj3n2sav7xfx76adc6dnmlx63"
      pricing:
        web: 
          denom: uakt
          amount: 1000

deployment:
  web:
    westcoast:
      profile: web
      count: 1
    
    }```
 







