<div align="center">
<h1> Guide To Deploy Your Application On Akash Cloud </h1>
</div>

Akash is an open source Cloud platform that lets you quickly deploy a Docker container to the Cloud provider of your choice for less than the cost of AWS, right from the command-line.
* Define your Docker image, CPU, Memory, and Storage in a deploy.yaml file.
* Set your price, receive bids from providers in seconds, and select the lowest price.
* Deploy your application without having to set up, configure, or manage servers.
* Scale your application from a single container to hundreds of deployments.

In this guide we will deploy an application on Akash Cloud.

## Pre-Requisites:
* Install Docker on your machine
* Install GO on your Machine
* Install Akash CLI on your machine

# Containerizing Your Application:

<b>For Demonstration Purposes, clone this repo: <a  href="https://github.com/TanishqDsharma/EmailAnalyzer-Akash-CLoud.git">Github repo</a></b>

<b><b>In your Terminal Type:</b></b>
* git clone https://github.com/TanishqDsharma/EmailAnalyzer-Akash-CLoud.git
* cd EmailAnalyzer-Akash-Cloud

<b>Now,To deploy our application on Akash, we need to first containerize it.</b>
<b>To containerize your application follow the below steps:</b>
* Inside your Application Directory <b>"Create a DockerFile"</b> 
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
* <b>To build the image execute the below command:</b>

  ``` docker build -t email-image1:2 .   ```

* <b>Note:</b>In this case I used the image name as emailimage1:2 ,but you can give your own image name.

* <b>To test your image execute the below command</b>
   
   ``` <b> docker run -p 80:80 email-image1:2 </b> ```
  
## PUSH IMAGE TO DOCKERHUB:

After creating the docker image we need to make it publicly available so that it can be used with Akash Cloud.So, to push the docker image follow the below steps:

* The above command would have created a container id, to view the container id issue the command: <b><b>docker ps -a</b></b> and check the container id corresponding to the image name <b>emailimage1:2</b>
* Now Use the below commands to create a new image from exisiting container and push it to the docker hub

```
docker commit container-id tanishq512/email-image1:2
docker push tanishq512/email-image1:2
```

* NOTE: In place of <b>tanishq512</b> and <b><email-image1:2></b>,(you have to use your own dockerhub-username and image-name)

Finally, we are finished with pushing our docker image to dockerhub, now this image is publicly available and can be used by Akash for deployment purposes.

# Deploying Your Application on Akash-Cloud:

After containerizing your application, deploying to Akash simply involves writing small configuration file and executing a couple of commands.Follow the below steps to successfully deploy your application on Akash:

## Create an Account:
  * You can give any name to your wallet in this case I used "TanishqWallet" 
    
    <b>In your terminal type:</b>
    ```
    akash keys add TanishqWallet
    ```
    * Read the output and save mnemonic phrase in a safe place.
  
  * In terminal also set your <b>AKASH_KEY_NAME=TanishqWallet</b>, in your case name could be different.
    
    In terminal execute the below command
    ```
    export AKASH_KEY_NAME=TanishqWallet 
    
    ```


## Setup your Account Address in the terminal so that we can easily use it later:
  * Run the below commands in your terminal:
    * <b>export AKASH_ACCOUNT_ADDRESS="$(akash keys show TanishqWallet -a)"</b>
    * <b>echo $AKASH_ACCOUNT_ADDRESS</b>

## Fund Your Akash Account:
  * You can buy some AKT tokens from the exchanges like AscendEX, Osmosis, Bitmart. Find the full list of exchanges <a href="https://akash.network/token">here.</a> 

## Connect to the Network:
  * <b>Run the below commands one-by-one in your terminal to connect yourself to the network:</b>
    * AKASH_NET="https://raw.githubusercontent.com/ovrclk/net/master/mainnet"
    * AKASH_VERSION="$(curl -s "$AKASH_NET/version.txt")"
    * export AKASH_CHAIN_ID="$(curl -s "$AKASH_NET/chain-id.txt")"
    * export AKASH_NODE="$(curl -s "$AKASH_NET/rpc-nodes.txt" | head -1)"
    * echo $AKASH_NODE $AKASH_CHAIN_ID $AKASH_KEYRING_BACKEND
    * AKASH_KEYRING_BACKEND=os

  ## Check your Account Balance:
  * Run the below command in your terminal to check the account balance:
  
    ``` 
    akash query bank balances --node $AKASH_NODE $AKASH_ACCOUNT_ADDRESS 
    ```

