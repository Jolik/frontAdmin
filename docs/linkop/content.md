# Ресурс "Контент" (content)

Ресурс "Контент" позволяет получить доступ к журнальным записям контента распределенных Оператору

## 1. Получить журнальные записи

**Назначение:**   для получения списка журнальных записей распределенных Оператору.

**Запрос:** `/api/v1/content/:LINK_ID/list`

**Тип запроса:** POST

**Тело запроса:**

```json
{
  "count": 50,
  "startAt": 1500508800,
  "endAt": 1500900877,
  "flag": [
    "forward"
  ]
}
```

**Возможные параметры**:

| **имя поля** | **тип**  | **описание**                                                 |
|--------------|----------|--------------------------------------------------------------|
| `count`      |          | количество выдаваемых записей. По умолчанию 100.             |
| `startAt`    | `int64`  | unixtime начало временного диапазона для поиска сообщений    |
| `endAt`      | `int64`  | unixtime окончание временного диапазона для поиска сообщений |
| `flag`       | `string` | список дополнительных параметров. Возможные варианты:        |
| `-forward`   | `opt`    | поиск в будущее                                              |
| `-body`      | `opt`    | включать ли поле "body" в ответ                              |

Если `count` не указан - выдавать последние 100 записей.

**Ответ:**

```json

{
  "meta": {},
  "response": {
    "jrecs": [
      {
        "id": "33d12082-e7bb-11ef-a4d1-02420a0005a0",
        "traceID": "mxikby1c6bcv8g2dp1s6",
        "usid": null,
        "datasetID": null,
        "name": "PYCA97 RUNW 050000 PAN",
        "metadata": {
          "urn": "",
          "body": "",
          "source": ""
        },
        "key": "PYCA97RUNW",
        "channel": "",
        "topicHierarchy": "",
        "who": "9077c5b1-3b09-4f28-9526-986bdf4c261c",
        "first": "PYCA97 RUNW 050000 PAN...",
        "duplicateID": null,
        "parentID": null,
        "attrs": {
          "AA": "CA",
          "BBB": "PAN",
          "CCCC": "RUNW",
          "DD": "05",
          "HH": "00",
          "II": "97",
          "MM": "00",
          "MT": "0",
          "TT": "PY",
          "from": "192.168.0.109:7785",
          "meta-cccc": "RUNW",
          "meta-meteokind": "WMO",
          "meta-shortheader": "PYCA97 RUNW 050000 PAN",
          "prio": "0"
        },
        "bodyType": "message",
        "body": "UFlDQTk3IFJVTlcgMDUwMDAwIFBBTg0NCkZBWCAwOTkwNSAxMjAgNTc2IDAwMTQgQ09NIEJPRA0NClRhbID65EP85AnUIFDaoFO",
        "hash": "78bc0980999ae0ebe718afa5d432dc39",
        "size": 3269,
        "ext": "",
        "type": "WMO",
        "priority": 2,
        "allowedCompanyIDs": null,
        "ownerID": "",
        "filters": null,
        "fileID": "",
        "filePath": ""
      },
      {
        "id": "fd9fb3ec-e7ba-11ef-a4d1-02420a0005a0",
        "usid": null,
        "datasetID": null,
        "name": "PYCA97 RUNW 050000 PAO",
        "metadata": {
          "urn": "",
          "body": "",
          "source": ""
        },
        "key": "PYCA97RUNW",
        "channel": "",
        "topicHierarchy": "",
        "who": "9077c5b1-3b09-4f28-9526-986bdf4c261c",
        "first": "PYCA97 RUNW 050000 PAO...",
        "duplicateID": null,
        "parentID": null,
        "attrs": {
          "AA": "CA",
          "BBB": "PAO",
          "CCCC": "RUNW",
          "DD": "05",
          "HH": "00",
          "II": "97",
          "MM": "00",
          "MT": "0",
          "TT": "PY",
          "from": "192.168.0.109:7785",
          "meta-cccc": "RUNW",
          "meta-meteokind": "WMO",
          "meta-shortheader": "PYCA97 RUNW 050000 PAO",
          "prio": "0"
        },
        "bodyType": "message",
        "body": "UFlDQTk3IFJVTlcgMDUwMDAwIFBBTw0NCkZBWCAwOTkwNSAxMjAgNTc2IDAwMTUgQ09NIEJPRA0NClRhbGFybmEAAQADAA8AAAA1CgAAxKIAABErAADuWgIAkP8CCrwn8N23fwcFKlxYkKHCPw4Z9vtHMKLAiQH9Cdy3TWBCiAc7WdLOgh6xodwt+GIbxUQ",
        "hash": "3adc475bba0b8f17fd4741e3e916bd9e",
        "size": 2678,
        "ext": "",
        "type": "WMO",
        "priority": 2,
        "allowedCompanyIDs": null,
        "ownerID": "",
        "filters": null,
        "fileID": "",
        "filePath": ""
      }
    ]
  }
}
```

