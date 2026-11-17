# Remote aur Casting Report (Roman Urdu)

Note: Phone ke logs nahi dekhe gaye kyunke is machine par `adb` install nahi hai. Ye report sirf code parh kar bani hai. Koi file change nahi ki gayi.

## 1. Remote screen disable kyun hai

- "TALHA TV" sirf SSDP se mili. Uska manufacturer `network_device_repository.dart` (line 161-174) ki brand list mein nahi hai. Is liye app ne usay generic `DeviceType.dlna` bana diya.
- `receiver_capabilities.dart` (line 42) mein `DeviceType.dlna: {}` hai, yaani DLNA ke liye ek bhi button allowed nahi. UI har button ko `supports(command)` se check karta hai, is liye poora remote dhundla ho jata hai. Ye bug nahi, jaan-boojh kar rakha gaya rule hai ("pretend nahi karenge").
- Isi file ki comment kehti hai ke DLNA par AVTransport aur RenderingControl se play, pause, next, previous aur volume ho sakte hain. Ye kahin implement nahi hua.
- `NetworkRemoteService.send` sirf Roku, Android TV (paired) aur Samsung (paired) sambhalta hai. Baqi par `UnsupportedError` phenkta hai.
- Agar TV asal mein Android TV hai to wo mDNS `_androidtvremote2` par nazar aani chahiye thi aur `smartTv` ban kar pairing ke baad poora remote milta. Wo nahi aayi, to mDNS shayad us TV par ya router par kaam nahi kar raha. Logs ke baghair pakka nahi keh sakte.

## 2. Casting connect kyun nahi hoti

- `player_controller.dart` (line 15) khud likhta hai "Fake remote-playback session". `play()` sirf app ke andar ek timer chalata hai.
- Koi `SetAVTransportURI` nahi bheja jata, koi Cast v2 session nahi banta, aur TV ko media dene wala local HTTP server bhi nahi hai.
- `connect()` (`network_device_repository.dart`, line 348) sirf TV ke port par socket khol kar dekhta hai ke wo reachable hai.
- Yaani "Connected" ka matlab sirf itna hai ke TV pohanch mein hai. Us par kuch cast nahi hota, isi liye screen "IDLE" dikhati hai.
- Screen mirroring ka controller alag hai. Usay abhi check nahi kiya.

## 3. Aage ka rasta

DLNA ke liye ye cheezein chahiye:
- Description XML se `controlURL` parhna
- Video ya photo parosne wala local HTTP server
- `SetAVTransportURI` aur Play/Pause/Seek/Volume ke SOAP calls

Google Cast ke liye Cast v2 protocol alag se chahiye.

DLNA wala hissa banaya ja sakta hai. Is ke baad DLNA par casting aur TV ka volume, play, pause control asal mein chalenge, aur "TALHA TV" jaisi TV par remote ke buttons bhi chalu ho jayenge. TV ka naam aur model bata dein to andaza lag sakta hai ke wo Android TV hai ya sirf DLNA.
