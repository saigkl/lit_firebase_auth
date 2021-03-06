<p align="center"><img src="https://raw.githubusercontent.com/funwithflutter/lit_firebase_auth/master/assets/lit.png" height="125" alt="Lit Firebase"></p>

<h1 align="center" style="margin-top: 0px; font-size: 4em;">Lit Firebase Auth</h1>

<b>⚠️ Attention: This package is at an early stage. A lot of features are missing. Eventually this package will be "lit", but for now, use at your own risk.</b>

Pre-lit Firebase authentication. It provides a set of convenient utilities and widgets to easily add Firebase authentication to a Flutter app.


## Features

- **Multiple platform support**
  - Works on mobile (Android/iOS) and web. No changes needed
  - Windows, macOS and Linux to be added in the future
- **Multiple authentication providers**
  - Package supported: Google, Apple, Twitter and Github
  - Please see [Authentication Providers](#authentication-providers) for additional information
- **Services and state managed for you**
  - Easily interact with Firebase from anywhere in your app
  - Monitor the auth state and react to changes
- **Error handling and error messages**
  - Built in error handling that will display friendly in-app error messages
  - Error/Success dialogs can be customized
- **Highly customizable**
  - Either use the standard sign-in widgets, or create your own.

## Getting started

See the [example](example/) project to get up and running fast.

Or take a look at a [live demo](https://funwithflutter.github.io/lit_firebase_example/).

## Platform Configuration
<details>
<summary>...</summary>

### Android integration

Enable the Google services by configuring the Gradle scripts as such.

1. Add the classpath to the `[project]/android/build.gradle` file.
```gradle
dependencies {
  // Example existing classpath
  classpath 'com.android.tools.build:gradle:3.2.1'
  // Add the google services classpath
  classpath 'com.google.gms:google-services:4.3.0'
}
```

2. Add the apply plugin to the `[project]/android/app/build.gradle` file.
```gradle
// ADD THIS AT THE BOTTOM
apply plugin: 'com.google.gms.google-services'
```

*Note:* If this section is not completed you will get an error like this:
```
java.lang.IllegalStateException:
Default FirebaseApp is not initialized in this process [package name].
Make sure to call FirebaseApp.initializeApp(Context) first.
```

*Note:* When you are debugging on android, use a device or AVD with Google Play services.
Otherwise you will not be able to authenticate.

### Web integration

You'll need to modify the `web/index.html` of your app following the Firebase setup instructions:

* [Add Firebase to your JavaScript project](https://firebase.google.com/docs/web/setup#from-the-cdn).

Read more in the [`firebase_auth_web` README](https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_auth/firebase_auth_web/README.md).

Below is an example of a Flutter Web `index.html` with Firebase Auth enabled:

```html
...
<body>

  <!-- GOOGLE SignIn Client ID -->
  <meta name="google-signin-client_id" content="ADD-YOUR-CLIENT-ID.apps.googleusercontent.com">

  <!-- The core Firebase JS SDK is always required and must be listed first -->
  <script src="https://www.gstatic.com/firebasejs/7.15.5/firebase-app.js"></script>
  <script src="https://www.gstatic.com/firebasejs/7.15.5/firebase-auth.js"></script>

  <!-- TODO: Add SDKs for Firebase products that you want to use
     https://firebase.google.com/docs/web/setup#available-libraries -->

  <script>
    // Your web app's Firebase configuration
    var firebaseConfig = {
      ...// ADD CONFIG HERE
    };
    // Initialize Firebase
    firebase.initializeApp(firebaseConfig);
  </script>

  <!-- CONTINUE TO INITIALIZE FLUTTER WEB -->
  ...
```
</details>

## Usage
The two most important widgets are 
- `LitAuthInit` - which initializes the package and exposes the services that will be used in your application.
- `LitAuth` - which renders the UI (forms, buttons and dialogs).

### Lit Firebase Initialization
First, you need to initialize the package with `LitAuthInit`. This should be at the root of your application. Above `MaterialApp`/`CupertinoApp`, and above any widgets that want to access authentication functionality.

For example:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Needs to be above [MaterialApp]/[CupertinoApp]
    return LitAuthInit(
      // specify which auth providers to enable
      authProviders: AuthProviders(
        emailAndPassword: true, // enabled by default
        google: true,
        apple: true,
        twitter: true,
        github: true,
        anonymous: true,
      ),
      child: MaterialApp(
        title: 'Material App',
        home: Home(),
      ),
    );
  }
}
```

### Standard Sign-in widget
You can either create your own custom sign-in widget, or make use of the standard built in one.
To use the standard sign-in form with no changes:

```dart
LitAuth();
```

This will use the default configuration and UI theming.

<p align="left"><img src="https://user-images.githubusercontent.com/45597490/88035376-3ee01200-cb6c-11ea-8076-782b9f424e7e.jpg" height="200" alt="Lit Firebase"></p>

See the section on [decoration and theming](#decoration-and-theming) for customization.

**NOTE**: This widget needs to be a child of a `Scaffold` widget.

### Handle auth state changes
To determine the current auth state, make use of `LitAuthState`:

```dart
class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LitAuthState(
        authenticated: () => Text('Authenticated'), // Login widget, or sign in button
        unauthenticated: () => Text('Not Authenticated'), // Authenticated widget, or sign out button
      ),
    );
  }
}
```
### Auth success and failure
You can provide optional callbacks in `LitAuth` to handle success and failure when performing sign-in.

```dart
return LitAuth(
  onAuthFailure: (failure) {
    print('Auth failed.'); // show error message
  },
  onAuthSuccess: () {
    print('Auth success.'); // navigate to new screen
  },
);
```
**NOTE**: these handlers will not be called if `LitAuth` is already disposed.

For example, if you were to wrap this `LitAuth` in `LitAuthState`, such as:
```dart
return LitAuthState(
  authenticated: () =>
      Text('Authenticated'), // Login widget, or sign in button
  unauthenticated: () => LitAuth(
    onAuthFailure: (failure) {
      print('Auth failed.'); // show error message
    },
    onAuthSuccess: () {
      print('Auth success.'); // will not be called
    },
  ),
);
```
Then in this instance the `onAuthSuccess` handler may not be called. As the `authenticated` state will be triggered and the `LitAuth` widget disposed.

### Sign out
To sign out the current user, make use of the `signOut` extension method on `BuildContext`. For example:
```dart
RaisedButton(
  onPressed: () {
    context.signOut();
  },
  child: Text('Sign out'),
);
```

### Get current user
Get the current signed-in user:
```dart
final user = context.getSignedInUser()
```

### Watch user for changes
Watches the `User` object for changes.
```dart
final user = context.watchSignedInUser()
```
Should only be used in the build method.

### Determine if submitting is active
 Whether Lit Firebase is currently attempting to authenticate. Can be used to show a loading indicator.

 Should only be used in the build method. For example:

 ```dart
 Widget build(BuildContext context) {
   final isSubmitting = context.isSubmitting();
   return Visibility(
     visible: isSubmitting,
     child: CircularProgressIndicator(),
   );
 }
 ```

## Authentication Providers

The supported third-party providers are:
* Google
* Apple
* Github
* Twitter

**NOTE:** Apple requires Apple sign in to be enabled if any other third-party sign-in option is used.

These need to be enabled in the `LitAuthInit` widget.
```dart
LitAuthInit(
  // specify which auth providers to enable
  authProviders: AuthProviders(
    emailAndPassword: true, // enabled by default
    google: true,
    apple: true,
    twitter: true,
    github: true,
    anonymous: true,
  ),
  child: MaterialApp(
    title: 'Material App',
    home: Home(),
  ),
);
```

To initiate authentication with one of these providers, call the relevant method. For example:

```dart
FlatButton(
  onPressed: () {
    context.signInWithGithub();
  },
  child: Text('Github Sign In'),
),
```

Other identity providers (for example, Facebook) will need to be implemented separately. After successful third party sign in you can sign in to Firebase by making use of the `signInWithCredential` method available on `BuildContext`.

For example:

```dart
 Widget build(BuildContext context) {
   AuthCredential credential = // get credential for identity provider (Facebook, etc.)
   context.signInWithCredential(credential);
 }
 ```

## Decoration and theming
The UI can be as customizable as you need. But for simple usage it's fairly straight forward.

It's easy to provide custom decoration/configuration for the sign-in elements. You can either customize the elements of the standard sign-in widget, or create an entirely custom sign-in widget from scratch. Up to you.

### Standard Sign-in widget customization
For example, to override the standard email `TextFormField` just provide a `TextFieldConfig` for the `emailTextField` parameter. In this example we are providing a new [style] and [inputDecoration]:

```dart
return LitAuth(
  config: AuthConfig(
    emailTextFormField: InputDecoration(labelText: 'My beautiful label'),
    emailTextField: TextFieldConfig(
      style: TextStyle(fontSize: 18),
      inputDecoration: InputDecoration(
        labelText: 'My beautiful label',
      ),
    ),
  )
);
 ```

To customize a button:

 ```dart
