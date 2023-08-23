/*
 * Copyright Redis Ltd. 2018 - present
 * Licensed under your choice of the Redis Source Available License 2.0 (RSALv2) or
 * the Server Side Public License v1 (SSPLv1).
 */

#include "redismodule.h"

// declaration of the type for redis registration
RedisModuleType *GraphContextRedisModuleType;

// declaration of the type for redis registration
RedisModuleType *GraphMetaRedisModuleType;

// AUX load
static int _GraphContextType_AuxLoad
(
	RedisModuleIO *rdb,
	int encver,
	int when
) {
	RedisModule_LoadUnsigned(rdb);
	return REDISMODULE_OK;
}

// RDB load
static void *_GraphContextType_RdbLoad
(
	RedisModuleIO *rdb,
	int encver
) {
	abort();
	return NULL;
}

// register GraphContext type
static int GraphContextType_Register
(
	RedisModuleCtx *ctx
) {
	RedisModuleTypeMethods tm = { 0 };

	tm.version  = 4;
	tm.rdb_load = _GraphContextType_RdbLoad;
	tm.aux_load = _GraphContextType_AuxLoad;

	GraphContextRedisModuleType = RedisModule_CreateDataType(ctx, "graphdata",
			1, &tm);

	if(GraphContextRedisModuleType == NULL) return REDISMODULE_ERR;
	return REDISMODULE_OK;
}

// register GraphMeta type
static int GraphMetaType_Register
(
	RedisModuleCtx *ctx
) {
	RedisModuleTypeMethods tm = { 0 };

	tm.version  = 4;
	tm.rdb_load = _GraphContextType_RdbLoad;

	GraphMetaRedisModuleType = RedisModule_CreateDataType(ctx, "graphmeta",
			1, &tm);

	if(GraphMetaRedisModuleType == NULL) return REDISMODULE_ERR;
	return REDISMODULE_OK;
}

static int _RegisterDataTypes
(
	RedisModuleCtx *ctx
) {
	if(GraphContextType_Register(ctx) == REDISMODULE_ERR) {
		printf("Failed to register GraphContext type\n");
		return REDISMODULE_ERR;
	}

	if(GraphMetaType_Register(ctx) == REDISMODULE_ERR) {
		printf("Failed to register GraphMeta type\n");
		return REDISMODULE_ERR;
	}

	return REDISMODULE_OK;
}

int RedisModule_OnLoad
(
	RedisModuleCtx *ctx,
	RedisModuleString **argv,
	int argc
) {
	if(RedisModule_Init(ctx, "RedisStackCompat", 1, REDISMODULE_APIVER_1)
			== REDISMODULE_ERR) {
		return REDISMODULE_ERR;
	}

	if(_RegisterDataTypes(ctx) != REDISMODULE_OK) return REDISMODULE_ERR;

	return REDISMODULE_OK;
}
 
