---
url: "https://api.eagle.cool/item/add-from-url"
title: "/api/item/addFromURL | Eagle API Document"
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

1. [Item](https://api.eagle.cool/item)

# /api/item/addFromURL

`POST` Add an image from an address to Eagle App. If you intend to add multiple items in a row, we suggest you use `/api/item/addFromURLs`.

Parameter

Description

url

Required，the URL of the image to be added. Supports `http`、 `https`、 `base64`

name

Required，The name of the image to be added.

website

The Address of the source of the image

tags

Tags for the image.

star

The rating for the image.

annotation

The annotation for the image.

modificationTime

The creation date of the image. The parameter can be used to alter the image's sorting order in Eagle.

folderId

If this parameter is defined, the image will be added to the corresponding folder.

headers

Optional, customize the HTTP headers properties, this could be used to circumvent the security of certain websites.

**Sample Code:**

Copy

```
var data = {
    "url": "https://cdn.dribbble.com/users/674925/screenshots/12020761/media/6420a7ec85751c11e5254282d6124950.png",
    "name": "Work",
    "website": "https://dribbble.com/shots/12020761-Work",
    "tags": ["Illustration", "Design"],
    "modificationTime": 1591325171766,
  "headers": {
    "referer": "dribbble.com"
  }
};

var requestOptions = {
  method: 'POST',
  body: JSON.stringify(data),
  redirect: 'follow'
};

fetch("http://localhost:41595/api/item/addFromURL", requestOptions)
  .then(response => response.json())
  .then(result => console.log(result))
  .catch(error => console.log('error', error));
```

**Results Returned:**

Copy

```
{
    "status": "success"
}
```

[Previous/api/folder/listRecentchevron-left](https://api.eagle.cool/folder/list-recent) [Next/api/item/addFromURLschevron-right](https://api.eagle.cool/item/add-from-urls)

Last updated 1 year ago