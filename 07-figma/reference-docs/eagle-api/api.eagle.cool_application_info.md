---
url: "https://api.eagle.cool/application/info"
title: "/api/application/info | Eagle API Document"
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

copyCopychevron-down

1. [Application](https://api.eagle.cool/application)

# /api/application/info

`GET` Get detailed information on the Eagle App currently running. In most cases, this could be used to determine whether certain functions are available on the user's device.

**Sample Code:**

Copy

```
var requestOptions = {
  method: 'GET',
  redirect: 'follow'
};

fetch("http://localhost:41595/api/application/info", requestOptions)
  .then(response => response.json())
  .then(result => console.log(result))
  .catch(error => console.log('error', error));
```

**Results Returned:**

Copy

```
{
    "status": "success",
    "data": {
        "version": "1.11.0",
        "prereleaseVersion": null,
        "buildVersion": "20200612",
        "execPath": "/Users/augus/Projects/Eagle App/node_modules/electron/dist/Electron.app/Contents/Frameworks/Electron Helper (Renderer).app/Contents/MacOS/Electron Helper (Renderer)",
        "platform": "darwin"
    }
}
```

[PreviousOverviewchevron-left](https://api.eagle.cool/) [Next/api/folder/createchevron-right](https://api.eagle.cool/folder/create)

Last updated 5 years ago