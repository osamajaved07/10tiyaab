// Stack(
//   children: [
//     // The image displayed in the profile picture section
//     _profileImageUrl != null && _profileImageUrl!.isNotEmpty
//         ? Image.network(
//             _profileImageUrl!,
//             width: screenWidth * 0.36, // Double the radius for width
//             height: screenWidth * 0.36, // Double the radius for height
//             fit: BoxFit.cover,
//             loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//               if (loadingProgress == null) {
//                 return child; // When image is loaded, return the image
//               } else {
//                 return Center(
//                   child: CircularProgressIndicator(
//                     color: tPrimaryColor,
//                     value: loadingProgress.expectedTotalBytes != null
//                         ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
//                         : null,
//                   ),
//                 ); // Show loading indicator while image is loading
//               }
//             },
//           )
//         : _pickedImage != null
//             ? Image.file(
//                 File(_pickedImage!.path),
//                 width: screenWidth * 0.36, // Double the radius for width
//                 height: screenWidth * 0.36, // Double the radius for height
//                 fit: BoxFit.cover,
//               )
//             : Image.asset(
//                 'assets/images/default_profile.png',
//                 width: screenWidth * 0.36, // Double the radius for width
//                 height: screenWidth * 0.36, // Double the radius for height
//                 fit: BoxFit.cover,
//               ),
//     // Icon to pick a new image
//     Positioned(
//       bottom: 0,
//       right: 0,
//       child: GestureDetector(
//         onTap: _pickImage,
//         child: Container(
//           padding: EdgeInsets.all(screenWidth * 0.02),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.grey, width: 2),
//           ),
//           child: Icon(Icons.camera_alt, size: screenWidth * 0.05),
//         ),
//       ),
//     ),
//   ],
// );
