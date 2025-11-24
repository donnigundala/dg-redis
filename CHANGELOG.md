# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-11-24

### Added
- **Serialization Support**
  - Automatic marshaling/unmarshaling of complex Go types
  - JSON serializer (default, human-readable)
  - Msgpack serializer (2.6x faster unmarshal, binary format)
  - Type preservation with envelope pattern
- **Complete Serialization Coverage**
  - Updated `Get()` and `GetMultiple()` to deserialize values
  - Updated `Put()` and `PutMultiple()` to serialize values
  - Updated tagged cache `Put()` and `PutMultiple()` methods
  - Backward compatible with raw string values
- **Comprehensive Documentation**
  - Updated README with extensive examples
  - Created docs/API.md (complete API reference)
  - Created docs/TAGGED_CACHE.md (tagged cache guide)
  - Created docs/CONFIGURATION.md (configuration guide)
  - Created CHANGELOG.md
  - Added code examples

### Changed
- `Get()` now automatically deserializes cached values
- `Put()` now automatically serializes values before storing
- `GetMultiple()` deserializes all retrieved values
- `PutMultiple()` serializes all values before storing
- Tagged cache methods now use serialization

### Performance
- Msgpack unmarshal: 2.6x faster than JSON (172ns vs 443ns)
- Msgpack payload: 30-50% smaller than JSON
- Backward compatible fallback for non-serialized data

## [1.0.0] - 2025-11-23

### Added
- Initial release of dg-redis
- Redis driver implementation for dg-cache
- Basic cache operations (Get, Put, Forget, Flush, Has, Missing, Pull)
- Batch operations (GetMultiple, PutMultiple)
- Atomic operations (Increment, Decrement)
- Tagged cache support
  - Tag-based grouping of cache items
  - Tag-based invalidation
  - Multiple tag support
- Configuration options
  - Host, port, password, database
  - Connection pool size
  - Prefix support
- Lua scripts for atomic operations
- Comprehensive test coverage

### Features
- Thread-safe operations
- Context support
- TTL (Time To Live) support
- Prefix support for key namespacing
- Pipeline support for batch operations
- Error handling with typed errors

## [Unreleased]

### Planned
- Integration tests with real Redis
- Benchmark tests
- Connection pooling enhancements
- Retry logic
- Health checks
- Metrics/observability
- Compression support
- Additional serializers (protobuf, avro)

---

## Version History

- **1.1.0** - Serialization support and comprehensive documentation
- **1.0.0** - Initial release with basic Redis caching and tagged cache