return LitAuth(
  config: AuthConfig(
    signInButton: ButtonConfig.raised(
      themedata: ButtonThemeData(buttonColor: Colors.red),
      child: Text('Sign in with Email'),
    ),
    googleButton: GoogleButtonConfig.light(),
    appleButton: AppleButtonConfig.dark(),
  ),
),
 ```

There are a number of different button customizations that you can do.

### Notifications
Notifications are rendered using the [flushbar](https://pub.dev/packages/flushbar) package.

You can customize the error and success notifications:

```dart
LitAuth(
  errorNotification: NotificationConfig(backgroundColor: Colors.pink),
  successNotification: NotificationConfig(backgroundColor: Colors.pink),
);
```

There are many attributes that can be altered to create the desired notification. Please see the `NotificationConfig` class for additional information.

### Additional Customization

For further customization you can directly make use of the Lit Firebase components to build a completely custom sign-in widget.

Instead of using the standard `AuthConfig`, set it to custom and provide your custom sign-in widget:

```dart
return LitAuth.custom(
  child: YourCustomSignInWidget(),
);
```

You can build any form you want, for example:

```dart
class YourCustomSignInWidget extends StatelessWidget {
  const CustomSignInWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Welcome', style: Theme.of(context).textTheme.headline4),
        // You need to wrap the custom sign-in widgets with a SignInForm.
        // This is used to validate the email and password
        SignInForm(
          formChild: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'A custom form',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EmailTextFormField(
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: 'My Email Label'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PasswordTextFormField(
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: 'My Password Label'),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  context.signInWithEmailAndPassword();
                },
                child: Text('Sign In'),
              ),
              FlatButton(
                onPressed: () {
                  context.signInAnonymously();
                },
                child: Text('Anony Sign In'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

**NOTE**: `SignInForm` needs to be provided above the `EmailTextFormField` and `PasswordTextFormField`.

The state of the password and email can be cleared manually by calling:

```dart
context.resetSignInForm()
```

This will reset the form to it's initial state.

It's a good idea to do this when you have multiple `EmailTextFormField` and `PasswordTextFormField` widgets in seperate locations, for example when you have a separate Sign-in form and a Registration form.

### Icons

It's possible to use the OAuth icons provided by the package. For example:

```dart
class Icons extends StatelessWidget {
  const Icons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LitAuthIcon.google(),
        LitAuthIcon.appleBlack(),
        LitAuthIcon.appleWhite(),
        LitAuthIcon.github(),
        LitAuthIcon.twitter(),
      ],
    );
  }
}
```

This will display a column of icons (images).

## Planned features


|                   | State       |                                                                  |
| ----------------- | ----------  | ---------------------------------------------------------------- |
| Platforms         | ⌛          | Support more platforms (Windows, macOS, Linux)                   |
| Auth providers    | ⌛          | Support more authentication providers (Facebook, Microsoft)         |
| Cupertino         | ⌛          | Cupertino look and feel                                          |
| Password reset    | ❌          | Add services and UI to reset password/email                      |
| Email confirmation| ❌          | Add UI to notify users they need to confirm their email address  |
| Support UI        | ❌          | Assist users who cannot authenticate with support links          |
| Custom dialogs    | ✔️          | Add support to customize dialog messages                         |
| Adaptive layouts  | ⌛          | Adaptive layouts to support multiple screen sizes               |
| Customization     | ✔️          | Even more, or easier, customization                             |
| Testing           | ❌          | Add testing                                                     |

## Dart Versions

- Dart 2: >= 2.7.0

## Maintainers

- [Gordon Hayes](https://github.com/funflutter)

## Starware

Lit Firebase is Starware
This means you're free to use the project, as long as you star ⭐ its GitHub repository or give a thumbs up 👍 on Pub.