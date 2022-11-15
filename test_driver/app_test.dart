// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:test/test.dart';

// void main() {
//   group("test login", () {
//     FlutterDriver driver;

//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });

//     tearDownAll(() {
//       if (driver != null) {
//         driver.close();
//       }
//     });

//     final anonLoginButton = find.text("Entrar como Anónimo");
//     final goToParty = find.text("Ir a una Fiesta");
//     final goButton = find.text("Go!");
//     final menu = find.byValueKey("menu");
//     final signOut = find.byValueKey("signout");

//     test("should open go to party screen", () async {
//       await driver.waitFor(anonLoginButton);
//       await driver.tap(anonLoginButton);
//       await driver.waitFor(goToParty);
//       await driver.tap(goToParty);
//       await driver.waitFor(goButton);

//       // Back
//       await driver.tap(find.byTooltip("Back"));

//       // Signout
//       await driver.tap(menu);
//       await driver.tap(signOut);
//     });

//     test("when not logged in, anon button should be visible", () async {
//       await driver.waitFor(anonLoginButton);
//     });

//     test("should log in when tap anon login button", () async {
//       await driver.waitFor(anonLoginButton);
//       await driver.tap(anonLoginButton);
//       await driver.waitFor(goToParty);

//       // Signout
//       await driver.tap(menu);
//       await driver.tap(signOut);
//     });
//   });
// }
