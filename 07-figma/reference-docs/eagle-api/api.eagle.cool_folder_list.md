---
url: "https://api.eagle.cool/folder/list"
title: "/api/folder/list | Eagle API Document"
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

1. [Folder](https://api.eagle.cool/folder)

# /api/folder/list

`GET` Get the list of folders of the current library.

**Sample Code:**

Copy

```
var requestOptions = {
  method: 'GET',
  redirect: 'follow'
};

fetch("http://localhost:41595/api/folder/list", requestOptions)
  .then(response => response.json())
  .then(result => console.log(result))
  .catch(error => console.log('error', error));
```

**Results Returned:**

Copy

```
{
    "status": "success",
    "data": [\
        {\
            "id": "JMHB2Y3Y3AA75",\
            "name": "UI Design",\
            "description": "",\
            "children": [],\
            "modificationTime": 1537854867502,\
            "tags": [],\
            "imageCount": 33,\
            "descendantImageCount": 33,\
            "pinyin": "UI Design",\
            "extendTags": []\
        },\
        {\
            "id": "JMHB2Y3Y3AA76",\
            "name": "Post Design",\
            "description": "",\
            "children": [],\
            "modificationTime": 1487586362384,\
            "tags": [],\
            "imageCount": 2800,\
            "descendantImageCount": 2800,\
            "pinyin": "Post Design",\
            "extendTags": []\
        },\
        {\
            "id": "JMHB2Y3Y3AA77",\
            "name": "Movie Post Design",\
            "description": "",\
            "children": [],\
            "modificationTime": 1487586529221,\
            "tags": [],\
            "imageCount": 449,\
            "descendantImageCount": 449,\
            "pinyin": "Movie Post Design",\
            "extendTags": []\
        },\
        {\
            "id": "JMHB2Y3Y3AA78",\
            "name": "Business Card Design",\
            "description": "",\
            "children": [],\
            "modificationTime": 1494390324202,\
            "tags": [\
                "Business Card"\
            ],\
            "imageCount": 1236,\
            "descendantImageCount": 1236,\
            "pinyin": "Business Card Design",\
            "extendTags": [\
                "Business Card"\
            ]\
        }\
    ]
}
```

[Previous/api/folder/updatechevron-left](https://api.eagle.cool/folder/update) [Next/api/folder/listRecentchevron-right](https://api.eagle.cool/folder/list-recent)

Last updated 5 years ago