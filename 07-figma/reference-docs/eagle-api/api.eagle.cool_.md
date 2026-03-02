---
url: "https://api.eagle.cool/"
title: "Overview | Eagle API Document"
---

bars [![](https://api.eagle.cool/~gitbook/image?url=https%3A%2F%2F333448883-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-legacy-files%2Fo%2Fspaces%252F-MDPqzk7AqEM18swFBYb%252Favatar-1608713798397.png%3Fgeneration%3D1608713799251739%26alt%3Dmedia&width=32&dpr=3&quality=100&sign=b2923bb2&sv=2)![](https://api.eagle.cool/~gitbook/image?url=https%3A%2F%2F333448883-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-legacy-files%2Fo%2Fspaces%252F-MDPqzk7AqEM18swFBYb%252Favatar-1608713798397.png%3Fgeneration%3D1608713799251739%26alt%3Dmedia&width=32&dpr=3&quality=100&sign=b2923bb2&sv=2)\\
Eagle API Document](https://api.eagle.cool/)

search

circle-xmark

`⌘Ctrl`  `k`

[![](https://api.eagle.cool/~gitbook/image?url=https%3A%2F%2F333448883-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-legacy-files%2Fo%2Fspaces%252F-MDPqzk7AqEM18swFBYb%252Favatar-1608713798397.png%3Fgeneration%3D1608713799251739%26alt%3Dmedia&width=32&dpr=3&quality=100&sign=b2923bb2&sv=2)![](https://api.eagle.cool/~gitbook/image?url=https%3A%2F%2F333448883-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-legacy-files%2Fo%2Fspaces%252F-MDPqzk7AqEM18swFBYb%252Favatar-1608713798397.png%3Fgeneration%3D1608713799251739%26alt%3Dmedia&width=32&dpr=3&quality=100&sign=b2923bb2&sv=2)\\
Eagle API Document](https://api.eagle.cool/)

- [Overview](https://api.eagle.cool/)
- Application

  - [/api/application/info](https://api.eagle.cool/application/info)
- Folder

  - [/api/folder/create](https://api.eagle.cool/folder/create)
  - [/api/folder/rename](https://api.eagle.cool/folder/rename)
  - [/api/folder/update](https://api.eagle.cool/folder/update)
  - [/api/folder/list](https://api.eagle.cool/folder/list)
  - [/api/folder/listRecent](https://api.eagle.cool/folder/list-recent)
- Item

  - [/api/item/addFromURL](https://api.eagle.cool/item/add-from-url)
  - [/api/item/addFromURLs](https://api.eagle.cool/item/add-from-urls)
  - [/api/item/addFromPath](https://api.eagle.cool/item/add-from-path)
  - [/api/item/addFromPaths](https://api.eagle.cool/item/add-from-paths)
  - [/api/item/addBookmark](https://api.eagle.cool/item/add-bookmark)
  - [/api/item/info](https://api.eagle.cool/item/info)
  - [/api/item/thumbnail](https://api.eagle.cool/item/thumbnail)
  - [/api/item/list](https://api.eagle.cool/item/list)
  - [/api/item/moveToTrash](https://api.eagle.cool/item/api-item-movetotrash)
  - [/api/item/refreshPalette](https://api.eagle.cool/item/refresh-palette)
  - [/api/item/refreshThumbnail](https://api.eagle.cool/item/refresh-thumbnail)
  - [/api/item/update](https://api.eagle.cool/item/update)
- Library

  - [/api/library/info](https://api.eagle.cool/library/info)
  - [/api/library/history](https://api.eagle.cool/library/history)
  - [/api/library/switch](https://api.eagle.cool/library/switch)
  - [/api/library/icon](https://api.eagle.cool/library/icon)
- Examples

  - [Using Eagle API with Tampermonkey](https://api.eagle.cool/examples/tampermonkey-example)
- [Changelog](https://api.eagle.cool/changelog)

chevron-upchevron-down

[gitbookPowered by GitBook](https://www.gitbook.com/?utm_source=content&utm_medium=trademark&utm_campaign=-MDPqzk7AqEM18swFBYb)

xmark

block-quoteOn this pagechevron-down

- [Server](https://api.eagle.cool/#ll9fq)
- [Format](https://api.eagle.cool/#oxnmu)
- [CORS](https://api.eagle.cool/#id-8ju4d)
- [Limitation](https://api.eagle.cool/#pixpq)
- [Submit Feature Requests](https://api.eagle.cool/#ovjdu)

copyCopychevron-down

# Overview

This is the official document for Eagle API. By releasing Eagle's API, we hope that every user could make the most of these functions and develop more personalized plugins or add-ons to address various needs. In this document, along with the exhaustive introduction to the Eagle API, we also provided some examples for reference to inspire users to make creative plugins on basis of these scripts.

> Remark: By using Eagle API and its derivatives, you represent and warrant that you have read and agree to our [User Agreementarrow-up-right](https://en.eagle.cool/eula) and [Privacy Policyarrow-up-right](https://en.eagle.cool/privacy).

### [hashtag](https://api.eagle.cool/\#ll9fq)    Server

Eagle is a local based application, the Eagle API server will start up when Eagle App is opened, hence you'd have to open Eagle App first to gain access to all function of Eagle API.

### [hashtag](https://api.eagle.cool/\#oxnmu)    Format

All API server will start-up upon opening Eagle App, the default listening port is `41595`, i.e. `http://localhost:41595/` . Results returned will be in `JSON` format.

### [hashtag](https://api.eagle.cool/\#id-8ju4d)    CORS

If you want to use Eagle API in webpages via script extensions like 'Tampermonkey', please call through `GM_xmlhttprequest` to circumvent security policies related to Cross-Origin Resource Sharing.

Copy

```
GM_xmlhttpRequest({
    url: EAGLE_IMPORT_API_URL,
    method: "POST",
    data: JSON.stringify({ items: images, folderId: pageInfo.folderId }),
    onload: function(response) {}
});
```

### [hashtag](https://api.eagle.cool/\#pixpq)    Limitation

Eagle 1.11 Build21 (Released on 2020/06/17) or the latter version is required to gain access to Eagle API.

The performance of the API server is dependant on the device you are currently running Eagle. There is no limit on the number of calls since all connections were done locally. Almost every add-item API function have a respective version for adding multiple items, we suggest you use the multiple ones if you intend to add lots of files.

### [hashtag](https://api.eagle.cool/\#ovjdu)    Submit Feature Requests

The Eagle API has provided most of the functions you would need to create/add items, if you find API insufficient or incapable under some circumstances, feel free to submit your feature request!

**Mail to:** services@eagle.cool
**Title:** Feature Request for Eagle API: A brief description of the requested feature.
**Content:** Please describe the script or extension you are developing, and advise more detail about why the proposed feature is necessary.

[Next/api/application/infochevron-right](https://api.eagle.cool/application/info)

Last updated 3 years ago