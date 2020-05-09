const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newdata;

exports.messageTrigger = functions.firestore.document('timelineposts/{any}').onCreate(async(snapshot,context)=>{
    if(snapshot.empty){
        console.log('No Devices');
        return;
    }
    newdata = snapshot.data();

    var Tokens = [
        'c0N1dQDJBXM:APA91bH-GUajch4Cx17551CyDYPBEnFxFzPX2KaHPVLBiYJp7at8c2CHZF5tES6zwzUcoLjovblKBLRJrcppbIszfyhx1StLE8cX1G7COTWL4gpNnmoc8rPWwn76wskBZYKQuimNNYBz'
    ]
    var payload = {
        notification:{
            title:newdata.postedusername,
            body:'posted a photo',
            icon:newdata.posteduserprofile,
            sound:'default',
        },
        data:{
             click_action: 'FLUTTER_NOTIFICATION_CLICK',
             message:'Hellogram Notification'
            //     {
            //     'postedusername':newdata.postedusername,
            //     'posteduserprofile':newdata.posteduserprofile,
            //     'timelinposturl':newdata.timelinposturl,
            //     'postId':newdata.postId,
            //     'uid':newdata.uid,
            //     'likes':newdata.likes
            // }
        }
    };
    try{
        const response = await admin.messaging().sendToDevice(Tokens,payload);
        console.log('Pushed all successfully');
    }catch(err){
        console.log('Error while pushing Notification');
    }
})


// // Create and Deploy Your First Cloud Functionss
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
