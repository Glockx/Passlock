# Passlock
Korea University - Graduation Project

# Introduction

The general purpose of the project is creating privacy based mobile application for storing data on mobile devices with encryption and biometric & password authentication.

These are the features included in project:
- All data will be stored on SQLite database on device
-	The database encryption will be done with SQLCipher with 256-bit AES in CBC (Cipher Blocker Chaining) mode
-	The encryption key will be generated automatically and saved in IOS KeyChain API with extra security enclave mechanism of Apple (The Secure Enclave is a hardware-based key manager that’s isolated from the main processor to provide an extra layer of security)
-	The encryption key only accessible from hardware when the biometric authentication successfully done by user. 
-	Master key for recovering encryption key from device. 
-	Export and Importing Stored Data
-	Jailbreak Detection for preventing unauthorized access to Application Files. 
-	Custom Data Templates: Login,Credit Card,Note,Identity(Passport, National Identity Card),Password
-	Auto lock the application if the device on idle mode 
-	Simple User Interface

# Project Report
https://www.dropbox.com/s/6w53jk9vk9ly27s/Graduation%20Project%20-%20Report%20-%20Nijat%20Muzaffarli%20-%20Final.pdf?dl=0
