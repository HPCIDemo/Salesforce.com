# HPCISalesforce App
HostedPCIApp for Salesforce.com SaaS.

#What is it?
HostedPCIApp is an app that will help customers implement the HostedPCI API when they want to use the HostedPCI Web Checkout on top of Salesforce.com platform. The HostedPCIApp is a  tool to help HostedPCI customers visualize the power, potential and how HostedPCI can help them become PCI compliant as affordable as possible and as easy as possible. Our motto is, your vision, our reality. By installing HostedPCIApp you will see what it can do for you, how easy it is to implement it on your eCommerce site and will show you how to do it if you get stuck implementing it.

#How does it work?
The HostedPCIApp has two parts: internal and public facing web site using Force.com Sites.

#Internal
#Payment Terminal :
Payment Terminal Tab is  a HomeTab for HostedPCIApp.

- Salesforce requests a new iframe from HostedPCI.
- HostedPCI verifies the website and webpage are correct.
- HostedPCI sends the iframe to the Salesforce page.
- User fills the payment form and clicks “Submit”.
- Iframe is being sent back to HostedPCI for tokenization of the credit card.
- Token is delivered back to the form and populates all the required hidden fields (CC, CVV and BIN numbers) in the form.
- Form submits payment request with credit card token, cvv token, expiry date and amount.
- HostedPCI submits payment request with real credit card, real cvv, expiry date and amount.
- HostedPCI gets the payment response from the bank.
- HostedPCI sends the response along with other information back to the Salesforce site.
- Salesforec page can then collect the response with all the information and display it back to the user.

#Tokens Tab:
A user can see tokens stored in the database as well related payments.

#Payments:
A user can see  transactions history.

#Call Center:
- Your customer service representative (CSR) will begin the process by gathering the customers order as well the additional information needed.
- Once the customer is ready to enter their credit card information the CSR will then explain to the customer that they are going to make a 3-way call to a secure credit card processing system for them to enter their card number in.
- Click the button “create session” in order to get a session key.
- Call the IVR and enter session key in order to begin session.
- Once the session key is accepted, connect the customer with a 3-way call and ask them to enter their credit card number. 
- The customer will be prompted to enter their card information by the IVR, the difference with our system is that the customer is never separated from the CSR.
- When the customer is finished entering their card information the CSR will end the 3-way call with the IVR and continue with the rest of the call. 
- Once the session is finished a token will pop up on the CSR’s screen which can then be used to finish the transaction. 



#HostedPCI Settings
Used for HostedPCI App configurations.

#Prerequisites
- [Apache Ant](http://ant.apache.org/bindownload.cgi)
- [Java](https://java.com/en/download/)

#Installation
- Download and unzip Salesforce.com.zip file .
- Open build.properties file in path_to_unzipped_file/deploy
- Enter your login credentials for Salesforce.com.If your password is XXX and security Token is 123 then
sf.password = XXX123
```sh
sf.username = your_username
sf.password = your_password
```

#Windows
- Open Command Prompt.
```sh
cd path_to_unzipped_file
cd deploy
ant
```
#Mac
- Open Terminal.
```sh
$cd path_to_unzipped_file
$cd ./deploy
$ant
```
- Login into your Salesforce Org.
- Go to "Setup".
- In the "Administration" panel on the left go to "Manage Users" > "Permission Sets".
- In the "Permission Sets" list on the right click "HostedPCI Developer".
- On the right click "Manage Assignments".
- On the right choose a user(s) you want to assign the app to.A user must have  the permission of using  apps.
- Click "Add Assignments".
- Click "Done".
- In the AppMenu on the top right click "HostedPCI".

#Public web site
#Prerequisites
In order to use public web site ,"Sites" feature have to be enabled in your Salesforce Org.

#Installation
- Login into your Salesforce Org.
- Go to "Setup".
- In the "Administration" panel on the left go to "Develop" > "Sites".
- On the right click "New".
- Enter site details, for the "Active Site Home Page" select "HostedPCIDemo" page.

#Contacts
[HostedPCI Inc.]( http://www.hostedpci.com/) sales@hostedpci.com 1-866-850-3608.
