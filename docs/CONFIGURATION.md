# Configuration

`dg-redis` is configured via the `cache.StoreConfig` struct from `dg-cache`.

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `host` | `string` | `localhost` | Redis server hostname |
| `port` | `int` | `6379` | Redis server port |
| `password` | `string` | `""` | Redis password |
| `database` | `int` | `0` | Redis database number |
| `pool_size` | `int` | `10` | Connection pool size |
| `serializer` | `string` | `json` | Serializer to use (`json` or `msgpack`) |

## Example

```go
config := cache.StoreConfig{
    Driver: "redis",
    Prefix: "myapp",
    Options: map[string]interface{}{
        "host":       "localhost",
        "port":       6379,
        "password":   "secret",
        "database":   0,
        "pool_size":  20,
        "serializer": "msgpack", // Use MessagePack for better performance
    },
}

driver, err := redis.NewDriver(config)
```

## Shared Connection

If you want to share the Redis connection with other components (like `dg-queue`), you can create the client manually and pass it to the driver:

```go
// Create shared client
client := redis.NewClient(&redis.Options{
    Addr: "localhost:6379",
})

// Create driver with shared client
driver := redis.NewDriverWithClient(client, "myapp")
```
