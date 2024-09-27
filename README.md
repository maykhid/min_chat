## MinChat💬
<p float="">
  <img src= "https://github.com/maykhid/min_chat/blob/main/screenshots/header.png?raw=true" />
</p>

A MINimalist chat application.

Leave a star⭐️ if you like what you see.

Contributions are highly welcome!

<a href="https://drive.google.com/file/d/18sy49tN9OuTGA6b2BSEyy3HHYSuPOQOI/view?usp=sharing"><img src="https://playerzon.com/asset/download.png" width="200"></img></a>

## 🖼 Screenshots
| ![Auth Image](https://github.com/maykhid/min_chat/blob/main/screenshots/auth.png?raw=true) | ![No Chat Image](https://github.com/maykhid/min_chat/blob/main/screenshots/no_chat.png?raw=true) | ![Start Conversation Image](https://github.com/maykhid/min_chat/blob/main/screenshots/start_conversation.png?raw=true) |
|---|---|---|
| ![Messages Image](https://github.com/maykhid/min_chat/blob/main/screenshots/messages.png?raw=true) | ![Chat Voice Modal Image](https://github.com/maykhid/min_chat/blob/main/screenshots/chat_voice_modal.png?raw=true) | ![Chat Image](https://github.com/maykhid/min_chat/blob/main/screenshots/chat.png?raw=true) |


## 💫 Features
* Basic p2p chat
* Voice message
* Group chat 
## Todo
* Block user
* Media sharing like Images, Video (Still under consideration)

## ✨ Requirements
* Any Operating System (ie. MacOS X, Linux, Windows)
* IDE of choice with Flutter SDK installed (ie. IntelliJ, Android Studio, VSCode etc)
* Knowledge of Dart and Flutter

## ⚙️ Setup
1. Clone the project.

2. Configure FlutterFire.

    * Set up FirebaseCLI if you haven't already, [here](https://firebase.google.com/docs/cli#setup_update_cli)
    
    * Navigate to your project's root directory in the terminal and run:
    
      ```flutterfire configure --project=<your-firebase-project-name>```
    
    * Replace ```<your-firebase-project-name>``` with the actual name of your Firebase project. 
    
    * Follow the prompts to select platforms and provide any necessary credentials.

    After completing the setup, please make sure your google_services.json, GoogleService-Info.plist and firebase_options.dart files are generated.
    
3.  Make sure the following are enabled on your Firebase project
    * Authentication
    * Firestore Database - (For more info on the database model or structure read [this](https://medium.com/@henryifebunandu/cloud-firestore-db-structure-for-your-chat-application-64ec77a9f9c0) )
    * Storage
  
Troubleshooting:

If you have any issues, please consult the FlutterFire documentation to check the issues or create a new one. 

## ⚙️ How to use
MinChat is simple to use. 

To begin a normal conversation (p2p chat), you must have the recipient's mID or the email they used during registration (You can find your mID on the user page which can be found when you click the user profile picture). Click the floating action button to show an expanded floating action button, select the user icon enter the user's mID or email address and press `OK`.

To begin a group chat/conversation, the group participants you can add are people you have started a regular chat (p2p chat) with (You cannot add any participants if you haven't any persons you chat with). Click the floating action button to show expanded floating action buttons, and select the group icon, a list of people you started a conversation with is shown, select the ones to add to the group then press `Start Conversation`, then you're prompted to enter a desired name for this group.

## ⚖️ Licences
This project is licensed under the Creative Commons Attribution 4.0 International License. You may distribute, remix, tweak, and build upon this work, even commercially, as long as you credit the original author.

**For more information, please see:** https://creativecommons.org/licenses/by/4.0/


## ✍️ Author
Henry Ifebunandu
