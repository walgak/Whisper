import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {

    //pick an image from gallery
    Future pickPic() async{
      XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
      String imgPath = img!.path.toString();
    }

    //upload iamge to firebase
    Future uploadPic()async{
      
    }

    return const Placeholder();
  }
}
