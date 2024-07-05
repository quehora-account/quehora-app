import {DecodedIdToken} from "firebase-admin/auth";
import * as admin from "firebase-admin";
import * as v1 from "firebase-functions/v1";

/**
* Throw error if no session
 */
export async function verifyIdToken(request :v1.https.Request)
: Promise<DecodedIdToken> {
  const content : string= request.headers.authorization! as string;
  const idToken = content.split(" ")[1];

  if (idToken === null) {
    throw new Error();
  }
  const decodedIdToken = await admin.auth().verifyIdToken(idToken!);
  return decodedIdToken;
}
