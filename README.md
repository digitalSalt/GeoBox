# GeoBox
File-sharing application that enables users to manage shared files based on geolocation.

## 1.        Introduction
### 1.1        Purpose
Enable users to manage shared files based on geolocation.

### 1.2        Intended Audience
All users who want to manage shared files based on geolocation.

### 1.3        Product Scope
Main functions includes file search, upload and download. To be developed features: sharing rooms and file open. Users can login as guest, normal users, or admins to gain access to the application. 

File will be automatically deleleted after they expires. Uploaders or room owners also have permission to delete their files.

### 1.4		Minimal Viable Product
Have files popped up when users walk into the vicinity of share file location.

### 1.5		Competitors
Any file-sharing solutions: Box, Dropbox, Google Drive, etc.
Whisper: allows users to share media (mostly text) with limits based on geolocation.  

## 2.        Overall Description
### 2.1        Product Functions
When two users are within a (User Controlled) radius of each other, they share files based on their geolocation range. Suppose we have users a, b, c, d; when a is in vicinity of the rest of the group and user a has just shared a file, users b, c, d, can have access to the file user a has shared. Users a, b, c, d do not have any other connection besides the fact they are within each other’s radius.  

Users in the above case connect to each other via “rooms” or another mechanism. Each “room” could have a secret key. Each “room” has a coordinates property. Users interact with other users via uploading/downloading files in the same “room”

“Rooms” are automatically discovered when the room comes within the User’s “radius”
### 2.2       User Classes and Characteristics (Stories)
#### Admin Gods
**Characteristics:**
 
Admins are super users only reserved to be developers for the app. Admins can ban users when inappropriate behaviour is found.

Admins can see all users (not passwords), all rooms, and all files. 
Have permission to delete / modify users rooms and files.

**Stories:**  

Steve is an employee of GeoBox and is part of the anti-harassment team which is     responsible to make sure no malicious or offensive content lingers on the app.  
 	
Steve logs into the app. Steve has special views to the database (complete view). Steve can check on the new users who made an account and the new rooms that are created, as well as which files have been added and can also view all rooms and files just like standard users. Steve can also check for suspicious behaviour - for example in the afternoon, Steve notices that user John is sharing malicious files. Steve decides to delete user John from the database or send him an warning. 
#### Login Users
**Characteristics:**

Login Users are logged in users that can create and get content at any given location. Logged in users have names and can be identified by anyone using the app. 

**Stories:**

Logged in user logs into the app. After providing geolocation info, he/she can create content for that location. If there is content from that location, he/she can download that content. 
#### Anonymous Monkeys
**Characteristics:**

Users that have no need to login, but in exchange do not have the ability to “drop” files.

**Stories:**
	
Anonymous monkeys hit a skip button to bypass login page and are presented with a map with files, but can only see files and cannot edit them.
Bobby is going to a symposium on how rails is the future of web development. The organisers tell the guests that they have all requisite symposium files on “Geobox”. Bobby loads geobox.xyz and sees a login page. He also sees a “skip” button which he presses. A map with his location and several “file” icons appears. Opening a sidebar reveals the files he needs.

## 3.        External Interface Requirements
### 3.1        User Interfaces
Responsive Design - should look good on phones as well as large screens
Majority of Screen is the map, the user position is indicated on the map.
File/Rooms could also be shown on the map, or not (decide later)