**Возможные поля ответа:**

| **имя поля**        | **тип**       | **описание**                                                                  |
|---------------------|---------------|-------------------------------------------------------------------------------|
| `jrid`              | `string`      | уникальный идентификатор журнальной записи                                    |
| `n`                 | `int64`       | сквозной номер журнальной записи                                              |
| `name`              | `string`      | сокращенных заголовок/имя файла                                               |
| `topic`             | `string`      | топик данных                                                                  |
| `key`               | `string`      | ключ распределения                                                            |
| `TT`                | `string[2]`   | тип данных                                                                    |
| `AA`                | `string[2]`   | регион данных                                                                 |
| `ii`                | `string[2]`   | номер листа данных                                                            |
| `СССС`              | `string[4]`   | центр подачи                                                                  |
| `index`             | `string`      | индекс станции, с которой связано сообщение                                   |
| `metadata`          | `json`        | объект с метаданными связанными с этим данными                                |
| `metadata.urn`      | `string[255]` | уникальный идентификатор метаданных                                           |
| `metadata.source`   | `string`      | индекс источника данных и метаданных                                          |
| `datasets`          | `[]uuid`      | список идентификаторов Наборов данных, к которым относятся данные             |
| `allowed`           | `[]uuid`      | список идентификаторов организаций, которым доступны данные                   |
| `attrs`             | `json`        | объект с произвольными данными                                                |
| `size`              | `int`         | размер в байтах                                                               |
| `who`               | `string`      | уникальный идентификатор интерфейса, который произвел запись                  |
| `bodyType`          | `string`      | тип тела сообщения (message, file)                                            |
| `priority`          | `int`         | приоритет журнальной записи                                                   |
| `double`            | `string`      | уникальный идентификатор дублирующей журнальной записи                        |
| `first`             | `string`      | первые 255 символов от тела сообщения                                         |
| `owner`             | `uuid`        | идентификатор организации которой принадлежит контент                         |
| `parent`            | `uuid`        | идентификатор родительского сообщения (того, с которым связано это сообщение) |
| `usid`              | `uuid`        | идентификатор пользователя который сделал запись                              |
| `datapolicy`        | `string[32]`  | правило доступа к данным                                                      |
| `distribution`      | `string[32]`  | масштаб распространения данных                                                |
| `allowed`           | `uuid`        | массив идентификаторов организаций которым доступны данные                    |
| `file_link.link_id` | `uuid`        | идентификатор внешнего файла (все сообщения вводятся и хранятся как файлы)    |

## 2. Информация по указанной журнальной записи

**Назначение:**   для получения полной информации по идентификатору журнальной записи 

**Запрос:** `/api/v1/content/:LINK_ID/:JREC_ID`

**Тип запроса:** GET

**Возможные параметры**:

| **имя поля** | **тип**  | **описание**                                                                                     |
|--------------|----------|--------------------------------------------------------------------------------------------------|
| `flag`       | `string` | список параметров выдачи. Значения                                                               |
| `-body`      |          | загружать в ответ тело журнальной записи (если оно внедрено в саму запись, а не является файлом) |

**Пример:**  
* `/api/v1/content/592bdd8c-6fa4-11e7-907b-a6006ad3dba0/592bdd8c-6fa4-11e7-907b-a6006ad3dba0?flag=body`

**Ответ:**

