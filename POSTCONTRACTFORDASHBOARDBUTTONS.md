# Posting to PostedReports — the exact contract (for SSCE Requests / COC dashboards)

**For:** the dashboard session, wiring **SSCE Requests approve/deny** and **COC
submit request** buttons to post JSON into SharePoint **WellControl /
PostedReports**.
**From:** the reporting-tools session.
**Date:** 2026-08-17.
**Source of truth:** copied verbatim out of the shipped **WCGRRT REV 145**, which
is confirmed working in production. Nothing below is reconstructed from memory.

---

## 1. Endpoint

```
https://76e054f3a40ce46e84574bd43fc3ad.06.environment.api.powerplatform.com:443/powerautomate/automations/direct/cu/19/workflows/6dc9957e2cab4d889c3d8a868dc42476/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=1zBOi-67vesw_x-jd937bCL3x2RPdE4gYK6JURimJWg
```

289 characters. **Use it exactly as-is.**

- Do **not** append query parameters. The URL is SAS-signed (`sig=`); adding
  anything after it risks the signature being rejected.
- Do **not** URL-encode it again, and don't let an HTML template turn `&` into
  `&amp;`.
- The `sig` is a bearer credential in a query string — anyone with the URL can
  post. Same exposure the reporting tools already accept, but don't put it
  anywhere more public than the tools already are.

## 2. Request — exactly what WCGRRT sends

**Method** `POST`
**Headers** `Content-Type: application/json` — **required, nothing else**
**Body**

```json
{
  "FileName":    "seadrill-report_West-Vela_2026-08-17.json",
  "ContentType": "application/json",
  "FileContent": "<base64 of the file's text>"
}
```

`FileContent` is the **base64 of the JSON you want written to SharePoint** — not
the JSON itself. `FileName` becomes the SharePoint file name.

## 3. The working implementation, verbatim

```js
const REPORT_POST_URL = 'https://76e054f3a40ce46e84574bd43fc3ad.06.environment.api.powerplatform.com:443/powerautomate/automations/direct/cu/19/workflows/6dc9957e2cab4d889c3d8a868dc42476/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=1zBOi-67vesw_x-jd937bCL3x2RPdE4gYK6JURimJWg';

async function sdPostReport(json, filename) {
  if(!REPORT_POST_URL) return false;
  try{
    const b64 = btoa(unescape(encodeURIComponent(json)));   // UTF-8 safe base64
    const payload = { FileName: filename, ContentType: 'application/json', FileContent: b64 };
    const res = await fetch(REPORT_POST_URL, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) });
    return !!(res && res.ok);
  }catch(e){ return false; }
}
```

### Wiring it to a button

```js
async function onApprove(requestObj){
  const btn = document.getElementById('approveBtn');
  const json = JSON.stringify(requestObj, null, 2);
  const name = 'seadrill-ssce-request_' + slug(requestObj.rig) + '_' + requestObj.date + '_approved.json';
  const old = btn.textContent; btn.disabled = true; btn.textContent = 'Posting…';
  const ok = await sdPostReport(json, name);
  btn.disabled = false; btn.textContent = old;
  alert(ok ? '✓ Posted.\n\n' + name : '⚠ Post failed — nothing was written. Try again.');
}
function slug(s){ return String(s||'').replace(/[^a-z0-9]+/gi,'-').replace(/^-|-$/g,''); }
```

**Disable the button while in flight** — without it, a double-tap writes two files.

## 4. Gotchas — these are the ones that actually bit us

### 4.1 `Content-Type` must be `application/json`

The flow only parses a JSON body. Proven by test: an identical payload sent as
`text/plain` returns **HTTP 202** and **writes no file**. If you see 202s and an
empty library, this is why.

### 4.2 CORS is fine — do not use `mode:'no-cors'`

The endpoint answers the preflight correctly. Tested from
`http://sdrlazneuiis01d.corp.local:8080`: a normal `fetch` with
`application/json` returns **202 / `res.ok === true`** and the file lands.

**Never** use `mode:'no-cors'`. The response becomes opaque, `res.ok` is always
`false`, and you cannot tell a success from a failure. We lost a day to a
`no-cors` fallback that reported "sent" while nothing arrived. Use a plain
`fetch` and trust `res.ok`.

### 4.3 `btoa` throws on any character above U+00FF

`btoa` is Latin-1 only. Real payloads contain `°`, `—`, `✓`, `≥`. Plain
`btoa(json)` raises `InvalidCharacterError`, and if that's inside a `try/catch`
returning `false` you get "post failed" with **no network request at all** —
which looks exactly like an endpoint problem and sends you hunting in the wrong
place.

Always use the wrapper: `btoa(unescape(encodeURIComponent(json)))`.

Console check before blaming anything downstream:

```js
btoa(unescape(encodeURIComponent(JSON.stringify(yourObj)))).length
```

A number means encoding is fine. A throw means this bug.

### 4.4 Check `res.ok`, not `res.status === 200`

The flow returns **202 Accepted**. `res.ok` covers all 2xx.

### 4.5 Size — keep the body small

Small bodies are reliable; multi-hundred-KB bodies have failed with
`TypeError: Failed to fetch` in this environment. Approve/deny and COC request
payloads are a few KB, so this shouldn't affect you — but **don't embed base64
images** in them. If you ever need to, post the record and the attachment
separately.

### 4.6 202 means accepted, not written

A 202 tells you the trigger took the request. The flow can still fail afterwards
(bad `FileName`, SharePoint permissions). **Confirm in the library or the flow's
run history** during development — don't trust the browser alone.

## 5. File naming

The scanner globs `*.json` and routes on the payload contents, not the filename —
but keep names predictable, and **do not** use the `seadrill-report_*` prefix for
these, or they'll be treated as rig-visit reports.

Suggested:

```
seadrill-ssce-request_<rig>_<YYYY-MM-DD>_<approved|denied>.json
seadrill-coc-request_<rig>_<YYYY-MM-DD>.json
```

Rules:
- ASCII, no spaces — slug the rig name (`West Vela` → `West-Vela`).
- Keep the `.json` extension.
- Include something unique (date, or a request id / timestamp). **Same name =
  overwrite**, which is useful for a status change on one request and destructive
  if two different records collide.
- Put rig identity **inside** the JSON as well as in the name — the scanner reads
  the payload, and a name alone won't route it.

## 6. Test sequence

1. Prove the encode in the console (§4.3).
2. Post one tiny record; check `res.ok`.
3. Confirm the file in **WellControl / PostedReports** and open it — verify it
   parses and the content is what you sent.
4. Check the flow's run history for a green run.
5. Only then wire it to the real button, with the disable-while-posting guard.

`POST-DIAGNOSTIC.html` in this folder posts a tiny test file three different ways
and reports exactly which works — run it from the same server as your dashboard if
anything behaves oddly.

## 7. If the DLP policy is ever withdrawn

Posting fails HTTP-not-OK and the flow's HTTP trigger stops accepting requests.
Keep a local fallback (download the JSON) so a user's action isn't lost. See
`DLP Exception Request - Power Automate HTTP Trigger.md`.

---

**Please don't vary the transport.** `application/json`, plain `fetch`, `res.ok`,
UTF-8-safe base64, unmodified URL. Every deviation we tried cost real downtime.
