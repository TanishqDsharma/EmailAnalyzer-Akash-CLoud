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



