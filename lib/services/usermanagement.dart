import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
class Usermanagement{
 Future storage(url) async{
    var time = DateTime.now();
    StorageReference filestoragereference = FirebaseStorage.instance.ref()
        .child('posts/$time.jpg');
    StorageUploadTask task = filestoragereference.putFile(url);
    var downloadedUrl = await(await task.onComplete).ref.getDownloadURL();
    return downloadedUrl.toString();
  }

  updateuserprofile(String picurl,String username)async{
   String userkey = username.substring(0,1);
   var userinfo =  UserUpdateInfo();
   userinfo.photoUrl = picurl;
   userinfo.displayName = username;
   FirebaseAuth.instance.currentUser().then((user){
     user.updateProfile(userinfo).then((val){
       Firestore.instance.collection('users').document(user.uid).updateData({
         'profilepic':picurl,
         'username':username,
         'userkey' : userkey
       });
         });
       });


  }


//  updateProfilePicture(){
//   FirebaseAuth.instance.currentUser().then((val){
//   FirebaseStorage.instance.ref().child()
//   });
//  }




  getposts()async{
   return Firestore.instance.collection('timelineposts').snapshots();
  }

  getusersposts(){
   FirebaseAuth.instance.currentUser().then((user){
       Firestore.instance.collection('/users').where('uid',isEqualTo: user.uid).getDocuments().then((docs){
        return Firestore.instance.document(docs.documents[0].documentID).collection('/posts').getDocuments();

      });


   });

  }

  userpostlikes(username,posturl,likenum){

      Firestore.instance.collection('/users').where('username',isEqualTo: username).getDocuments().then((docs){
        Firestore.instance.document(docs.documents[0].documentID).collection('posts').where('posturl',isEqualTo: posturl);
      });






  }

  getuserposts(user){
   return Firestore.instance.collection('timelineposts').where('postedusername',isEqualTo: user).getDocuments();
  }

  }
