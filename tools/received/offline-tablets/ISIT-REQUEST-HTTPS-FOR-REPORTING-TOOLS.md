**To:** ISIT
**From:** Dan Plant, Technical Services — Subsea
**Subject:** HTTPS for the Technical Services reporting tools on sdrlazneuiis01d, so rig tablets can use them offline

Hello,

I'd like HTTPS enabled for the web site on **sdrlazneuiis01d.corp.local** that serves our subsea reporting tools, please.

**Why**

Our crews fill in their daily, test and inspection reports in two browser tools hosted on this server:

- SSORT, at `/SSORT/index.html`;
- WCGRRT, at `/sacred/WCE Rig Vist Reporting Tool V0.html`.

We want the crews to use them on **iPads and Android tablets on the rig, including with no connection**: install once, work
offline, and send the reports when the connection returns.

Browsers only allow a web page to be installed for offline use ("Add to Home Screen" on iPad, "Install app" on Android) when the
page is served over **HTTPS**. Today the site answers only on **HTTP, port 8080**. I checked 443, 8443 and HTTPS on 8080, and none
of them answers. So a home-screen icon on a tablet is just a bookmark, and it fails with no signal.

**What we need**

1. **An HTTPS binding** on the IIS site that serves `/SSORT/` and `/sacred/`.
   - Port 443 is preferred.
   - The certificate should be for `sdrlazneuiis01d.corp.local`, or a friendlier name if you prefer one, for example
     `reporting.corp.local`.
2. **A certificate the tablets trust.** For a `.corp.local` name I assume that means our internal CA.
   - **Can the CA's root certificate be pushed to the managed iPads and Android tablets through Intune**, if it isn't already?
   - Without that, the tablets will refuse the page.
3. **Two MIME types** in IIS, if they're not already there:
   - `.webmanifest` → `application/manifest+json`;
   - `.js` → `text/javascript`.

   We will add a small manifest file and an offline script beside each tool.
4. **No caching on one file.** Please send `Cache-Control: no-cache` for the offline script (`sw.js`), so tablets pick up new
   revisions when they next connect. If you'd rather, I can do this with a `web.config` in each folder.
5. **Keep HTTP 8080 working**, or redirect it to HTTPS. Rigs and the training pack have the current links bookmarked.

**What does not change**

- **Posting.** The tools post reports to our Power Automate intake on Power Platform (`*.environment.api.powerplatform.com`),
  not to this server. This request doesn't touch that path or its security.
- **Outside resources.** The tools are single self-contained files and load nothing from other sites.
- **The tools' content and the dashboards** on the same site. They only gain an HTTPS address.

**Optional, if Intune can do it**

Push the two tools to the managed tablets as **home-screen web apps**, as web clips on iPad and a managed Chrome shortcut on
Android. That way nobody has to install them by hand.

**Questions for you**

1. **The server move.** I understand the server is moving on 18 October. Can HTTPS be part of the new server's setup? Will the host
   name stay the same?
2. **The address.** Is `.corp.local` with the internal CA the right route? Or would you rather host the tools somewhere already on
   HTTPS that tablets can reach?
3. **Tablet access.** Can rig tablets reach this server at all, on the rig network or over VPN? The first install on each tablet
   needs a connection to it, once. After that they work offline.

**Timing**

We're in a tools freeze for a training class on 19–20 October, so nothing changes on our side before then. Ideally HTTPS is in
place by the end of October, and I'll build the offline version of the tools against it.

Happy to walk through it on a call.

Thanks,
Dan Plant
Technical Services — Subsea
