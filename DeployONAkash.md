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
    * AKASH_KEYRING_BACKEND=os

* Check your Account Balance:
  * Run the below command in your terminal to check the account balance:
    * akash query bank balances --node $AKASH_NODE $AKASH_ACCOUNT_ADDRESS

* Create your Configuration:
  * Create a deployment configuration named as deploy.yml in the root directory
```
{
---
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
    
}
```

* Create a certificate:
  * Before you can create a deployment, a certificate must first be created. Your certificate needs to be created only once per account and can be used across all deployments.To     create the certificate run the below command in your terminal:
    * akash tx cert create client --chain-id $AKASH_CHAIN_ID --keyring-backend $AKASH_KEYRING_BACKEND --from $AKASH_KEY_NAME --node $AKASH_NODE --fees 5000uakt
  
  * Above command will generate an ouput like this:
```
{
no certificate found for address akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w. generating new...

{"body":
{"messages":
[{"@type":"/akash.cert.v1beta1.MsgCreateCertificate",
"owner":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w",
"cert":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJ2ekNDQVdXZ0F3SUJBZ0lJRm84a3VKc200YWd3Q2dZSUtvWkl6ajBFQXdJd1NqRTFNRE1HQTFVRUF4TXMKWVd0aGMyZ3hNamxsWVhGMmJUTjFhbk0yTURabE5EZHVZV1ZtTnpjMmN6VjVZekI1T0hadWRUUjNNbmN4RVRBUApCZ1ZuZ1FVQ0JoTUdkakF1TUM0eE1CNFhEVEl4TURjd05qQTNOVGt5TlZvWERUSXlNRGN3TmpBM05Ua3lOVm93ClNqRTFNRE1HQTFVRUF4TXNZV3RoYzJneE1qbGxZWEYyYlROMWFuTTJNRFpsTkRkdVlXVm1OemMyY3pWNVl6QjUKT0hadWRUUjNNbmN4RVRBUEJnVm5nUVVDQmhNR2RqQXVNQzR4TUZrd0V3WUhLb1pJemowQ0FRWUlLb1pJemowRApBUWNEUWdBRWlaZkdqVWNhTDl5YmtYc1pmY256YVNvNWZycm5qV2V1NzVtTlY2OFV1SE5reGlCZStWNTJTZXVrCkM0NG1oRmRBRkdxUlBwbzNqZDBKZHp5cE5tU3N2cU0xTURNd0RnWURWUjBQQVFIL0JBUURBZ1F3TUJNR0ExVWQKSlFRTU1Bb0dDQ3NHQVFVRkJ3TUNNQXdHQTFVZEV3RUIvd1FDTUFBd0NnWUlLb1pJemowRUF3SURTQUF3UlFJZwpNYTFQMEV4ZnpzcmtGWTZUOUNSMlAyakVZR1dRTFdRZHFpQnN6OGM0cUZvQ0lRRFlEUVlIYmlGanh5WUIyRnFiCldZMTFqRlNSUHpwUXRMMmd3eXNsYUZCS1NnPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=",
"pubkey":"LS0tLS1CRUdJTiBFQyBQVUJMSUMgS0VZLS0tLS0KTUZrd0V3WUhLb1pJemowQ0FRWUlLb1pJemowREFRY0RRZ0FFaVpmR2pVY2FMOXlia1hzWmZjbnphU281ZnJybgpqV2V1NzVtTlY2OFV1SE5reGlCZStWNTJTZXVrQzQ0bWhGZEFGR3FSUHBvM2pkMEpkenlwTm1Tc3ZnPT0KLS0tLS1FTkQgRUMgUFVCTElDIEtFWS0tLS0tCg=="}],
"memo":"",
"timeout_height":"0",
"extension_options":[],
"non_critical_extension_options":[]},
"auth_info":{
"signer_infos":[],
"fee":{
"amount":[{"denom":"uakt","amount":"5000"}],
"gas_limit":"200000",
"payer":"",
"granter":""
}
},
"signatures":[]}

confirm transaction before signing and broadcasting [y/N]: y
{"height":"1674650",
"txhash":"CE9C2889E2F04D80E05402927EF01F7C2CBE55FDEDA4C4E71F7E63943A01D122",
"codespace":"","code":0,"data":"0A190A17636572742D6372656174652D6365727469666963617465",
"raw_log":"[{\"events\":[{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"cert-create-certificate\"},{\"key\":\"sender\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"akash17xpfvakm2amg962yls6f84z3kell8c5lazw8j8\"},{\"key\":\"sender\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"amount\",\"value\":\"5000uakt\"}]}]}]","logs":[{"msg_index":0,"log":"","events":[{"type":"message","attributes":[{"key":"action","value":"cert-create-certificate"},{"key":"sender","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"}]},{"type":"transfer","attributes":[{"key":"recipient","value":"akash17xpfvakm2amg962yls6f84z3kell8c5lazw8j8"},{"key":"sender","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},{"key":"amount","value":"5000uakt"}]}]}],"info":"","gas_wanted":"200000","gas_used":"93013","tx":null,"timestamp":""}


 }
 ```  

