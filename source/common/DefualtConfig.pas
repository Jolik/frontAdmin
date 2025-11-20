unit DefualtConfig;

interface

{$IFDEF DEBUG}
const
  DEFAULT_CONFIG_JSON = '''
{
  "port": 8077,
  "base_path": "http://213.167.42.170:8088",
  "logging": {
    "loglevel": "debug",
    "api_calls": false,
    "api_calls_response": false
  },
  "services": {
    "objects": {
      "host": "/objects/api/v1"
    },
    "acl": {
      "host": "/acl/api/v1"
    },
    "strip": {
      "host": "/strip/api/v2"
    },
    "summary": {
      "host": "/summary/api/v2"
    },
    "dsprocessor": {
      "host": "/dsprocessor/api/v1"
    },
    "dsmonitoring": {
      "host": "/dsmonitoring/api/v1"
    },
    "router": {
      "host": "/router/api/v2"
    },
    "datacomm": {
      "host": "/datacomm/api/v1"
    },
    "linkop": {
      "host": "/linkop/api/v1"
    },
    "drvcomm": {
      "host": "/drvcomm/api/v1"
    },
    "management": {
      "host": "/management/api/v1"
    },
    "dataserver": {
      "host": "/dataserver/api/v2"
    },
    "dataspace": {
      "host": "/dataspace/api/v2"
    },
    "signals": {
      "host": "/signals/api/v1"
    },
    "redis": {
      "host": "tcp://redis:6379",
      "key_ttl": 3600
    }
  }
}
''';
{$ELSE}
const
  DEFAULT_CONFIG_JSON = '''
{
  "port": 8077,
  "logging": {
    "loglevel": "debug",
    "api_calls": false,
    "api_calls_response": false
  },
  "services": {
    "objects": {
      "host": "http://objects:8000/api/v1"
    },
    "acl": {
      "host": "http://acl:8001/api/v1"
    },
    "strip": {
      "host": "http://prsstrip:8050/api/v2"
    },
    "summary": {
      "host": "http://summary:8052/api/v2"
    },
    "dsprocessor": {
      "host": "http://dsprocessor:8042/api/v1"
    },
    "dsmonitoring": {
      "host": "http://dsmonitoring:8043/api/v1"
    },
    "router": {
      "host": "http://router:8021/api/v2"
    },
    "datacomm": {
      "host": "http://datacomm:8022/api/v1"
    },
    "linkop": {
      "host": "http://linkop:8023/api/v1"
    },
    "drvcomm": {
      "host": "http://drvcomm:8024/api/v1"
    },
    "management": {
      "host": "http://management:8004/api/v1"
    },
    "dataserver": {
      "host": "http://dataserver:8040/api/v2"
    },
    "dataspace": {
      "host": "http://dataspace:8020/api/v2"
    },
    "signals": {
      "host": "http://signals:8025/api/v1"
    },
    "redis": {
      "host": "tcp://redis:6379",
      "key_ttl": 3600
    }
  }
}
''';
{$ENDIF}

implementation

end.
