# dgcore-redis

Redis driver for the dgcore-cache system.

## Installation

```bash
go get github.com/donnigundala/dg-redis
```

## Usage

```go
import (
    "github.com/donnigundala/dgcore-cache"
    "github.com/donnigundala/dgcore-redis"
)

func main() {
    // Configure
    cfg := cache.DefaultConfig().
        WithStore("redis", cache.StoreConfig{
            Driver: "redis",
            Options: map[string]interface{}{
                "host": "localhost",
                "port": 6379,
            },
        })
    
    // Create manager
    manager, err := cache.NewManager(cfg)
    if err != nil {
        panic(err)
    }

    // Register Redis driver
    manager.RegisterDriver("redis", redis.NewDriver)
}
```

## Configuration Options

- `host` (string): Redis host (default: "localhost")
- `port` (int): Redis port (default: 6379)
- `password` (string): Redis password
- `database` (int): Redis database number
- `pool_size` (int): Connection pool size

## License

MIT