* Create a Deployment:
  * To create a deployment on akash run:
    * akash tx deployment create deploy.yml --from $AKASH_KEY_NAME --node $AKASH_NODE --chain-id $AKASH_CHAIN_ID --fees 5000uakt -y
```{
{"height":"1762707",
"txhash":"EB9357BD723C9AFDB7163EC7C685D5F5480550E88754527B3AA784744AC8BFF1",
"codespace":"",
"code":0,
"data":"0A130A116372656174652D6465706C6F796D656E74",
"raw_log":"[{\"events\":[{\"type\":\"akash.v1\",\"attributes\":[{\"key\":\"module\",\"value\":\"deployment\"},{\"key\":\"action\",\"value\":\"deployment-created\"},{\"key\":\"version\",\"value\":\"c0982dc13f4c47a4d15ac9306ac69c251d19fbcf47fc2f32edf244d96672c3c2\"},{\"key\":\"owner\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"dseq\",\"value\":\"1762706\"},{\"key\":\"module\",\"value\":\"market\"},{\"key\":\"action\",\"value\":\"order-created\"},{\"key\":\"owner\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"dseq\",\"value\":\"1762706\"},{\"key\":\"gseq\",\"value\":\"1\"},{\"key\":\"oseq\",\"value\":\"1\"}]},{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"create-deployment\"},{\"key\":\"sender\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"sender\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"akash17xpfvakm2amg962yls6f84z3kell8c5lazw8j8\"},{\"key\":\"sender\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"amount\",\"value\":\"5000uakt\"},{\"key\":\"recipient\",\"value\":\"akash14pphss726thpwws3yc458hggufynm9x77l4l2u\"},{\"key\":\"sender\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"amount\",\"value\":\"5000000uakt\"}]}]}]",
"logs":[
{
"msg_index":0,
"log":"",
"events":[
{
"type":"akash.v1","attributes":[
{
"key":"module",
"value":"deployment"
},
{
"key":"action",
"value":"deployment-created"
},
{
"key":"version",
"value":"c0982dc13f4c47a4d15ac9306ac69c251d19fbcf47fc2f32edf244d96672c3c2"},
{
"key":"owner",
"value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},
{
"key":"dseq",
"value":"1762706"},
{
"key":"module",
"value":"market"
},
{
"key":"action",
"value":"order-created"
},
{
"key":"owner",
"value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"
},
{
"key":"dseq",
"value":"1762706"
},
{
"key":"gseq",
"value":"1"
},
{
"key":"oseq",
"value":"1"
}]},
{"type":"message",
"attributes":[
{"key":"action","value":"create-deployment"},{"key":"sender","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},{"key":"sender","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"}]},{"type":"transfer","attributes":[{"key":"recipient","value":"akash17xpfvakm2amg962yls6f84z3kell8c5lazw8j8"},{"key":"sender","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},{"key":"amount","value":"5000uakt"},{"key":"recipient","value":"akash14pphss726thpwws3yc458hggufynm9x77l4l2u"},{"key":"sender","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},{"key":"amount","value":"5000000uakt"}]}]}],"info":"","gas_wanted":"200000","gas_used":"94734","tx":null,"timestamp":""}
}```

* Find your Deployment Sequence








