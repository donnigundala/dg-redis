# dg-redis

[![Go Version](https://img.shields.io/badge/Go-%3E%3D%201.21-blue)](https://go.dev/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

Redis driver for dg-cache with automatic serialization, tagged cache support, and production-ready features.

## Features

### 🚀 Core Features
- **Automatic Serialization**: Marshal/unmarshal complex Go types automatically
- **Multiple Serializers**: JSON (default) and Msgpack (2.6x faster)
- **Tagged Cache**: Group and invalidate related cache items
- **Type Preservation**: Store type information for safe deserialization
- **Backward Compatible**: Works with existing string-based caches

### ⚡ Performance
- **Msgpack**: 2.6x faster unmarshal than JSON
- **Pipeline Support**: Batch operations for better performance
- **Connection Pooling**: Configurable pool size
- **Efficient Storage**: 30-50% smaller payloads with msgpack

## Installation

```bash
go get github.com/donnigundala/dg-redis@latest
go get github.com/donnigundala/dg-cache@latest
```

## Quick Start

### Basic Usage

```go
package main

import (
    "context"
    "time"
    
    "github.com/donnigundala/dg-cache"
    "github.com/donnigundala/dg-redis"
)

func main() {
    // Configure cache with Redis
    config := cache.Config{
        DefaultStore: "redis",
        Stores: map[string]cache.StoreConfig{
            "redis": {
                Driver: "redis",
                Options: map[string]interface{}{
                    "host": "localhost",
                    "port": 6379,
                },
            },
        },
    }
    
    // Create manager
    manager, _ := cache.NewManager(config)
    manager.RegisterDriver("redis", redis.NewDriver)
    
    ctx := context.Background()
    
    // Cache any Go type!
    type User struct {
        ID   int
        Name string
    }
    
    user := User{ID: 1, Name: "John"}
    manager.Put(ctx, "user:1", user, 1*time.Hour)
    
    // Retrieve with type safety
    var cached User
    manager.GetAs(ctx, "user:1", &cached)
}
```

### With Msgpack Serializer

```go
config := cache.Config{
    DefaultStore: "redis",
    Stores: map[string]cache.StoreConfig{
        "redis": {
            Driver: "redis",
            Options: map[string]interface{}{
                "host":       "localhost",
                "port":       6379,
                "serializer": "msgpack",  // 2.6x faster!
            },
        },
    },
}
```

### Tagged Cache

```go
// Tag related cache items
manager.Tags("users", "active").Put(ctx, "user:1", user, 0)
manager.Tags("users", "active").Put(ctx, "user:2", user2, 0)
manager.Tags("users").Put(ctx, "user:3", user3, 0)

// Flush all items with specific tags
manager.Tags("active").Flush(ctx)  // Removes user:1 and user:2
```

## Configuration

### Basic Configuration

```go
Options: map[string]interface{}{
    "host":     "localhost",  // Redis host
    "port":     6379,          // Redis port
    "password": "",            // Redis password (optional)
    "database": 0,             // Redis database number
    "pool_size": 10,           // Connection pool size
}
```

### With Serialization

```go
Options: map[string]interface{}{
    "host":       "localhost",
    "port":       6379,
    "serializer": "msgpack",  // "json" or "msgpack"
}
```

### Full Configuration

```go
config := cache.Config{
    DefaultStore: "redis",
    Prefix:       "myapp",  // Global prefix
    Stores: map[string]cache.StoreConfig{
        "redis": {
            Driver: "redis",
            Prefix: "cache",  // Store-specific prefix
            Options: map[string]interface{}{
                "host":       "localhost",
                "port":       6379,
                "password":   "secret",
                "database":   0,
                "pool_size":  10,
                "serializer": "msgpack",
            },
        },
    },
}
```

## Serialization

### Supported Types

```go
// Primitives
cache.Put(ctx, "string", "hello", 0)
cache.Put(ctx, "int", 42, 0)
cache.Put(ctx, "float", 3.14, 0)
cache.Put(ctx, "bool", true, 0)

// Structs
type User struct {
    ID   int
    Name string
}
cache.Put(ctx, "user", User{ID: 1, Name: "John"}, 0)

// Slices
cache.Put(ctx, "items", []int{1, 2, 3}, 0)

// Maps
cache.Put(ctx, "config", map[string]string{"key": "value"}, 0)

// Nested structures
type Address struct {
    Street string
    City   string
}
type Person struct {
    Name    string
    Address Address
}
cache.Put(ctx, "person", Person{...}, 0)
```

### Type-Safe Retrieval

```go
// Using GetAs
var user User
if err := cache.GetAs(ctx, "user:1", &user); err != nil {
    // Handle error
}

// Using typed helpers
name, _ := cache.GetString(ctx, "name")
age, _ := cache.GetInt(ctx, "age")
price, _ := cache.GetFloat64(ctx, "price")
active, _ := cache.GetBool(ctx, "active")
```

## Tagged Cache

### Basic Usage

```go
// Create tagged cache
tagged := manager.Tags("users", "active")

// Store with tags
tagged.Put(ctx, "user:1", user, 1*time.Hour)
tagged.Put(ctx, "user:2", user2, 1*time.Hour)

// Retrieve (same as regular cache)
val, _ := tagged.Get(ctx, "user:1")

// Flush all items with these tags
tagged.Flush(ctx)
```

### Multiple Tag Sets

```go
// Tag with multiple sets
manager.Tags("users").Put(ctx, "user:1", user, 0)
manager.Tags("users", "premium").Put(ctx, "user:2", user2, 0)
manager.Tags("users", "active").Put(ctx, "user:3", user3, 0)

// Flush by specific tags
manager.Tags("premium").Flush(ctx)  // Only user:2
manager.Tags("active").Flush(ctx)   // Only user:3
manager.Tags("users").Flush(ctx)    // All users
```

### Use Cases

```go
// Invalidate user-related caches
manager.Tags("user:"+userID).Put(ctx, "profile", profile, 0)
manager.Tags("user:"+userID).Put(ctx, "settings", settings, 0)
manager.Tags("user:"+userID).Flush(ctx)  // Clear all user data

// Invalidate by entity type
manager.Tags("posts").Put(ctx, "post:1", post, 0)
manager.Tags("posts").Put(ctx, "post:2", post2, 0)
manager.Tags("posts").Flush(ctx)  // Clear all posts
```

## Performance

### Benchmarks

```
BenchmarkJSON_Marshal        7,542,747    152.6 ns/op    128 B/op    2 allocs/op
BenchmarkMsgpack_Marshal     5,384,852    210.9 ns/op    272 B/op    4 allocs/op
BenchmarkJSON_Unmarshal      2,329,303    443.5 ns/op    216 B/op    4 allocs/op
BenchmarkMsgpack_Unmarshal   6,601,837    172.1 ns/op     96 B/op    2 allocs/op
```

**Key Insights:**
- Msgpack unmarshal is **2.6x faster** than JSON
- Msgpack payloads are **30-50% smaller**
- Both are extremely fast for typical cache operations

### Choosing a Serializer

**JSON** (default):
- Human-readable
- Easy to debug
- Good for development

**Msgpack**:
- 2.6x faster unmarshal
- 30-50% smaller payloads
- Better for production

## Examples

See the [examples](./examples) directory for complete working examples:

- [01-basic](./examples/01-basic) - Basic caching operations
- [02-serialization](./examples/02-serialization) - Complex type caching
- [03-tagged-cache](./examples/03-tagged-cache) - Tagged cache usage

## API Reference

See [docs/API.md](./docs/API.md) for complete API documentation.

### Core Methods

```go
// Basic operations
Get(ctx, key) (interface{}, error)
Put(ctx, key, value, ttl) error
Forget(ctx, key) error
Flush(ctx) error

// Batch operations
GetMultiple(ctx, keys) (map[string]interface{}, error)
PutMultiple(ctx, items, ttl) error

// Atomic operations
Increment(ctx, key, value) (int64, error)
Decrement(ctx, key, value) (int64, error)

// Tagged cache
Tags(tags...) TaggedStore
```

## Testing

```bash
# Run tests
go test ./...

# Run with coverage
go test ./... -cover

# Run benchmarks
go test -bench=. -benchmem
```

## Best Practices

### 1. Use Msgpack in Production

```go
Options: map[string]interface{}{
    "serializer": "msgpack",  // Faster and smaller
}
```

### 2. Use Type-Safe Helpers

```go
// Good
var user User
cache.GetAs(ctx, "user:1", &user)

// Avoid
val, _ := cache.Get(ctx, "user:1")
user := val.(User)  // Can panic!
```

### 3. Use Tags for Related Data

```go
// Group related cache items
manager.Tags("user:"+userID).Put(ctx, "profile", profile, 0)
manager.Tags("user:"+userID).Put(ctx, "settings", settings, 0)

// Easy invalidation
manager.Tags("user:"+userID).Flush(ctx)
```

### 4. Set Appropriate TTLs

```go
// Short-lived data
cache.Put(ctx, "session:"+id, session, 15*time.Minute)

// Long-lived data
cache.Put(ctx, "config", config, 24*time.Hour)

// Permanent (until manually deleted)
cache.Put(ctx, "static", data, 0)
```

## Migration Guide

### From String-Based Caching

```go
// Before
userJSON, _ := json.Marshal(user)
cache.Put(ctx, "user:1", string(userJSON), 0)

val, _ := cache.Get(ctx, "user:1")
json.Unmarshal([]byte(val.(string)), &user)

// After
cache.Put(ctx, "user:1", user, 0)
cache.GetAs(ctx, "user:1", &user)
```

### From go-redis Directly

```go
// Before
client := redis.NewClient(&redis.Options{...})
client.Set(ctx, "key", value, 0)
val := client.Get(ctx, "key").Val()

// After
manager.Put(ctx, "key", value, 0)
val, _ := manager.Get(ctx, "key")
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Related Packages

- [dg-cache](https://github.com/donnigundala/dg-cache) - Cache abstraction layer
- [dg-core](https://github.com/donnigundala/dg-core) - Core framework

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history.
