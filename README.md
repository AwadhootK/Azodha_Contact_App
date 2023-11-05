# Azodha Contact App Assignment

This document serves as a guide and overview for the Azodha Contact App, which has been developed as part of an internship assignment.

## Features and Implementation

The application boasts a suite of features aimed at enhancing the user experience:

- **BLoC State Management**: Ensures a robust flow of data within the app.
- **Clean Folder Structure**: Organizes UI, Business Logic, and Network Logic effectively.
- **Error Handling & Validity Checks**: Guarantees data correctness through comprehensive error handling and form validation.
- **Custom Animations**: Provides smooth, engaging animations.

## Core Functionality

### 1. Contact Form:

This form is a key component of the app, designed to capture essential contact information:

- **Fields**: Name, phone number, email, address, and image.
- **Image Input**:
  - *Image from File*: Converts to base64 and stores in Firestore.
  - *Image from Camera*: Saves to Firebase Cloud Storage and references in Firestore.
  - *Image URL*: Directly stores the provided image URL in Firestore.
- **Image Preview**: Allows users to view the image within the app.

### 2. Contact Details Pages:

These pages showcase the contact information with interactive elements:

- **3D Animated List**: Displays Contact Cards for all users in the database.
- **Interactive Buttons**:
  - *Refresh*: Updates the Contact Cards list.
  - *Add*: Quick navigation to the Contact Form.
- **Card Functions**:
  - *Edit*: Modify contact information.
  - *Delete*: Remove contact from the database.
  - *View*: Detailed information and additional functionalities.

#### Contact Details Enhancements:

- **Phone Number**: Call or send a message directly.
- **Email**: Compose an email with a pre-filled recipient.
- **Address**: View the location on Google Maps.

## App Visuals Reference

1. **Homepage**:

   ![Homepage](https://github.com/AwadhootK/Azodha_Contact_App/assets/100119619/091c00d4-2b83-4443-9461-6f7684e314c1)
   

2. **Contact Cards List Page**:

   ![Contact Cards List](https://github.com/AwadhootK/Azodha_Contact_App/assets/100119619/347ba32e-d396-47da-8bc5-6b9574f87528)
   

3. **Contact Form**:
   
   ![Contact Form](https://github.com/AwadhootK/Azodha_Contact_App/assets/100119619/5e73b3da-807f-448b-bd2c-3a6bdf2d1ab9)
   

4. **Contact Details Page**:
   
   ![Contact Details](https://github.com/AwadhootK/Azodha_Contact_App/assets/100119619/4149e6ee-07dc-45fc-80cc-a72a9c98c637)

   

<h1 style="text-align: center;">Thankyou</h1>
