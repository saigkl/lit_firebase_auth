import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize Lit Firebase Auth. Needs to be above [MaterialApp]
    return LitAuthInit(
      authProviders: const AuthProviders(
        emailAndPassword: true, // enabled by default
        google: true,
        apple: true,
        anonymous: true,
        github: true,
        twitter: true,
      ),
      child: MaterialApp(
        title: 'Material App',
        themeMode: ThemeMode.light,
        darkTheme: ThemeData.dark(),
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.white,
            textTheme: ButtonTextTheme.primary,
            height: 40,
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: LitAuthState(
            authenticated: YourAuthenticatedWidget(),

            /// Standard
            unauthenticated: LitAuth(
              config: AuthConfig(
                title: Text(
                  '🔥Welcome to Lit Firebase!🔥',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
                googleButton: GoogleButtonConfig.light(),
                appleButton: AppleButtonConfig.dark(),
                emailTextField: TextFieldConfig(
                  style: TextStyle(fontSize: 18, color: Colors.red),
                  inputDecoration: InputDecoration(
                    labelText: 'Your Email',
                  ),
                ),
              ),
            ),

            // USE THIS FOR A CUSTOM SIGN IN WIDGET
            /// Custom
            // unauthenticated: LitAuth.custom(
            //   child: CustomSignInWidget(),
            // ),
          ),
        ),
      ),
    );
  }
}

/// An example widget. This can be anything that you want to show after
/// succesful authentication
class YourAuthenticatedWidget extends StatelessWidget {
  const YourAuthenticatedWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(Icons.lock_outline),
      onPressed: () {
        context.signOut();
      },
      label: Text("Sign out"),
    );
  }
}

/// A custom Sign-in widget built with Lit Firebase components
class CustomSignInWidget extends StatelessWidget {
  const CustomSignInWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Welcome', style: Theme.of(context).textTheme.headline4),

        // You need to wrap the custom sign-in widgets with a [SignInForm].
        // This is used to validate the email and password
        SignInForm(
          child: Column(
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
                  decoration: InputDecoration(labelText: 'My Email Label'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PasswordTextFormField(
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
              FlatButton(
                onPressed: () {
                  context.signInWithGithub();
                },
                child: Text('Github Sign In'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