## Create your Configuration:
  * <b>Create a deployment configuration named as deploy.yml in the root directory.</b>
```
---
version: "2.0"

services:
  web:
    image: tanishq512/emailanalyzer-akash-cloud:1
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
```

* Note: Make sure to change the image according to your docker image in deploy.yml file.
  * image: USERNAME/DOCKERIMAGE
  * In our case it is: tanishq512/email-image1:2


## Create a certificate: 
  * Before you can create a deployment, a certificate must first be created. Your certificate needs to be created only once per account and can be used across all deployments.To     create the certificate run the below command in your terminal:
    
  ``` 
  akash tx cert create client --chain-id $AKASH_CHAIN_ID --keyring-backend $AKASH_KEYRING_BACKEND --from $AKASH_KEY_NAME --node $AKASH_NODE --fees 5000uakt
  ```
  
<b>Above command will generate an ouput like this:</b>
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


## Create a Deployment:
  * <b>To create a deployment on akash run:</b>
    ```
    akash tx deployment create deploy.yml --from $AKASH_KEY_NAME --node $AKASH_NODE --chain-id $AKASH_CHAIN_ID --fees 5000uakt -y
    ```
  
<b>Above command will generate an output like this:</b>
 
 ```
 
 {"height":"1787108",
 "txhash":"1D5BB68423E07FCD0C1D087598792C10FF4F7308AF559F9109E994542BD47E83",
 "codespace":"",
 "code":0,
 "data":"0A130A116372656174652D6465706C6F796D656E74",
 "raw_log":"[{\"events\":[{\"type\":\"akash.v1\",\"attributes\":[{\"key\":\"module\",\"value\":\"deployment\"},{\"key\":\"action\",\"value\":\"deployment-created\"},{\"key\":\"version\",\"value\":\"5654919575826d357b7f57846f7542954e11abd0d28a12fcd87ca8a84f427bf7\"},{\"key\":\"owner\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"dseq\",\"value\":\"1787107\"},{\"key\":\"module\",\"value\":\"market\"},{\"key\":\"action\",\"value\":\"order-created\"},{\"key\":\"owner\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"dseq\",\"value\":\"1787107\"},{\"key\":\"gseq\",\"value\":\"1\"},{\"key\":\"oseq\",\"value\":\"1\"}]},{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"create-deployment\"},{\"key\":\"sender\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"sender\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"akash17xpfvakm2amg962yls6f84z3kell8c5lazw8j8\"},{\"key\":\"sender\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"amount\",\"value\":\"5000uakt\"},{\"key\":\"recipient\",\"value\":\"akash14pphss726thpwws3yc458hggufynm9x77l4l2u\"},{\"key\":\"sender\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"amount\",\"value\":\"5000000uakt\"}]}]}]",
 "logs":[
 {"msg_index":0,
 "log":"",
 "events":[
 {"type":"akash.v1",
 "attributes":[
 {"key":"module","value":"deployment"},{"key":"action","value":"deployment-created"},{"key":"version","value":"5654919575826d357b7f57846f7542954e11abd0d28a12fcd87ca8a84f427bf7"},{"key":"owner","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},{"key":"dseq","value":"1787107"},{"key":"module","value":"market"},{"key":"action","value":"order-created"},{"key":"owner","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},{"key":"dseq","value":"1787107"},{"key":"gseq","value":"1"},{"key":"oseq","value":"1"}]},{"type":"message","attributes":[{"key":"action","value":"create-deployment"},{"key":"sender","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},{"key":"sender","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"}]},{"type":"transfer","attributes":[{"key":"recipient","value":"akash17xpfvakm2amg962yls6f84z3kell8c5lazw8j8"},{"key":"sender","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},{"key":"amount","value":"5000uakt"},{"key":"recipient","value":"akash14pphss726thpwws3yc458hggufynm9x77l4l2u"},{"key":"sender","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},{"key":"amount","value":"5000000uakt"}]}]}],"info":"","gas_wanted":"200000","gas_used":"94734","tx":null,"timestamp":""}

 
 ```

