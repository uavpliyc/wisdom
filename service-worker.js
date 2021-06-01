window.self.addEventListener('install', function(e) {
  console.log('[ServiceWorker] Install');
});
 
window.self.addEventListener('activate', function(e) {
  console.log('[ServiceWorker] Activate');
});
 
window.self.addEventListener('fetch', function(event) {});