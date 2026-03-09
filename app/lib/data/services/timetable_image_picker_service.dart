import 'package:app/data/models/selected_timetable_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timetable_image_picker_service.g.dart';

/// Provides the image picker service used by the timetable flow.
@Riverpod(keepAlive: true)
TimetableImagePickerService timetableImagePickerService(Ref ref) {
  return TimetableImagePickerService();
}

/// Selects timetable images from the device.
class TimetableImagePickerService {
  /// Creates an image picker service.
  TimetableImagePickerService({
    ImagePicker? imagePicker,
    Future<SelectedTimetableImage?> Function()? pickImage,
  }) : _imagePicker = imagePicker ?? ImagePicker(),
       _pickImage = pickImage;

  final ImagePicker _imagePicker;
  final Future<SelectedTimetableImage?> Function()? _pickImage;

  /// Prompts the user to pick an image from the gallery.
  Future<SelectedTimetableImage?> pickImageFromGallery() async {
    if (_pickImage != null) {
      return _pickImage();
    }

    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      return null;
    }

    return SelectedTimetableImage(
      bytes: await file.readAsBytes(),
      name: file.name,
    );
  }
}
