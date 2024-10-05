// Future<void> _submitJobDetails() async {
//     if (_descriptionController.text.isEmpty || _selectedImages.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please fill all fields and select images.')),
//       );
//       return;
//     }

//     try {
//       // Construct request to send data
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('YOUR_SERVER_ENDPOINT'), // Replace with your endpoint
//       );

//       // Add service provider ID
//       request.fields['serviceProviderId'] = selectedServiceProviderId;

//       // Add description, minPrice, maxPrice
//       request.fields['description'] = _descriptionController.text;
//       request.fields['minPrice'] = _minPriceController.text;
//       request.fields['maxPrice'] = _maxPriceController.text;

//       // Add selected images to the request
//       for (var image in _selectedImages) {
//         var stream = http.ByteStream(image.openRead());
//         var length = await image.length();
//         var multipartFile = http.MultipartFile(
//           'images',
//           stream,
//           length,
//           filename: image.path.split('/').last,
//         );
//         request.files.add(multipartFile);
//       }

//       // Send the request
//       var response = await request.send();

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Job details submitted successfully!')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to submit job details.')),
//         );
//       }
//     } catch (e) {
//       print('Error submitting job details: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred. Please try again later.')),
//       );
//     }
//   }