import 'package:flutter/material.dart';
import 'package:wastood/domain/wastood.dart';
import 'package:wastood/pages/chat.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({Key key, @required this.wastood, @required this.active})
      : super(key: key);
  final Wastood wastood;
  final bool active;

  String _manageTimeLeft(int n) {
    if(n == 0) {
      return 'expires today';
    } else {
      return n.isNegative ? "${-n} days due" : "$n days to go";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Problem with this
    // final Image wastoodImage = Image.network(
    //   wastood.imageUrls.length == 0
    //       ? 'https://via.placeholder.com/350x150'
    //       : wastood.imageUrls[0],
    //   fit: BoxFit.cover,
    //   width: 200,
    // );
    return InkWell(
      onTap: () {
        if (!active) {
          Navigator.pushNamed(context, "/details", arguments: wastood);
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChatWidget(
                wastood: wastood,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: this.wastood.imageUrls.length > 0
                        ? Image.network(
                            this.wastood.imageUrls[0],
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[200],
                          )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                wastood.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _manageTimeLeft(
                  ((wastood.endsAt.millisecondsSinceEpoch -
                              DateTime.now().millisecondsSinceEpoch) /
                          (1000 * 3600 * 24))
                      .round(),
                ),
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget _buildOld(BuildContext context) {
//   Container(
//     height: 128,
//     child: Card(
//       color: Color(0xFFE9C46A),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CircleAvatar(
//                         foregroundColor: Colors.red,
//                         backgroundImage:
//                             NetworkImage(f(wastood.author.profilePicURL)),
//                       ),
//                       SizedBox(
//                         width: 16,
//                       ),
//                       Column(
//                         children: [
//                           Text(
//                             wastood.title,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Container(
//                             width: 100,
//                             child: Text(
//                               wastood.author.name,
//                               style: const TextStyle(
//                                 fontStyle: FontStyle.italic,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Flexible(
//           // child:
//           ShaderMask(
//             shaderCallback: (rect) {
//               return const LinearGradient(
//                 begin: Alignment.centerRight,
//                 end: Alignment.centerLeft,
//                 colors: [Colors.black, Colors.transparent],
//               ).createShader(
//                 Rect.fromLTRB(0, 0, rect.width - 150, rect.height),
//               );
//             },
//             blendMode: BlendMode.dstIn,
//             // child: wastoodImage,
//           ),
//           // )
//         ],
//       ),
//       margin: const EdgeInsets.symmetric(
//         horizontal: 16.0,
//         vertical: 8.0,
//       ),
//       elevation: 10.0,
//     ),
//   );
// }
}