```json

{
  "meta": {},
  "response": {
    "jrec": {
      "id": "fd9fb3ec-e7ba-11ef-a4d1-02420a0005a0",
      "usid": null,
      "datasetID": null,
      "name": "PYCA97 RUNW 050000 PAO",
      "metadata": {
        "urn": "",
        "body": "",
        "source": ""
      },
      "key": "PYCA97RUNW",
      "channel": "",
      "topicHierarchy": "",
      "who": "9077c5b1-3b09-4f28-9526-986bdf4c261c",
      "first": "PYCA97 RUNW 050000 PAO...",
      "duplicateID": null,
      "parentID": null,
      "attrs": {
        "AA": "CA",
        "BBB": "PAO",
        "CCCC": "RUNW",
        "DD": "05",
        "HH": "00",
        "II": "97",
        "MM": "00",
        "MT": "0",
        "TT": "PY",
        "from": "192.168.0.109:7785",
        "meta-cccc": "RUNW",
        "meta-meteokind": "WMO",
        "meta-shortheader": "PYCA97 RUNW 050000 PAO",
        "prio": "0"
      },
      "bodyType": "message",
      "body": "UFlDQTk3IFJVTlcgMDUwMDAwIFBBTw0NCkZBWCAwOTkwNSAxMjAgNTc2IDAwMTUgQ09NIEJPRA0NClRhbGFybmEAAQADAA8AAAA1CgAAxKIAABErAADuWgIAkP8CCrwn8N23fwcFKlxYkKHCPw4Z9vtHMKLAiQH9Cdy3TWBCiAc7WdLOgh6xodwt+GIbxUQ",
      "hash": "3adc475bba0b8f17fd4741e3e916bd9e",
      "size": 2678,
      "ext": "",
      "type": "WMO",
      "priority": 2,
      "allowedCompanyIDs": null,
      "ownerID": "",
      "filters": null,
      "fileID": "",
      "filePath": ""
    }
  }
}

``` 

**Возможные поля ответа:**

| **имя поля**        | **тип**       | **описание**                                                                     |
|---------------------|---------------|----------------------------------------------------------------------------------|
| `jrid`              | `string`      | уникальный идентификатор журнальной записи                                       |
| `hash`              | `string`      | md5 хеш тела записи                                                              |
| `name`              | `string`      | сокращенных заголовок/имя файла                                                  |
| `metadata`          | `json`        | объект с метаданными связанными с этим данными                                   |
| `metadata.urn`      | `string[255]` | уникальный идентификатор метаданных                                              |
| `metadata.body`     | `base64`      | уникальный идентификатор метаданных                                              |
| `metadata.source`   | `string`      | индекс источника данных и метаданных                                             |
| `topic`             | `string`      | топик данных                                                                     |
| `key`               | `string`      | ключ распределения                                                               |
| `index`             | `string`      | индекс станции, с которой связано сообщение                                      |
| `owner`             | `uuid`        | идентификатор организации которой принадлежит контент                            |
| `parent`            | `uuid`        | идентификатор родительского сообщения (с которым связано это сообщение)          |
| `usid`              | `uuid`        | идентификатор пользователя которому принадлежит контент                          |
| `datapolicy`        | `string[32]`  | правило доступа к данным                                                         |
| `distribution`      | `string[32]`  | масштаб распространения данных                                                   |
| `allowed`           | `uuid`        | массив идентификаторов организаций которым доступны данные                       |
| `size`              | `int`         | размер в байтах                                                                  |
| `bodyType`          | `string`      | тип тела сообщения (message, file)                                               |
| `double`            | `string`      | уникальный идентификатор дублирующей журнальной записи                           |
| `priority`          | `int`         | приоритет журнальной записи                                                      |
| `who`               | `string`      | уникальный идентификатор интерфейса, который произвел запись                     |
| `attrs`             | `json`        | объект с произвольными данными                                                   |
| `file_link.link_id` | `uuid`        | идентификатор внешнего файла (все сообщения вводим как файлы и храним на диске ) |

## 3. Удалить указанную журнальную запись

**Назначение:**   для удаления журнальной записи по идентификатору 

**Запрос:** `/api/v1/content/:LINK_ID/:JREC_ID/remove`

