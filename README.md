# ⚠️ DEPRECATED - dg-redis

**This package has been merged into [dg-cache](https://github.com/donnigundala/dg-cache) and is no longer maintained.**

## Migration

The Redis cache driver is now part of `dg-cache` as `drivers/redis`.

**Old import (deprecated):**
```go
import "github.com/donnigundala/dg-redis"
```

**New import:**
```go
import "github.com/donnigundala/dg-cache/drivers/redis"
```

## Why Was This Merged?

dg-redis only implemented the `cache.Driver` interface and couldn't be reused by other packages. Having it as a separate module added unnecessary complexity without providing any reusability benefits.

By merging it into `dg-cache`, we now have a cleaner architecture where:
- The Redis driver is included by default
- One less dependency to manage
- Clearer that it's a cache driver, not a general Redis library

## Documentation

For full documentation, see:
- [dg-cache README](https://github.com/donnigundala/dg-cache)
- [dg-cache/drivers/redis API](https://github.com/donnigundala/dg-cache/tree/main/drivers/redis)

## Final Version

This package remains at **v1.1.1** as its final version. All future development happens in dg-cache.

---

**Thank you for using dg-redis! Please migrate to `dg-cache/drivers/redis`.**