## Find your Deployment Sequence:
  * From the above output we need the values of DSEQ,GSEQ and OSEQ.After extracting the values from above output set the me to shell variables
    * AKASH_DSEQ = 1787107  
    * AKASH_GSEQ = 1
    * AKASH_OSEQ = 1

## Verify deployment is open:
   ```
   akash query deployment get --owner $AKASH_ACCOUNT_ADDRESS --node $AKASH_NODE --dseq $AKASH_DSEQ
  ```

 <b>The above command will genrate an output like below:</b>
 
  ```
 {
deployment:
  created_at: "1787108"
  deployment_id:
    dseq: "1787107"
    owner: akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w
  state: active
  version: VlSRlXWCbTV7f1eEb3VClU4Rq9DSihL82HyoqE9Ce/c=
escrow_account:
  balance:
    amount: "5000000"
    denom: uakt
  id:
    scope: deployment
    xid: akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w/1787107
  owner: akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w
  settled_at: "1787108"
  state: open
  transferred:
    amount: "0"
    denom: uakt
groups:
- created_at: "1787108"
  group_id:
    dseq: "1787107"
    gseq: 1
    owner: akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w
  group_spec:
    name: westcoast
    requirements:
      attributes:
      - key: host
        value: akash
      signed_by:
        all_of: []
        any_of:
        - akash1365yvmc4s7awdyj3n2sav7xfx76adc6dnmlx63
    resources:
    - count: 1
      price:
        amount: "1000"
        denom: uakt
      resources:
        cpu:
          attributes: []
          units:
            val: "100"
        endpoints:
        - kind: SHARED_HTTP
        memory:
          attributes: []
          quantity:
            val: "536870912"
        storage:
          attributes: []
          quantity:
            val: "536870912"
  state: open


 }
 ```


## Verify Order is Open: 
  * <b>To verify the order run the below command in your terminal:</b>
        
    
    ```
    akash query market order get --node $AKASH_NODE --owner $AKASH_ACCOUNT_ADDRESS --dseq $AKASH_DSEQ --oseq $AKASH_OSEQ --gseq $AKASH_GSEQ
    ```

 <b>The above command will generate an output like this:</b>
  
 ```
 {
 created_at: "1787108"
order_id:
  dseq: "1787107"
  gseq: 1
  oseq: 1
  owner: akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w
spec:
  name: westcoast
  requirements:
    attributes:
    - key: host
      value: akash
    signed_by:
      all_of: []
      any_of:
      - akash1365yvmc4s7awdyj3n2sav7xfx76adc6dnmlx63
  resources:
  - count: 1
    price:
      amount: "1000"
      denom: uakt
    resources:
      cpu:
        attributes: []
        units:
          val: "100"
      endpoints:
      - kind: SHARED_HTTP
      memory:
        attributes: []
        quantity:
          val: "536870912"
      storage:
        attributes: []
        quantity:
          val: "536870912"
state: open

 
 ```

## View your Bids:
  * <b>After a short time, you should see bids from providers for this deployment with the following command:</b>  
  
    ```   
    akash query market bid list --owner=$AKASH_ACCOUNT_ADDRESS --node $AKASH_NODE --dseq $AKASH_DSEQ
    ```

 <b> The above command will generate an output like this:</b>
  
 ```
 bids:
- bid:
    bid_id:
      dseq: "1787107"
      gseq: 1
      oseq: 1
      owner: akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w
      provider: akash10cl5rm0cqnpj45knzakpa4cnvn5amzwp4lhcal
    created_at: "1787109"
    price:
      amount: "1"
      denom: uakt
    state: open
  escrow_account:
    balance:
      amount: "50000000"
      denom: uakt
    id:
      scope: bid
      xid: akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w/1787107/1/1/akash10cl5rm0cqnpj45knzakpa4cnvn5amzwp4lhcal
    owner: akash10cl5rm0cqnpj45knzakpa4cnvn5amzwp4lhcal
    settled_at: "1787109"
    state: open
    transferred:
      amount: "0"
      denom: uakt
- bid:
    bid_id:
      dseq: "1787107"
      gseq: 1
      oseq: 1
      owner: akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w
      provider: akash1f6gmtjpx4r8qda9nxjwq26fp5mcjyqmaq5m6j7
    created_at: "1787109"
    price:
      amount: "2"
      denom: uakt
    state: open
  escrow_account:
    balance:
      amount: "50000000"
      denom: uakt
    id:
      scope: bid
      xid: akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w/1787107/1/1/akash1f6gmtjpx4r8qda9nxjwq26fp5mcjyqmaq5m6j7
    owner: akash1f6gmtjpx4r8qda9nxjwq26fp5mcjyqmaq5m6j7
    settled_at: "1787109"
    state: open
    transferred:
      amount: "0"
      denom: uakt
pagination:
  next_key: null
  total: "0" 
 ```
