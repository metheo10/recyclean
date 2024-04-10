// import 'package:flutter/material.dart';
// import 'package:rate_my_app/rate_my_app.dart';

// class RateAppPage extends StatefulWidget {
//   const RateAppPage({super.key});

//   @override
//   State<RateAppPage> createState() => _RateAppPageState();
// }

// class _RateAppPageState extends State<RateAppPage> {
//   final RateMyApp rateMyApp RateMyApp(
//     minDays:0,
//     minLaunches:2,
//     remindDays: 2,
//     remindLaunches: 5,
//     // appStoreIdentifier: '',
//     // googlePlayIdentifier: '',
//   );

//   @override
//   void initState(){
//     rateMyApp.init().then((_){
//       if(rateMyApp.shouldOpendDialog){
//         rateMyApp.showStarRateDialog(
//           context,
//           title:"NOTEZ CETTE APPLICATION",
//           message:"Vous aimez cette application ?\nSupporter nous avec un commentaire et un maximum de STARS.",
//           rateButton:'NOTER',
//           laterButton:'PLUS TARD',
//           noButton:'NON MERCI',
//           onDismissed:(stars)async{
//             // rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
//             print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
//               if(stars != null && (stars == 4 || stars == 5)){
//                  //if the user stars is equal to 4 or five
//                  // you can redirect the use to playstore or                         appstore to enter their reviews
                

//               } else {
//                  // else you can redirect the user to a page in your app to tell you how you can make the app better
              
//               }
//               // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
//               // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
//               await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
//               Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
//           }
//         );
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }