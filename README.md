# Email Analyzer: An open, decentralized Security Tool

Link to app hosted on Akash : <a href="http://jc0ga52s0lbt7293rpgq7s96ao.ingress.sjc1p0.mainnet.akashian.io/">EmailAnalyzer</a> 
Guide to deploy your application on Akash : <a href=" https://github.com/TanishqDsharma/EmailAnalyzer-Akash-CLoud/blob/main/Guide_to_Deploy_your_Application_on_Akash.md">DeploymentGuide</a>

# Introduction

Email Header Analysis is a web based project developed with the aim of investigating emails to distinguish malicious emails from genuine ones.

In today’s scenario where everything is going on in online mode and the main mode of communication is through emails, it becomes very difficult to identify fake/phishing emails and because of this the amount of fake/phishing email attacks have increased drastically. Employees with no knowledge about cyber security are the most vulnerable to such attacks and pose a major security concern to their organizations.

Therefore having a solution to identify such emails with just one click would be a great help to society.

# Features of the EmailAnalyzer Tool:

This app will analyze your email data for you to by which you will know that the email sent to you is genuine or not.This app analyze your email data on the basis of email headers,it looks for the email headers which helps to determine the user that the email is genuine or fake.

<b>By using this the user can:</b>
 1) <b>Identify hop delays</b>
 2) <b>Identify basic information about the email which includes (Subject, Messag-ID, to, From):</b>
     * Subject:This header will tell you subject of the email
     * Message-ID:This header is a unique identifier for a digital message.Message-IDs are required to have a specific format which is a subset of an email address and be globally unique. No two different messages must ever have the same Message-ID.
     * To : This header tell you that whom the email is sent to
     * From: This header will tell who sent the email
  
 3) <b>Identify all the received headers:</b>
     * Received header's:The received is the most important part of the email header and is usually the most reliable. They form a list of all the servers/computers through which the message traveled in order to reach you. The received lines are best read from bottom to top.
     * Since its is best to read this header from bottom to top, the tool captures each received header and divide them into the category of Top-most, middle-most and bottom-most received header. This help the user to quickly view the path from which the email travelled.

 4) <b>Identify all the security related headers which includes(Received-SPF,  DKIM-Signature, Return-path, Message-ID):</b>
 
    * Received-SPF : SPF is used to describe what mail server is allowed to send messages for a domain. It's used to avoid fake email addresses (as sender email address). The system can detect if the mail server, which wants to send a message to the recipients mail-exchanger, is valid for the senders email address (domain).If this header results "PASS" then there is a high possiblity that the email is from a geniune source.
    
    * DKIM-Signature: This header makes sure that integrity of your email is maintained.
    * Return-path : is a hidden email header that indicates where and how bounced emails will be processed.If Return-path and Message-id has somewhat identical domains at the end then we can say that the email is from a genuine source.
 
 5) <b>Identify all other additonal headers of an email</b>

# EmailAnalyzer Usage:

1) Go to your gmail account and choose the email you want to analyze:
   
   ![alt text](https://github.com/TanishqDsharma/EmailAnalyzer-Akash-CLoud/blob/main/screenshots/1%20-%20Gmail.png)

2) After selecting the email you want to analyze , click on the "3 dot option" and click on "show original meassage"
   
   ![alt text](https://github.com/TanishqDsharma/EmailAnalyzer-Akash-CLoud/blob/main/screenshots/2.png)

3) Click on copy to clipboard and navigate to the <a href="http://jc0ga52s0lbt7293rpgq7s96ao.ingress.sjc1p0.mainnet.akashian.io/"> EmailAnalyzerApp</a>
    
    ![alt text](https://github.com/TanishqDsharma/EmailAnalyzer-Akash-CLoud/blob/main/screenshots/3.png) 

4) Now paste your email data in text area
   
   ![alt text](https://github.com/TanishqDsharma/EmailAnalyzer-Akash-CLoud/blob/main/screenshots/4.png)

5) After pasting your email data in text area filed,Click on "Analyze it" button and you will get your email data Analyzed.
   
   ![alt text](https://github.com/TanishqDsharma/EmailAnalyzer-Akash-CLoud/blob/main/screenshots/5.png)
   
   ![alt text](https://github.com/TanishqDsharma/EmailAnalyzer-Akash-CLoud/blob/main/screenshots/6.png)

   
   
   
   


 