## Choose a provider from the above the output:
   * Note that there are bids from multiple different providers. In this case, both providers happen to be willing to accept a price of 1 uAKT. This means that the lease can be created using 1 uAKT or 0.000001 AKT per block to execute the container.
   * For this example, we will choose akash10cl5rm0cqnpj45knzakpa4cnvn5amzwp4lhca
   * In your terminal run: 
     
      ```
      AKASH_PROVIDER=akash10cl5rm0cqnpj45knzakpa4cnvn5amzwp4lhcal
     ```
   * To verify the AKASH_PROVIDER, run the below  command:
     ```
     echo $AKASH_PROVIDER
     ```

## Create a lease:
      ```
      akash tx market lease create --chain-id $AKASH_CHAIN_ID --node $AKASH_NODE --owner $AKASH_ACCOUNT_ADDRESS --dseq $AKASH_DSEQ --gseq $AKASH_GSEQ --oseq $AKASH_OSEQ --   provider $AKASH_PROVIDER --from $AKASH_KEY_NAME --fees 5000uakt
      ```
 
 <b>The above command will generate an output like below</b>
  
 ```
 {"body":
 {"messages":[
 {"@type":"/akash.market.v1beta1.MsgCreateLease",
 "bid_id":{"owner":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w",
 "dseq":"1787107",
 "gseq":1,
 "oseq":1,
 "provider":"akash10cl5rm0cqnpj45knzakpa4cnvn5amzwp4lhcal"}
 }],"memo":"","timeout_height":"0","extension_options":[],"non_critical_extension_options":[]},"auth_info":{"signer_infos":[],"fee":{"amount":[{"denom":"uakt","amount":"5000"}],"gas_limit":"200000","payer":"","granter":""}},"signatures":[]}

confirm transaction before signing and broadcasting [y/N]: y
{"height":"1787148",
"txhash":"0FD232290E24B40339FD1E5492A3AE628041E81553C164073FC03A2D3229121C",
"codespace":"",
"code":0,
"data":"0A0E0A0C6372656174652D6C65617365",
"raw_log":"[{\"events\":[{\"type\":\"akash.v1\",\"attributes\":[{\"key\":\"module\",\"value\":\"market\"},{\"key\":\"action\",\"value\":\"lease-created\"},{\"key\":\"owner\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"dseq\",\"value\":\"1787107\"},{\"key\":\"gseq\",\"value\":\"1\"},{\"key\":\"oseq\",\"value\":\"1\"},{\"key\":\"provider\",\"value\":\"akash10cl5rm0cqnpj45knzakpa4cnvn5amzwp4lhcal\"},{\"key\":\"price-denom\",\"value\":\"uakt\"},{\"key\":\"price-amount\",\"value\":\"1\"}]},{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"create-lease\"},{\"key\":\"sender\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"sender\",\"value\":\"akash14pphss726thpwws3yc458hggufynm9x77l4l2u\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"akash17xpfvakm2amg962yls6f84z3kell8c5lazw8j8\"},{\"key\":\"sender\",\"value\":\"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w\"},{\"key\":\"amount\",\"value\":\"5000uakt\"},{\"key\":\"recipient\",\"value\":\"akash1f6gmtjpx4r8qda9nxjwq26fp5mcjyqmaq5m6j7\"},{\"key\":\"sender\",\"value\":\"akash14pphss726thpwws3yc458hggufynm9x77l4l2u\"},{\"key\":\"amount\",\"value\":\"50000000uakt\"}]}]}]",
"logs":[{"msg_index":0,"log":"","events":[{"type":"akash.v1","attributes":[{"key":"module","value":"market"},{"key":"action","value":"lease-created"},{"key":"owner","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},{"key":"dseq","value":"1787107"},{"key":"gseq","value":"1"},{"key":"oseq","value":"1"},{"key":"provider","value":"akash10cl5rm0cqnpj45knzakpa4cnvn5amzwp4lhcal"},{"key":"price-denom","value":"uakt"},{"key":"price-amount","value":"1"}]},{"type":"message","attributes":[{"key":"action","value":"create-lease"},{"key":"sender","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},{"key":"sender","value":"akash14pphss726thpwws3yc458hggufynm9x77l4l2u"}]},{"type":"transfer","attributes":[{"key":"recipient","value":"akash17xpfvakm2amg962yls6f84z3kell8c5lazw8j8"},{"key":"sender","value":"akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w"},{"key":"amount","value":"5000uakt"},{"key":"recipient","value":"akash1f6gmtjpx4r8qda9nxjwq26fp5mcjyqmaq5m6j7"},{"key":"sender","value":"akash14pphss726thpwws3yc458hggufynm9x77l4l2u"},{"key":"amount","value":"50000000uakt"}]}]}],"info":"","gas_wanted":"200000","gas_used":"131381","tx":null,"timestamp":""}
                                                                                                                                                                                 
 ```
 
 ### Confirm the lease:
      ```
      akash query market lease list --owner $AKASH_ACCOUNT_ADDRESS --node $AKASH_NODE --dseq $AKASH_DSEQ
      ```
