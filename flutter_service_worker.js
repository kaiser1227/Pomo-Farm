'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "1091559ec4b4a4fa60158a781cc23360",
"splash/img/light-2x.png": "56a735430ba3fa79a512b3767ec9aee6",
"splash/img/dark-4x.png": "5bff3d99505c058cf348e41ab0607503",
"splash/img/light-3x.png": "b5ac3438dd1b3d9af2208551dbb76a69",
"splash/img/dark-3x.png": "b5ac3438dd1b3d9af2208551dbb76a69",
"splash/img/light-4x.png": "5bff3d99505c058cf348e41ab0607503",
"splash/img/dark-2x.png": "56a735430ba3fa79a512b3767ec9aee6",
"splash/img/dark-1x.png": "dc858a109cef81e1254e38cc762f20e1",
"splash/img/light-1x.png": "dc858a109cef81e1254e38cc762f20e1",
"splash/splash.js": "c6a271349a0cd249bdb6d3c4d12f5dcf",
"splash/style.css": "5877515f23f949881f11f1ba262d2870",
"index.html": "162ebfe7f17a059550799c9455242424",
"/": "162ebfe7f17a059550799c9455242424",
"main.dart.js": "6aacc1dcdc547be9e8b1269e479bfc03",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "83d8fed50b5f985e11bb89e4ec169d84",
"assets/AssetManifest.json": "01294208dbd747787091f29708ea556b",
"assets/NOTICES": "ebecc5049bde5acf4a0b1152c8ac8cb4",
"assets/FontManifest.json": "582cf8de0182d0915d57f6144834ad73",
"assets/AssetManifest.bin.json": "1b39b72eb9f8581ba6b17776430f5a5c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "7984a738428cf059727b803387b0ea28",
"assets/fonts/MaterialIcons-Regular.otf": "fbb334f8ed8745799e1825714130af4f",
"assets/assets/images/accessories/headband.png": "81050ca6dc3e423458b350fddb0c0bc4",
"assets/assets/images/accessories/tongue.png": "35ec850b2c5eae51ef53e96c1bf45160",
"assets/assets/images/accessories/sweat.png": "a02030e0e6c8956e78e708ae35e46ebf",
"assets/assets/images/accessories/sparkles.png": "be852a55f8a5b6c1fe1d42d428e4255a",
"assets/assets/images/accessories/sunglasses.png": "d501ce71c5cbc93f847ee41d11a5efca",
"assets/assets/images/accessories/goggles.png": "c8e8989fe1ef9be7e0b90dafe902cd92",
"assets/assets/images/accessories/sleeping.png": "86c4474923d789d42e937a2ac18c1360",
"assets/assets/images/accessories/bandaid.png": "33ee33c9c1c1192bab34389f747ffc68",
"assets/assets/images/accessories/glasses.png": "d3265b5a96c5cfcbd003f132ae0fdd6c",
"assets/assets/images/app_icon.png": "a7a33aca59c7bc3dc227c3e68345bfff",
"assets/assets/images/tomato_stage_2.png": "873fa2a5acd90886af5aa16799ab4c54",
"assets/assets/images/tomato_stage_3.png": "0fd685b4c980c75b2bfbeedc5b1484d1",
"assets/assets/images/tomato_stage_1.png": "7980d118261f7757fa30e6bd3563ac23",
"assets/assets/images/tomato_stage_4.png": "2991f9930b61c1db46dc8e30cf026733",
"assets/assets/images/tomato_stage_5.png": "805973eb69c9eff2c180251993e38281",
"assets/assets/images/tomato_stage_6.png": "b44549db9c0092afd03ad78ca5961910",
"assets/assets/sounds/buy_sound.wav": "7d7ec339b1fa1136e77ae83afbb90440",
"assets/assets/sounds/water_drop.wav": "3b8f8ee64354a8e5bce2853f2ae84cb3",
"assets/assets/sounds/coin.wav": "c4e40277e7a895289e0a67ab2c11ab48",
"assets/assets/fonts/DSEG7Classic-Bold.ttf": "0553776b42a7969adf6fee438fc29bd8",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
