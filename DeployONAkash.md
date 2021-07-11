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
  ```
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
  ``` docker build -t emalianalyzer-akash-cloud .```
  * Note:In this case I used the image name as emalianalyzer-akash-cloud ,but you can give your own.

