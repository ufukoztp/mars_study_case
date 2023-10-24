import 'package:flutter/cupertino.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class SelectPhotoViewInherited extends InheritedWidget {
  SelectPhotoViewInherited({super.key, required super.child})
      : imagePickerController = MultiImagePickerController(
            maxImages: 15,
            allowedImageTypes: ['png', 'jpg', 'jpeg'],
            withData: true,
            withReadStream: true,
            images: <ImageFile>[]);

  ///for ui logic

  final MultiImagePickerController imagePickerController;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static SelectPhotoViewInherited of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<SelectPhotoViewInherited>();
    assert(result != null, 'No InheritedWidget found in context');
    return result!;
  }
}