<b> The above command will generate an ouput like below:</b>
```
leases:
- escrow_payment:
    account_id:
      scope: deployment
      xid: akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w/1787107
    balance:
      amount: "0"
      denom: uakt
    owner: akash10cl5rm0cqnpj45knzakpa4cnvn5amzwp4lhcal
    payment_id: 1/1/akash10cl5rm0cqnpj45knzakpa4cnvn5amzwp4lhcal
    rate:
      amount: "1"
      denom: uakt
    state: open
    withdrawn:
      amount: "0"
      denom: uakt
  lease:
    created_at: "1787148"
    lease_id:
      dseq: "1787107"
      gseq: 1
      oseq: 1
      owner: akash129eaqvm3ujs606e47naef776s5yc0y8vnu4w2w
      provider: akash10cl5rm0cqnpj45knzakpa4cnvn5amzwp4lhcal
    price:
      amount: "1"
      denom: uakt
    state: active
pagination:
  next_key: null
  total: "0"

```
### Send the Manifest:
     ``` 
     akash provider send-manifest deploy.yml --node $AKASH_NODE --dseq $AKASH_DSEQ --provider $AKASH_PROVIDER --home ~/.akash --from $AKASH_KEY_NAME
     ```
<b>Note: The above command will not generate any output.</b>
  
## Confirm the URL:
  * Now that the manifest is uploaded, your image is deployed. You can retrieve the access details by running the below:
  
   ```
   akash provider lease-status --node $AKASH_NODE --home ~/.akash --dseq $AKASH_DSEQ --from $AKASH_KEY_NAME --provider $AKASH_PROVIDER
   ```

<b>The above command will generate an output like below:</b> 

```
{
  "services": {
    "web": {
      "name": "web",
      "available": 1,
      "total": 1,
      "uris": [
        "jc0ga52s0lbt7293rpgq7s96ao.ingress.sjc1p0.mainnet.akashian.io"
      ],
      "observed_generation": 1,
      "replicas": 1,
      "updated_replicas": 1,
      "ready_replicas": 1,
      "available_replicas": 1
    }
  },
  "forwarded_ports": {}
}  
```

* <b>Since we got the URL from the above result, we can access the application at:</b>
  
  ```
  http://jc0ga52s0lbt7293rpgq7s96ao.ingress.sjc1p0.mainnet.akashian.io/
  ```



# Conclusion:
  * I have successfully deployed my application on akash just by following the above steps
  * <b>My application link: </b>http://jc0ga52s0lbt7293rpgq7s96ao.ingress.sjc1p0.mainnet.akashian.io/