**Тип запроса:** POST

**Возможные параметры**: нет

**Пример запроса:**
* `/api/v1/content/9077c5b1-3b09-4f28-9526-986bdf4c261c/fd9fb3ec-e7ba-11ef-a4d1-02420a0005a0/remove`

**Ответ:**

```json

{
  "meta": {},
  "response": {
  }
}

```

## 4. Ввести контент в систему

**Назначение:**   для ввода контента в систему.

Метод добавляет запись с контентом в входящий стрим 

Одним запросом можно добавить несколько записей.

**Запрос:** `/api/v1/content/:LINK_ID/input`

**Тип запроса:** POST

**Тело запроса:**

```json

{
  "irecs": [
    {
      "traceID": "wt0qikfj874krxdqeyot",
      "fta_names": [
        "fta_TLF"
      ],
      "data": {
        "meta": {
          "key": "",
          "name": "",
          "date": "",
          "priority": 0,
          "attrs": {
            "from": "192.168.0.109:7785",
            "link_name": "input openmcep cli mitra5:7785 (0f914724-698a-481b-8f86-f832b12ff1d7) of OPENMCEP"
          },
          "source": {
            "id": "0f914724-698a-481b-8f86-f832b12ff1d7"
          },
          "traceid": "wt0qikfj874krxdqeyot"
        },
        "body": "AQ0NCjk5Nw0NCklQUk40MiBSVURHIDA1MTYwMA0NCkJVRlIAAcwCAAASAP//AIAGAAr/GQUFEAASAAAaAD8L3RdaLAoAAQDmAAAAAAABAAAAAgAAAEIAAAGAARIBD8EYDAQIAQcCCAEHAhMFEwYdAR4fHhUeFgUhBiEKKAcGBwYIB0YAHwJBAB8MFQFBAB8CFQEIBwAAAVIAMzk0MDBWb2xnb2dyYWQgICAgICAgICAgIGxur0QItuSBABQCACn///7YGQGQBkAGQAsPoC7ggA3AAz+AAAAmAAAAABf+AAAAnAAAAABX+AAAAoAAAAABP+AAAApgAAAAA/+AAAArAAAAAA3+AAAAsAAAAAAv+AAAAtAAAAAAn+AAAAuAAAAAAj+AAAAugAAAAAb+AAAAvAAAAAAX+AAAAwAAAAAAP+AAAAxAAAB/jj2AAAGSAmgAAAf4AxAAAAAAP+AAAAtgAABnAAIAAAAABf4AAACuAAAObPnAAIAAAAABv4AAACuAAAAAApoABAJwABAAAAAAj+AAAAsgAABmgAEAAAAACf4AAAC0AAAAAC/4AAACwAAAAADf4AAACsAAAAAD/4AAACmAAAAAE/4AAACgAAAAAFf4AAACcAAAAAF/4AAACYAAAAADP4AAeDc3NzcNDQoNDQoD",
        "filepath": "",
        "TraceID": "wt0qikfj874krxdqeyot",
        "ID": "97f58f33-29ca-11f0-bcfb-02420a000098"
      }
    }
  ]
}

```

**Обязательные поля**:

| **имя поля** | **тип**    | **описание**                                                                                      |
|--------------|------------|---------------------------------------------------------------------------------------------------|
| `body`       | `base64`   | тело контента                                                                                     |
| `fta_names`  | `[]string` | список модулей формат-анализа                                                                     |
| `traceID`    | `string`   | идентификатор трассировки. Должен быть таким же как у JR/FAID из которого была создана эта запись |

**Необязательные поля запроса**:

| **имя поля**        | **тип**      | **описание**                                                  |
|---------------------|--------------|---------------------------------------------------------------|

**Ответ:**

```json

{
  "meta": {},
  "response": {
    "irids": [
      "042f5218-71f8-11e7-8cf7-a6006ad3dba0",
      "042f5556-71f8-11e7-8cf7-a6006ad3dba0"
    ]
  }
}

```

**Поля ответа:**

| **имя поля** | **тип** | **описание**                                |
|--------------|---------|---------------------------------------------|
| `irids`      | `array` | массив идентификаторов вставленных записей. |

