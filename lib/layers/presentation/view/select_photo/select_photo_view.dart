import 'package:flutter/material.dart';
import 'package:mars_study_case/layers/presentation/inheriteds/select_photo_inherited.dart';
import 'package:mars_study_case/layers/presentation/provider/select_photo_provider.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:provider/provider.dart';

class SelectPhotoView extends StatefulWidget {
  const SelectPhotoView({super.key});

  @override
  createState() => _SelectPhotoViewState();
}

class _SelectPhotoViewState extends State<SelectPhotoView> {
  late SelectPhotoProvider _selectPhotoProvider;
  @override
  Widget build(BuildContext context) {
    _selectPhotoProvider = Provider.of<SelectPhotoProvider>(context);
    return SelectPhotoViewInherited(
      child: Scaffold(
        appBar: _buildAppBar(),
        bottomNavigationBar: NextButtonWidget(
          selectPhotoProvider: _selectPhotoProvider,
        ),
        body: const _ImagePickerWidget(),
      ),
    );
  }
}

// ignore: must_be_immutable
class NextButtonWidget extends StatelessWidget {
  NextButtonWidget({super.key, required this.selectPhotoProvider});
  SelectPhotoProvider selectPhotoProvider;
  final String _apply = 'ONAYLA';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await selectPhotoProvider.createVideoSessionStart(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
          height: 50,
          child: Center(
            child: Text(
              _apply,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePickerWidget extends StatelessWidget {
  const _ImagePickerWidget();

  final String _selectPhoto = 'FOTOĞRAF SEÇ';
  final String _addMore = 'Daha Fazla Ekle';
  @override
  Widget build(BuildContext context) {
    return MultiImagePickerView(
      controller: SelectPhotoViewInherited.of(context).imagePickerController,
      addButtonTitle: _selectPhoto,
      addMoreButtonTitle: _addMore,
    );
  }
}

AppBar _buildAppBar() {
  const String videoCreater = 'Video Oluşturucu';
  return AppBar(
    title: const Text(videoCreater),
    centerTitle: true,
  );
}
