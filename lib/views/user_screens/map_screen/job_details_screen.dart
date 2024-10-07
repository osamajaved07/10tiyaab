// ignore_for_file: unused_local_variable, unused_element

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fyp_1/controllers/user_auth_controller.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:fyp_1/utils/custom_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({
    super.key,
  });

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  TextEditingController _minPriceController =
      TextEditingController(text: "400");
  TextEditingController _maxPriceController =
      TextEditingController(text: "10000");
  TextEditingController _descriptionController = TextEditingController();
  final UserAuthController authController = Get.find<UserAuthController>();
  double _minPrice = 400.0;
  double _maxPrice = 10000.0;
  final _secureStorage = const FlutterSecureStorage();

  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  String _selectedServiceProvider = "Unknown Provider";

  @override
  void initState() {
    super.initState();
    _getStoredServiceProvider();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      _selectedServiceProvider =
          arguments['serviceProvider'] ?? "Not found Provider";
      print("Selected Service Provider: $_selectedServiceProvider");
    }
  }

  Future<void> _getStoredServiceProvider() async {
    // Retrieve the stored service provider from secure storage
    String? storedProvider = await _secureStorage.read(key: 'selectedProvider');

    if (storedProvider != null) {
      setState(() {
        _selectedServiceProvider = storedProvider;
      });
      print('Stored Service Provider: $storedProvider');
    } else {
      print('No service provider found in local storage.');
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.length + _selectedImages.length <= 10) {
      setState(() {
        _selectedImages
            .addAll(images.map((image) => File(image.path)).toList());
      });
    } else if (images != null && images.length + _selectedImages.length > 10) {
      errorSnackbar("Error", "You can select a maximum of 10 images.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tSecondaryColor,
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: tPrimaryColor,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.toNamed("/mapscreen");
            },
            icon: Icon(
              Icons.arrow_back,
              color: ttextColor,
              size: tlargefontsize(context),
            )),
        title: Text("Job Detail",
            style: TextStyle(
                color: Colors.black, fontSize: tmidfontsize(context))),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                priceRange(context, screenHeight),
                SizedBox(height: screenHeight * 0.03),
                divider(screenWidth),
                SizedBox(height: screenHeight * 0.03),
                jobDetailSection(context, screenHeight),
                SizedBox(height: screenHeight * 0.03),
                divider(screenWidth),
                SizedBox(height: screenHeight * 0.03),
                imagePickerSection(screenHeight),
                SizedBox(height: screenHeight * 0.09),
                confirmButton(screenWidth, screenHeight, context),
                SizedBox(height: screenHeight * 0.09),
              ],
            ),
          ),
        );
      }),
    );
  }

  Container divider(double screenWidth) {
    return Container(
      height: 2, // Adjust height as needed
      width: screenWidth * 1, // Width of the divider line
      color: Colors.black12, // Line color
    );
  }

  Center confirmButton(
      double screenWidth, double screenHeight, BuildContext context) {
    return Center(
      child: Material(
        elevation: 12,
        shadowColor: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: screenWidth * 0.8,
          height: screenHeight * 0.06,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: tPrimaryColor, // Button color
            ),
            // Disable button if 10 images are selected
            onPressed: () async {
              String jobDescription = _descriptionController.text.trim();
              String minPrice = _minPriceController.text.trim();
              String maxPrice = _maxPriceController.text.trim();
              List<File> images = _selectedImages;
              String? userId = await _secureStorage.read(key: 'id');

              if (jobDescription.isNotEmpty && maxPrice.isNotEmpty) {
                if (userId != null) {
                  await authController.submitJobDetails(
                    jobDescription,
                    images,
                    minPrice,
                    maxPrice,
                    userId,
                    _selectedServiceProvider,
                  );
                  Get.offNamed("/findsp");
                } else {
                  errorSnackbar("Error", "Please set your location first.");
                }
              } else {
                errorSnackbar("Error", "Please provide the required fields.");
              }
            },
            child: Text(
              'Confirm details',
              style: TextStyle(fontSize: tmidfontsize(context)),
            ),
          ),
        ),
      ),
    );
  }

  // Image picker section with grid display
  Widget imagePickerSection(double screenHeight) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              "Add images",
              style: TextStyle(
                fontSize: tlargefontsize(context),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),

          // Display selected images in a GridView
          _selectedImages.isNotEmpty
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of images per row
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        // Image display
                        Positioned.fill(
                          child: Image.file(
                            _selectedImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
              : Text("No images selected"),
          SizedBox(height: screenHeight * 0.01),
          // Button to pick images
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: tPrimaryColor, // Button color
            ),
            onPressed: _selectedImages.length < 10
                ? _pickImages
                : null, // Disable button if 10 images are selected
            child: Text(
              'Pick Images',
              style: TextStyle(fontSize: tsmallfontsize(context)),
            ),
          ),

          // Show max image limit warning
          if (_selectedImages.length == 10)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'You can select a maximum of 10 images.',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
        ],
      ),
    );
  }

  Column jobDetailSection(BuildContext context, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  Enter your work description: *",
          style:
              TextStyle(fontSize: tsmallfontsize(context), color: Colors.grey),
        ),
        SizedBox(height: screenHeight * 0.01),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(0.5),
          child: TextField(
            controller: _descriptionController,
            keyboardType: TextInputType.text,
            maxLines: 5,
            decoration: InputDecoration(
              // labelText: 'Message',
              hintText: "Require plumber to fix sink tap...",
              hintStyle: TextStyle(
                color: Colors.grey.shade600, // Adjust hint text color
                fontSize:
                    tverysmallfontsize(context), // Adjust font size of hint
              ),
              filled: true, // Enable background color
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade400, // Border color for enabled state
                  width: 1.5, // Adjust border thickness
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: tPrimaryColor, // Border color when focused
                  width: 2.0, // Thicker border when focused
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.redAccent, // Border color for error state
                  width: 1.5,
                ),
              ),
            ),
            // enabled: false, // Email is not editable
          ),
        ),
      ],
    );
  }

  Container priceRange(BuildContext context, double screenHeight) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Set your Price Range",
            style: TextStyle(
                fontSize: tmidfontsize(context), color: Colors.black)),
        SizedBox(height: screenHeight * 0.01),
        RangeSlider(
          activeColor: tPrimaryColor,
          values: RangeValues(_minPrice, _maxPrice),
          min: 400,
          max: 10000,
          divisions: 1000,
          labels: RangeLabels(
            'Rs ${_minPrice.toStringAsFixed(0)}',
            'Rs ${_maxPrice.toStringAsFixed(0)}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _minPrice = values.start;
              _maxPrice = values.end;
              if (_maxPrice < _minPrice) {
                _maxPrice = _minPrice;
              }
              _minPriceController.text = _minPrice.toStringAsFixed(0);
              _maxPriceController.text = _maxPrice.toStringAsFixed(0);
            });
          },
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Material(
                  color: Colors.white,
                  elevation: 4,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(18),
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(7),
                    ],
                    onChanged: (value) {
                      setState(() {
                        double minPrice = double.tryParse(value) ?? 400;
                        if (minPrice < _maxPrice) {
                          _minPrice = minPrice;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Min Price',
                      labelText: 'Min Price',
                      prefixText: "Rs ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Material(
                  color: Colors.white,
                  elevation: 4,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(18),
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(7),
                    ],
                    onChanged: (value) {
                      setState(() {
                        double maxPrice = double.tryParse(value) ?? 10000;
                        if (maxPrice > _minPrice) {
                          _maxPrice = maxPrice;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Max Price',
                      labelText: 'Max Price *',
                      prefixText: "Rs ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }

  TextFormField _priceField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(7),
      ],
      onChanged: (value) {
        setState(() {
          double minPrice = double.tryParse(value) ?? 400;
          if (minPrice < _maxPrice) {
            _minPrice = minPrice;
          }
        });
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white10),
          borderRadius: BorderRadius.circular(18),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black45),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: label,
        labelText: label,
        prefixText: "Rs  ",
      ),
    );
  }
}
