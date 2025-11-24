# API Reference

## Driver

### `redis.NewDriver(config cache.StoreConfig) (cache.Driver, error)`
Creates a new Redis cache driver with its own connection.

### `redis.NewDriverWithClient(client *redis.Client, prefix string) *Driver`
Creates a new Redis cache driver using an existing Redis client. This is useful for sharing connections with other components (like `dg-queue`).

## Methods

### `Put(ctx context.Context, key string, value interface{}, ttl time.Duration) error`
Stores a value in the cache with a TTL.

### `Get(ctx context.Context, key string) (interface{}, error)`
Retrieves a value from the cache. Returns `cache.ErrKeyNotFound` if the key does not exist.

### `PutMultiple(ctx context.Context, values map[string]interface{}, ttl time.Duration) error`
Stores multiple values in the cache in a single operation (pipeline).

### `GetMultiple(ctx context.Context, keys []string) (map[string]interface{}, error)`
Retrieves multiple values from the cache in a single operation (pipeline).

### `Increment(ctx context.Context, key string, value int64) (int64, error)`
Increments a numeric value in the cache.

### `Decrement(ctx context.Context, key string, value int64) (int64, error)`
Decrements a numeric value in the cache.

### `Forget(ctx context.Context, key string) error`
Removes a key from the cache.

### `Flush(ctx context.Context) error`
Removes all keys from the cache (matching the prefix).

### `Tags(names ...string) cache.TaggedCache`
Returns a tagged cache instance for grouping related keys.

## Tagged Cache

### `Put(ctx context.Context, key string, value interface{}, ttl time.Duration) error`
Stores a tagged value.

### `PutMultiple(ctx context.Context, values map[string]interface{}, ttl time.Duration) error`
Stores multiple tagged values.

### `Flush() error`
Removes all keys associated with the tags.
