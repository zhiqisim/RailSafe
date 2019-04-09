const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);


//TRIGGER SECTION
exports.onAlert = functions.firestore.document("test/testdoc").onUpdate((change, context) => {
    const payload = {
        data: {
            title: "EMERGENCY ALERT",
            body: "System has detected a fall!",
            icon: "default",
            sound : "default",
            clickAction: "FLUTTER_NOTIFICATION_CLICK"
        }
    }
    const tokenId = "dkD9xcOxtiE:APA91bFBjg-4CwxyBI1iGz30aPCjZVSejnFe9qfksUWf5VHTSEg_xRMcfhNLex2kz17quwzre4NBsRcfsLl5lVKfmHe3pE7q33Xs-S0UcTesXz4hVn0inoIvVRY_jP8mamcfCb34GfnW";

	return admin.messaging().sendToDevice(tokenId, payload).catch(error => {
        console.error("FCM failed", error)
    })
})
