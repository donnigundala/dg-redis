# Tagged Cache

Tagged caching allows you to group related cache keys and flush them all at once. This is useful for caching complex data structures or lists where invalidating one item should invalidate the entire group.

## How it Works

When you store a value with tags, `dg-redis` stores the key in a set associated with each tag. When you flush the tags, it retrieves all keys from the tag sets and deletes them.

## Usage

### Storing Tagged Values

```go
// Get tagged cache instance
tagged := driver.Tags("users", "active")

// Store value
err := tagged.Put(ctx, "user:1", user, 1*time.Minute)
```

### Flushing Tags

```go
// Flush all keys associated with "users" OR "active"
err := driver.Tags("users", "active").Flush()
```

## Performance Considerations

- **Writes**: Tagged writes involve additional Redis operations (SADD) to track the keys. This adds a small overhead compared to standard writes.
- **Reads**: Tagged reads are identical to standard reads (GET). There is no performance penalty.
- **Flushing**: Flushing tags involves retrieving all keys (SMEMBERS) and deleting them (DEL). For very large tag sets, this operation can be expensive.

## Best Practices

1. **Use Specific Tags**: Avoid using generic tags like "all" that could contain thousands of keys.
2. **Limit Tag Count**: Don't assign too many tags to a single key, as it increases write overhead.
3. **TTL**: Always set a TTL for tagged items to ensure they are eventually cleaned up even if not flushed.
