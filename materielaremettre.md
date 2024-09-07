# regles
``` rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
  
    match /globalListItem/{document=**} {
  	allow read, create: if request.auth != null;
		}
  
    match /users/{req_uid} {
      allow write: if request.auth != null && request.auth.uid == req_uid;
    }

    match /users/{req_uid} {
      allow read: if request.auth != null;
    }
    
    match /epiceries/{documentId} {
    	allow create: if request.auth != null; 
    	allow read, write: if exists(/databases/$(database)/documents/familles/$(documentId)/membres/$(request.auth.uid));
    }
    
    match /epicerieID/{document=**}{
      allow read, write;
    } 

    match /familles/{epicerieID}/{document=**}{
    	allow create: if request.auth != null; 
      allow write: if exists(/familles/$(epicerieID)/membres/$(request.auth.uid));
    } 
    
    match /openfoodItemsID/{document=**} {
    	allow read,create: if request.auth != null;
    }
    
	}
}
```

# Database
``` "CREATE TABLE items (id TEXT PRIMARY KEY , grocerieId TEXT, name TEXT, category TEXT, image TEXT, info TEXT)"```

```"CREATE TABLE groceries (id TEXT PRIMARY KEY , name TEXT, createBy TEXT, icon TEXT)"```

# Video

[Video](/ScreenRecorderProject1.mp4)