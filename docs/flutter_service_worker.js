self.addEventListener("install", e => self.skipWaiting());
self.addEventListener("activate", e => {
  e.waitUntil((async () => {
    try {
      await self.registration.unregister();
      const cs = await self.clients.matchAll({type:"window"});
      for (const c of cs) { c.navigate(c.url); }
    } catch (err) {}
  })());
});
self.addEventListener("fetch", e => {});
