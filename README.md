# hoora


Enter this command in the tterminal of the android then get the sha 256 and import them in the firebase so you can get the reprenstive google-service.json files for different flavors.
<br/>
```./gradlew signingReport```


copy files through bucketss

```gcloud storage cp -r gs://hoora-fb944.appspot.com/spot/card/ gs://hoora-staging.appspot.com/spot/card/```
install firebase cli 
```
npm install -g firebase-tools
```
for deploying functions
```
firebase login
firebase projects:list
firebase use hoora-fb944
firebase deploy --only functions:<function-name>

```
