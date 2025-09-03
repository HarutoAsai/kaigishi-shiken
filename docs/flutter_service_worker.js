self.addEventListener("install", e => self.skipWaiting());
self.addEventListener("activate", e => {
  e.waitUntil((async () => {
    try {
      await self.registration.unregister();
      const clientsArr = await self.clients.matchAll({type:"window"});
      for (const c of clientsArr) { c.navigate(c.url); }
    } catch (err) {}
  })());
});
// 何もしない（ネットに任せる）
self.addEventListener("fetch", e => {});
