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
"index.html": "a26e3ffd4ea5d97e0b129774c8079be2",
"/": "a26e3ffd4ea5d97e0b129774c8079be2",
"main.dart.js": "6aacc1dcdc547be9e8b1269e479bfc03",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"favicon.png": "b44549db9c0092afd03ad78ca5961910",
"icons/Icon-192.png": "b44549db9c0092afd03ad78ca5961910",
"icons/Icon-maskable-192.png": "b44549db9c0092afd03ad78ca5961910",
"icons/Icon-maskable-512.png": "b44549db9c0092afd03ad78ca5961910",
"icons/Icon-512.png": "b44549db9c0092afd03ad78ca5961910",
"manifest.json": "83d8fed50b5f985e11bb89e4ec169d84",
".git/config": "38881ccff4dc4e249623736f3cd97a15",
".git/objects/95/863b0a1d59dd1e9b3b0a89894f01995601df85": "11bbc21f5f434e4225df5706530a836a",
".git/objects/92/c7763a98106042ca2f9543be190ee0cbf13914": "a946126c60fd2812ae5a493a9ff0c938",
".git/objects/0c/7558c2dc48dd0d893e7eb137638c951d0d6cbc": "4c690ec95f68d60a35147826ef259919",
".git/objects/6f/9cad4c116bc8d72e2497226abb5c05ee64982c": "0d104480d68c1652a53721377a02a882",
".git/objects/69/fac374d95e239ee3071b313f7244d7cbac5b3d": "82753e67cc38ab59105ce179ef0ad0a4",
".git/objects/93/1ba6b65f842096199fda028713e0f1c8413b60": "113807e203ba5f81904ed6df367a9c4b",
".git/objects/94/0ed24b94c04efaaf2af65a352b9f5de67b57cf": "4481fff82a3b717b6be6d8dba41e2140",
".git/objects/94/bfb1463ad8331bfd687bc751b8920b133da744": "fd2d8c0d844b234856b36b93f652048f",
".git/objects/5a/ef202a79fe812d11b40daeb677334b509533ec": "0c9b0df843e34d59bcdafe8a85c08eb9",
".git/objects/b5/0254288cc6319d153c4af1d64870d95ee2436f": "468a6506934a07c970a4739eae75eedd",
".git/objects/b2/dc75aec118343ce585f36cb3caf52a30c7d6c6": "905888a980c43908657a8ebbf65a21b4",
".git/objects/ad/2f90b78480aeb6608226d9db4ecbd3ec06aaeb": "4add97a99941aa0e9eed0f2173416ade",
".git/objects/bb/428fededf52b853e30e433c737d96e203286ad": "c6b5a778aff3a5beea22beff9aa2b73f",
".git/objects/bb/c3b22939e7ceba510999eed72802cfcd6547c9": "6f537bfde687df2cfdb62e464c540ad9",
".git/objects/d7/8ff71569091f953da8c665191a6408262053fc": "baa7170e182e82287b09c1e10a850b1f",
".git/objects/d7/2c11112c7cb4e2ce754bc41470f9b829a2d00a": "d7280a766a5d6033f187d874a92b5ad6",
".git/objects/be/6d8308e10de3926f8c241cd923d5c8ac3219fd": "3e19651389e6d11a4ebd2f874ac0047f",
".git/objects/b3/65e13fd7161f2e8b7a4aee6285412a07b9297b": "c63d711fd736b31c55aab48885f1737b",
".git/objects/d6/01b7cf91ed401dc6d2b7656f576b86d617bde8": "d7e5a789d050d106c992bf7acb848e14",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/ab/ac5e342e60f363bf287e27e84cce01587ed337": "7a7e7ef58bd459e4982b14db2f0d8363",
".git/objects/e5/7b7bcaf4e820371750c425bc101ebfb3d2d0c4": "0c8ff4775936f527029827030eb04a37",
".git/objects/e5/cc93a82805ac37a0c4596743c39966f55f1a00": "0d43544e57da56cb59fa65886d1d52d0",
".git/objects/e5/84a5e17b1685a55ece9c29719c13f9ddb1cf7a": "e39895e8dd62c2d3a8cfc28732efac83",
".git/objects/f4/3edf10b2181b0a4f0656999d79996189f8598a": "a832b1ad0277648ffabad1d5e4d5e0bd",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/c0/b63552b8063b000d8b97a8ddd35c93558f25d3": "0513888f3f2666c922c5692cd64c9355",
".git/objects/f2/0d191257c810b60d27333c29c9cec8ddf4b653": "b8fa7381a9ecf832c11e703bc02ca580",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/ed/7e7109d547b6f4eee0c6f10f175f241dd8963d": "8e36f76b1f13bb49bbc4dd3783e2caec",
".git/objects/20/1afe538261bd7f9a38bed0524669398070d046": "82a4d6c731c1d8cdc48bce3ab3c11172",
".git/objects/16/5ce0ddf03a820a38f48cba9aa0c9df9b6e6b79": "71df17c95c3124eada62b59e7dabda78",
".git/objects/89/8c454fb6fe50c7f05cdc2db89df05001d7789a": "f59660eb83869db55bb29a29b3834420",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/7e/ef957427381342c872af6e1995367eac4393d1": "1a667a142ba6fb76314438bcb4eefde3",
".git/objects/4c/9ce08f34de59da036a4bd4a8c83a81691d60c4": "428a9e636c118ff492b6773cd3b97ab6",
".git/objects/26/0d22b67bdff09954dc7cae6af638dfde8251da": "51680ee741d214ead83d616da50de0af",
".git/objects/43/f1d7224e44a10e6483b5ea1f1f6a9bc62c0604": "0b53d6dd8369b872fa2a3742a62fac9f",
".git/objects/88/5e9325f1f990ea1db5f2dd645b186e89b2ace7": "7e458cbabc4d0057f382f82adfed3e49",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/07/74c17c0fa7a7e87e24a6935830998d92b52c75": "cd62ee54b7ceea7b2a7804e69b1d9134",
".git/objects/36/ad9013be6d5f390a876c1624c57f5f15f2d381": "013e72ed6b7697b351aa21264b6921ad",
".git/objects/53/7807567919e88db2866b7825339c57e94c24d8": "970aec5149a3dbe9370a9dc982cdd022",
".git/objects/5e/d46dd3b6dc1eda84d0e3176442ca1fa0dbfe2c": "8f554de6a5f88871e4ecb771daa16a4c",
".git/objects/06/ebee35ae75805b5158e3a8170301465bac3d00": "b293476aeb1fb1a5c98580c6eb59cb15",
".git/objects/39/1cb7af2878ed51c260f5dedcd7a4809ca15591": "7e0a6310cbe2feedeeb869ef1590e8a6",
".git/objects/0f/dd3c66d44d61bc8eb9a8283857361a57149223": "856391e8d5bfa10267e57cf5d5ff2d2c",
".git/objects/0f/70e180e45a38b7db002203fde7e5bf5a8c0a19": "bdda9e57536c19775576a116bb62677a",
".git/objects/90/f158bb02a58c91f1ffaab327fee4aff287e4d5": "972835e86af474b75122e927807e747f",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/a9/91f51138ffe059d588003dc7936aff059a0428": "b73a35563fa129bd884d8b5c53ee9231",
".git/objects/af/742adee0a85dd21ea96cbd84182e30e085d6cf": "aa25b932ec40efacb1efe27e7cf25d82",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b7/b9455b8462118d537bae63bbf581abd6424e2d": "1a496dffc7a20eba8f17325599af704d",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/a1/31b5c6b6114cc66076bbe9cc68f769b70b34d2": "d13379f30a2c06c146da93cdec7cfcf7",
".git/objects/e1/8a40df3b1b0eb9a61edd992104cd07bcc43495": "5f88dba8827cc39c5a9edb0b0cbbfe32",
".git/objects/cc/fab74c1f56c330985060e2247607eaedb3c7d7": "ad5b6117df489509af208438785f208b",
".git/objects/e6/b745f90f2a4d1ee873fc396496c110db8ff0f3": "2933b2b2ca80c66b96cf80cd73d4cd16",
".git/objects/f9/9b9b69c6b4a4592a72d280ededb3a153026f85": "b8d3f9b66429eb23eb880c1a145c43e6",
".git/objects/f0/22d67f866eac2192443a4a61b0f48a19d87044": "875d891b5abb6a1faffbe3e918406ee9",
".git/objects/e8/2c5850db3a3482d0c954a4dc122c02de555ce7": "d357cd906b3805bf81477f5527cca086",
".git/objects/fa/ce42aeb9c0d2ae3528f5921293e0c784a5124b": "4961eb067127a7870c06ab54d9a4d42b",
".git/objects/ff/204c6cc889edab716a81447a9c4c9fd5affac4": "d6640cc3bd33ee990c044feff2e419f0",
".git/objects/c5/d3ef1abd823c893c101d15e729040e0cdd1e8a": "a3282df9246f8b2070397cca1dd34dba",
".git/objects/c5/f4bc2a4da91586f3005813077f0d0aa9040f82": "3191028b787554cee4652f5050144bff",
".git/objects/cb/b34583a15ded442691354a939789ac78fa89d4": "1ce0c4e113822bcc6526a7c750a609d5",
".git/objects/79/a6ea925d1873a8b0a46a96a995fd6ac1d36bfa": "55d1d7d47b170fe5060cd8119e6fb522",
".git/objects/4a/39079e580dc9be820cba2fae41238c49eaa798": "ada1a19fea32fbb6719120809b9eae60",
".git/objects/23/0c4d3d5a52f549cbe32cbf514f4adf5c49ea91": "15331732b27484641c71007d222199e7",
".git/objects/71/7117947090611c3967f8681ab1ac0f79bca7fc": "ad4e74c0da46020e04043b5cf7f91098",
".git/objects/71/7e25ddf97eec67b65a272d9ba201464adac2a8": "f3652980f7d1eb83abc0a9b0985742c4",
".git/objects/76/05197ffa15f46da2b7ab8c6948fb33e94246ca": "37af345cc6decc4dcc1e8e3e03c10869",
".git/objects/1c/47109a767e91e994f53fa228f018d7e0d7c4d4": "0c7535cf56b41cd3cd55e20518f316b3",
".git/objects/1c/d211bffa0900406576d2506ed11168a48ab2c2": "5a0fb5d8330c2f4bb1b7749f2eaf0dd8",
".git/objects/49/e8b14eb7ff6ac978758fe2e4490d341042d442": "f9d8fe72517ef00369847b7490603a1d",
".git/objects/14/61b3b7d4f4d7db75899fc7dfc8f70e3615ef43": "71529f59bfa9fc6ce5ddac6aab2af5c8",
".git/HEAD": "4cf2d64e44205fe628ddd534e1151b58",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "3aaf730ab0629110e93a78116a798564",
".git/logs/refs/heads/master": "3aaf730ab0629110e93a78116a798564",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "ea587b0fae70333bce92257152996e70",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/master": "8cc6b34eb05c8af21b0ce3c9f4271055",
".git/index": "47522d9254a11b890da82407b552e38c",
".git/COMMIT_EDITMSG": "8439beb8b1732c0a2985d22d90c57484",
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
