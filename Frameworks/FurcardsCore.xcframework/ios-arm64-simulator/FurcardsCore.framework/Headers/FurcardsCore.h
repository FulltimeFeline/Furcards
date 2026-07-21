#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSError.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSString.h>
#import <Foundation/NSValue.h>

@class FurcardsCoreAntiStormPolicyCompanion, FurcardsCoreBlocklist, FurcardsCoreBloomFilter, FurcardsCoreBloomFilterCompanion, FurcardsCoreCardCaps, FurcardsCoreCardCategory, FurcardsCoreCardCategoryCompanion, FurcardsCoreCardColor, FurcardsCoreCardColorCompanion, FurcardsCoreCardMapping, FurcardsCoreCardPattern, FurcardsCoreCardPatternCompanion, FurcardsCoreCardPayload, FurcardsCoreCardPayloadCompanion, FurcardsCoreCardSupersession, FurcardsCoreCardTemplate, FurcardsCoreCardTemplateCompanion, FurcardsCoreCardTheme, FurcardsCoreCardThemeCompanion, FurcardsCoreChunking, FurcardsCoreCryptoRegistry, FurcardsCoreDutyCycle, FurcardsCoreEncounter, FurcardsCoreEncounterCompanion, FurcardsCoreEncounterKind, FurcardsCoreEncounterKindCompanion, FurcardsCoreEphemeralId, FurcardsCoreExchangeRunnerCompanion, FurcardsCoreExchangeSession, FurcardsCoreExchangeSessionActionComplete, FurcardsCoreExchangeSessionActionFail, FurcardsCoreExchangeSessionActionSend, FurcardsCoreExchangeSessionCompanion, FurcardsCoreExchangeSessionFailReason, FurcardsCoreExchangeSessionLocalIdentity, FurcardsCoreExchangeSessionSessionResult, FurcardsCoreExportBundle, FurcardsCoreExportPayload, FurcardsCoreExportPayloadCompanion, FurcardsCoreFramePipeDecoderCompanion, FurcardsCoreFramePipeEncoderCompanion, FurcardsCoreFrames, FurcardsCoreFurcard, FurcardsCoreFurcardCompanion, FurcardsCoreGossip, FurcardsCoreHello, FurcardsCoreHelloCompanion, FurcardsCoreIdentity, FurcardsCoreIdentityManagerCompanion, FurcardsCoreKotlinArray<T>, FurcardsCoreKotlinByteArray, FurcardsCoreKotlinByteIterator, FurcardsCoreKotlinCancellationException, FurcardsCoreKotlinEnum<E>, FurcardsCoreKotlinEnumCompanion, FurcardsCoreKotlinException, FurcardsCoreKotlinIllegalStateException, FurcardsCoreKotlinNothing, FurcardsCoreKotlinRuntimeException, FurcardsCoreKotlinThrowable, FurcardsCoreKotlinUnit, FurcardsCoreKotlinx_serialization_cborCbor, FurcardsCoreKotlinx_serialization_cborCborConfiguration, FurcardsCoreKotlinx_serialization_cborCborDefault, FurcardsCoreKotlinx_serialization_coreSerialKind, FurcardsCoreKotlinx_serialization_coreSerializersModule, FurcardsCoreL2capFraming, FurcardsCorePayloadColor, FurcardsCorePayloadColorCompanion, FurcardsCorePayloadSocial, FurcardsCorePayloadSocialCompanion, FurcardsCorePayloadTheme, FurcardsCorePayloadThemeCompanion, FurcardsCorePbkdf2, FurcardsCoreSecureStorageRegistry, FurcardsCoreSha256, FurcardsCoreSignedCard, FurcardsCoreSignedCardCompanion, FurcardsCoreSocialLink, FurcardsCoreSocialLinkCompanion, FurcardsCoreSocialPlatform, FurcardsCoreSocialPlatformCompanion, FurcardsCoreSocialVisibility, FurcardsCoreSocialVisibilityCompanion, FurcardsCoreVerifiedCard;

@protocol FurcardsCoreCryptoProvider, FurcardsCoreExchangeSessionAction, FurcardsCoreExchangeTransport, FurcardsCoreKotlinAnnotation, FurcardsCoreKotlinComparable, FurcardsCoreKotlinCoroutineContext, FurcardsCoreKotlinCoroutineContextElement, FurcardsCoreKotlinCoroutineContextKey, FurcardsCoreKotlinIterator, FurcardsCoreKotlinKAnnotatedElement, FurcardsCoreKotlinKClass, FurcardsCoreKotlinKClassifier, FurcardsCoreKotlinKDeclarationContainer, FurcardsCoreKotlinSequence, FurcardsCoreKotlinx_coroutines_coreChannelIterator, FurcardsCoreKotlinx_coroutines_coreCoroutineScope, FurcardsCoreKotlinx_coroutines_coreDisposableHandle, FurcardsCoreKotlinx_coroutines_coreReceiveChannel, FurcardsCoreKotlinx_coroutines_coreSelectClause, FurcardsCoreKotlinx_coroutines_coreSelectClause1, FurcardsCoreKotlinx_coroutines_coreSelectInstance, FurcardsCoreKotlinx_serialization_coreBinaryFormat, FurcardsCoreKotlinx_serialization_coreCompositeDecoder, FurcardsCoreKotlinx_serialization_coreCompositeEncoder, FurcardsCoreKotlinx_serialization_coreDecoder, FurcardsCoreKotlinx_serialization_coreDeserializationStrategy, FurcardsCoreKotlinx_serialization_coreEncoder, FurcardsCoreKotlinx_serialization_coreKSerializer, FurcardsCoreKotlinx_serialization_coreSerialDescriptor, FurcardsCoreKotlinx_serialization_coreSerialFormat, FurcardsCoreKotlinx_serialization_coreSerializationStrategy, FurcardsCoreKotlinx_serialization_coreSerializersModuleCollector, FurcardsCoreSecureStorage;

NS_ASSUME_NONNULL_BEGIN
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-warning-option"
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wnullability"

#pragma push_macro("_Nullable_result")
#if !__has_feature(nullability_nullable_result)
#undef _Nullable_result
#define _Nullable_result _Nullable
#endif

__attribute__((swift_name("KotlinBase")))
@interface FurcardsCoreBase : NSObject
- (instancetype)init __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
+ (void)initialize __attribute__((objc_requires_super));
@end

@interface FurcardsCoreBase (FurcardsCoreBaseCopying) <NSCopying>
@end

__attribute__((swift_name("KotlinMutableSet")))
@interface FurcardsCoreMutableSet<ObjectType> : NSMutableSet<ObjectType>
@end

__attribute__((swift_name("KotlinMutableDictionary")))
@interface FurcardsCoreMutableDictionary<KeyType, ObjectType> : NSMutableDictionary<KeyType, ObjectType>
@end

@interface NSError (NSErrorFurcardsCoreKotlinException)
@property (readonly) id _Nullable kotlinException;
@end

__attribute__((swift_name("KotlinNumber")))
@interface FurcardsCoreNumber : NSNumber
- (instancetype)initWithChar:(char)value __attribute__((unavailable));
- (instancetype)initWithUnsignedChar:(unsigned char)value __attribute__((unavailable));
- (instancetype)initWithShort:(short)value __attribute__((unavailable));
- (instancetype)initWithUnsignedShort:(unsigned short)value __attribute__((unavailable));
- (instancetype)initWithInt:(int)value __attribute__((unavailable));
- (instancetype)initWithUnsignedInt:(unsigned int)value __attribute__((unavailable));
- (instancetype)initWithLong:(long)value __attribute__((unavailable));
- (instancetype)initWithUnsignedLong:(unsigned long)value __attribute__((unavailable));
- (instancetype)initWithLongLong:(long long)value __attribute__((unavailable));
- (instancetype)initWithUnsignedLongLong:(unsigned long long)value __attribute__((unavailable));
- (instancetype)initWithFloat:(float)value __attribute__((unavailable));
- (instancetype)initWithDouble:(double)value __attribute__((unavailable));
- (instancetype)initWithBool:(BOOL)value __attribute__((unavailable));
- (instancetype)initWithInteger:(NSInteger)value __attribute__((unavailable));
- (instancetype)initWithUnsignedInteger:(NSUInteger)value __attribute__((unavailable));
+ (instancetype)numberWithChar:(char)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedChar:(unsigned char)value __attribute__((unavailable));
+ (instancetype)numberWithShort:(short)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedShort:(unsigned short)value __attribute__((unavailable));
+ (instancetype)numberWithInt:(int)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedInt:(unsigned int)value __attribute__((unavailable));
+ (instancetype)numberWithLong:(long)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedLong:(unsigned long)value __attribute__((unavailable));
+ (instancetype)numberWithLongLong:(long long)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value __attribute__((unavailable));
+ (instancetype)numberWithFloat:(float)value __attribute__((unavailable));
+ (instancetype)numberWithDouble:(double)value __attribute__((unavailable));
+ (instancetype)numberWithBool:(BOOL)value __attribute__((unavailable));
+ (instancetype)numberWithInteger:(NSInteger)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedInteger:(NSUInteger)value __attribute__((unavailable));
@end

__attribute__((swift_name("KotlinByte")))
@interface FurcardsCoreByte : FurcardsCoreNumber
- (instancetype)initWithChar:(char)value;
+ (instancetype)numberWithChar:(char)value;
@end

__attribute__((swift_name("KotlinUByte")))
@interface FurcardsCoreUByte : FurcardsCoreNumber
- (instancetype)initWithUnsignedChar:(unsigned char)value;
+ (instancetype)numberWithUnsignedChar:(unsigned char)value;
@end

__attribute__((swift_name("KotlinShort")))
@interface FurcardsCoreShort : FurcardsCoreNumber
- (instancetype)initWithShort:(short)value;
+ (instancetype)numberWithShort:(short)value;
@end

__attribute__((swift_name("KotlinUShort")))
@interface FurcardsCoreUShort : FurcardsCoreNumber
- (instancetype)initWithUnsignedShort:(unsigned short)value;
+ (instancetype)numberWithUnsignedShort:(unsigned short)value;
@end

__attribute__((swift_name("KotlinInt")))
@interface FurcardsCoreInt : FurcardsCoreNumber
- (instancetype)initWithInt:(int)value;
+ (instancetype)numberWithInt:(int)value;
@end

__attribute__((swift_name("KotlinUInt")))
@interface FurcardsCoreUInt : FurcardsCoreNumber
- (instancetype)initWithUnsignedInt:(unsigned int)value;
+ (instancetype)numberWithUnsignedInt:(unsigned int)value;
@end

__attribute__((swift_name("KotlinLong")))
@interface FurcardsCoreLong : FurcardsCoreNumber
- (instancetype)initWithLongLong:(long long)value;
+ (instancetype)numberWithLongLong:(long long)value;
@end

__attribute__((swift_name("KotlinULong")))
@interface FurcardsCoreULong : FurcardsCoreNumber
- (instancetype)initWithUnsignedLongLong:(unsigned long long)value;
+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value;
@end

__attribute__((swift_name("KotlinFloat")))
@interface FurcardsCoreFloat : FurcardsCoreNumber
- (instancetype)initWithFloat:(float)value;
+ (instancetype)numberWithFloat:(float)value;
@end

__attribute__((swift_name("KotlinDouble")))
@interface FurcardsCoreDouble : FurcardsCoreNumber
- (instancetype)initWithDouble:(double)value;
+ (instancetype)numberWithDouble:(double)value;
@end

__attribute__((swift_name("KotlinBoolean")))
@interface FurcardsCoreBoolean : FurcardsCoreNumber
- (instancetype)initWithBool:(BOOL)value;
+ (instancetype)numberWithBool:(BOOL)value;
@end


/**
 * the one piece of crypto the core cant do itself: ed25519. hashing (sha-256,
 * hmac) is pure kotlin in [Sha256] so it runs everywhere; signatures need the
 * platform (CryptoKit on ios, tink on android) because reimplementing ed25519
 * by hand is not a risk worth taking.
 *
 * signatures from either platform must cross-verify - the golden vectors in
 * commonTest/resources/vectors pin the exact bytes both sides must produce.
 */
__attribute__((swift_name("CryptoProvider")))
@protocol FurcardsCoreCryptoProvider
@required

/** null on any authentication/format failure */
- (FurcardsCoreKotlinByteArray * _Nullable)aesGcmOpenKey:(FurcardsCoreKotlinByteArray *)key nonce:(FurcardsCoreKotlinByteArray *)nonce ciphertext:(FurcardsCoreKotlinByteArray *)ciphertext __attribute__((swift_name("aesGcmOpen(key:nonce:ciphertext:)")));

/**
 * aes-256-gcm for the export bundle (javax.crypto on android, CryptoKit
 * on ios). [nonce] is 12 bytes; returns ciphertext with the 16-byte tag
 * appended. both platforms must interoperate - the export bundle written
 * on one is opened on the other.
 */
- (FurcardsCoreKotlinByteArray *)aesGcmSealKey:(FurcardsCoreKotlinByteArray *)key nonce:(FurcardsCoreKotlinByteArray *)nonce plaintext:(FurcardsCoreKotlinByteArray *)plaintext __attribute__((swift_name("aesGcmSeal(key:nonce:plaintext:)")));

/** fresh 32-byte ed25519 private seed from a cryptographically secure rng */
- (FurcardsCoreKotlinByteArray *)generatePrivateKey __attribute__((swift_name("generatePrivateKey()")));

/** 32-byte public key for a private seed */
- (FurcardsCoreKotlinByteArray *)publicKeyPrivateKey:(FurcardsCoreKotlinByteArray *)privateKey __attribute__((swift_name("publicKey(privateKey:)")));

/** 64-byte detached ed25519 signature over [message] */
- (FurcardsCoreKotlinByteArray *)signPrivateKey:(FurcardsCoreKotlinByteArray *)privateKey message:(FurcardsCoreKotlinByteArray *)message __attribute__((swift_name("sign(privateKey:message:)")));
- (BOOL)verifyPublicKey:(FurcardsCoreKotlinByteArray *)publicKey message:(FurcardsCoreKotlinByteArray *)message signature:(FurcardsCoreKotlinByteArray *)signature __attribute__((swift_name("verify(publicKey:message:signature:)")));
@end


/**
 * where the platform hands the core its [CryptoProvider].
 *
 * android could be a plain expect/actual, but CryptoKit is a swift-only
 * framework - kotlin/native cant import it - so on ios the app injects a swift
 * implementation of the [CryptoProvider] protocol at startup instead. one
 * registry on both platforms keeps the wiring identical.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CryptoRegistry")))
@interface FurcardsCoreCryptoRegistry : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/**
 * where the platform hands the core its [CryptoProvider].
 *
 * android could be a plain expect/actual, but CryptoKit is a swift-only
 * framework - kotlin/native cant import it - so on ios the app injects a swift
 * implementation of the [CryptoProvider] protocol at startup instead. one
 * registry on both platforms keeps the wiring identical.
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)cryptoRegistry __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreCryptoRegistry *shared __attribute__((swift_name("shared")));
- (id<FurcardsCoreCryptoProvider>)require __attribute__((swift_name("require()")));
@property id<FurcardsCoreCryptoProvider> _Nullable provider __attribute__((swift_name("provider")));
@end


/** the local user's cryptographic identity */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Identity")))
@interface FurcardsCoreIdentity : FurcardsCoreBase
- (instancetype)initWithPrivateKey:(FurcardsCoreKotlinByteArray *)privateKey publicKey:(FurcardsCoreKotlinByteArray *)publicKey ephemeralSeed:(FurcardsCoreKotlinByteArray *)ephemeralSeed __attribute__((swift_name("init(privateKey:publicKey:ephemeralSeed:)"))) __attribute__((objc_designated_initializer));

/** rotation secret for ephemeral ids, derived from the private key */
@property (readonly) FurcardsCoreKotlinByteArray *ephemeralSeed __attribute__((swift_name("ephemeralSeed")));
@property (readonly) FurcardsCoreKotlinByteArray *privateKey __attribute__((swift_name("privateKey")));
@property (readonly) FurcardsCoreKotlinByteArray *publicKey __attribute__((swift_name("publicKey")));
@end


/**
 * creates the identity on first use (phase-3 "generate keypair on first
 * launch post-update") and loads it forever after. idempotent: concurrent or
 * repeated calls converge on the stored key.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IdentityManager")))
@interface FurcardsCoreIdentityManager : FurcardsCoreBase
- (instancetype)initWithStorage:(id<FurcardsCoreSecureStorage>)storage crypto:(id<FurcardsCoreCryptoProvider>)crypto __attribute__((swift_name("init(storage:crypto:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreIdentityManagerCompanion *companion __attribute__((swift_name("companion")));

/** wipes the identity (settings "clear collection"/account-reset path) */
- (void)destroy __attribute__((swift_name("destroy()")));
- (FurcardsCoreIdentity *)loadOrCreate __attribute__((swift_name("loadOrCreate()")));

/**
 * installs an imported identity (the export/import flow - the keypair
 * travels inside the passphrase-encrypted bundle). callers must rebuild
 * anything derived from the old identity afterwards.
 */
- (FurcardsCoreIdentity *)replacePrivateKey:(FurcardsCoreKotlinByteArray *)privateKey __attribute__((swift_name("replace(privateKey:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IdentityManager.Companion")))
@interface FurcardsCoreIdentityManagerCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreIdentityManagerCompanion *shared __attribute__((swift_name("shared")));
@property (readonly) NSString *KEY_PRIVATE __attribute__((swift_name("KEY_PRIVATE")));
@end


/**
 * pbkdf2-hmac-sha256 (rfc 8018) on top of the pure-kotlin [Sha256], so the
 * export bundle's key derivation is byte-identical on every platform without
 * touching platform crypto. only ever run on explicit user action
 * (export/import), so pure-kotlin throughput is fine.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Pbkdf2")))
@interface FurcardsCorePbkdf2 : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/**
 * pbkdf2-hmac-sha256 (rfc 8018) on top of the pure-kotlin [Sha256], so the
 * export bundle's key derivation is byte-identical on every platform without
 * touching platform crypto. only ever run on explicit user action
 * (export/import), so pure-kotlin throughput is fine.
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)pbkdf2 __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCorePbkdf2 *shared __attribute__((swift_name("shared")));
- (FurcardsCoreKotlinByteArray *)deriveKeyPassphrase:(FurcardsCoreKotlinByteArray *)passphrase salt:(FurcardsCoreKotlinByteArray *)salt iterations:(int32_t)iterations keyLength:(int32_t)keyLength __attribute__((swift_name("deriveKey(passphrase:salt:iterations:keyLength:)")));
@end


/**
 * where the identity key material lives. platform-backed:
 * android = keystore-wrapped storage, ios = keychain (swift impl injected
 * like the [CryptoProvider], because keychain apis are exposed to swift, not
 * kotlin/native-friendly enough to be worth binding directly).
 */
__attribute__((swift_name("SecureStorage")))
@protocol FurcardsCoreSecureStorage
@required
- (void)deleteKey:(NSString *)key __attribute__((swift_name("delete(key:)")));
- (FurcardsCoreKotlinByteArray * _Nullable)loadKey:(NSString *)key __attribute__((swift_name("load(key:)")));
- (void)storeKey:(NSString *)key value:(FurcardsCoreKotlinByteArray *)value __attribute__((swift_name("store(key:value:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SecureStorageRegistry")))
@interface FurcardsCoreSecureStorageRegistry : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)secureStorageRegistry __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreSecureStorageRegistry *shared __attribute__((swift_name("shared")));
- (id<FurcardsCoreSecureStorage>)require __attribute__((swift_name("require()")));
@property id<FurcardsCoreSecureStorage> _Nullable storage __attribute__((swift_name("storage")));
@end


/**
 * pure-kotlin sha-256 + hmac-sha256 (fips 180-4 / rfc 2104).
 *
 * hand rolled on purpose: ephemeral-id derivation, art hashes and the golden
 * vectors all have to produce identical bytes on android, ios AND inside
 * kotlin/native test binaries, where platform crypto (CryptoKit) isnt
 * reachable from kotlin. hashing is only ever run over small inputs
 * (<=300 KB art), so pure kotlin throughput is a non-issue. ed25519 stays in
 * [CryptoProvider] - only hashing lives here.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Sha256")))
@interface FurcardsCoreSha256 : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/**
 * pure-kotlin sha-256 + hmac-sha256 (fips 180-4 / rfc 2104).
 *
 * hand rolled on purpose: ephemeral-id derivation, art hashes and the golden
 * vectors all have to produce identical bytes on android, ios AND inside
 * kotlin/native test binaries, where platform crypto (CryptoKit) isnt
 * reachable from kotlin. hashing is only ever run over small inputs
 * (<=300 KB art), so pure kotlin throughput is a non-issue. ed25519 stays in
 * [CryptoProvider] - only hashing lives here.
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)sha256 __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreSha256 *shared __attribute__((swift_name("shared")));
- (FurcardsCoreKotlinByteArray *)hashMessage:(FurcardsCoreKotlinByteArray *)message __attribute__((swift_name("hash(message:)")));

/** hmac-sha256 (rfc 2104), block size 64 */
- (FurcardsCoreKotlinByteArray *)hmacKey:(FurcardsCoreKotlinByteArray *)key message:(FurcardsCoreKotlinByteArray *)message __attribute__((swift_name("hmac(key:message:)")));
@end


/**
 * the manual "switching phones/ecosystems" bundle (D13): one passphrase-
 * encrypted file carrying the identity, the user's card, and the whole
 * collection. written by either app, opened by either app - the format
 * lives here so ios and android can never drift.
 *
 * layout: "FURX" magic, version u8, salt(16), iterations u32be, nonce(12),
 * aes-256-gcm ciphertext (tag appended). key = pbkdf2-hmac-sha256(passphrase,
 * salt, iterations). plaintext = json of [ExportPayload] (json over cbor
 * here: it's a rescue file - debuggable beats compact).
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExportBundle")))
@interface FurcardsCoreExportBundle : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/**
 * the manual "switching phones/ecosystems" bundle (D13): one passphrase-
 * encrypted file carrying the identity, the user's card, and the whole
 * collection. written by either app, opened by either app - the format
 * lives here so ios and android can never drift.
 *
 * layout: "FURX" magic, version u8, salt(16), iterations u32be, nonce(12),
 * aes-256-gcm ciphertext (tag appended). key = pbkdf2-hmac-sha256(passphrase,
 * salt, iterations). plaintext = json of [ExportPayload] (json over cbor
 * here: it's a rescue file - debuggable beats compact).
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)exportBundle __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreExportBundle *shared __attribute__((swift_name("shared")));

/** null = wrong passphrase, corrupted file, or not a furcards bundle */
- (FurcardsCoreExportPayload * _Nullable)openBytes:(FurcardsCoreKotlinByteArray *)bytes passphrase:(NSString *)passphrase crypto:(id<FurcardsCoreCryptoProvider>)crypto __attribute__((swift_name("open(bytes:passphrase:crypto:)")));
- (FurcardsCoreKotlinByteArray *)sealPayload:(FurcardsCoreExportPayload *)payload passphrase:(NSString *)passphrase crypto:(id<FurcardsCoreCryptoProvider>)crypto salt:(FurcardsCoreKotlinByteArray *)salt nonce:(FurcardsCoreKotlinByteArray *)nonce __attribute__((swift_name("seal(payload:passphrase:crypto:salt:nonce:)")));
@property (readonly) NSString *FILE_EXTENSION __attribute__((swift_name("FILE_EXTENSION")));
@property (readonly) int32_t ITERATIONS __attribute__((swift_name("ITERATIONS")));
@property (readonly) int32_t VERSION __attribute__((swift_name("VERSION")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExportPayload")))
@interface FurcardsCoreExportPayload : FurcardsCoreBase
- (instancetype)initWithPrivateKey:(NSString *)privateKey ownCard:(FurcardsCoreFurcard *)ownCard cardVersion:(int64_t)cardVersion seen:(NSArray<FurcardsCoreFurcard *> *)seen friends:(NSArray<FurcardsCoreFurcard *> *)friends history:(NSDictionary<NSString *, NSArray<FurcardsCoreEncounter *> *> *)history categories:(NSArray<FurcardsCoreCardCategory *> *)categories blockedPubkeys:(NSArray<NSString *> *)blockedPubkeys blockedLegacyIds:(NSArray<NSString *> *)blockedLegacyIds exportedAtMillis:(int64_t)exportedAtMillis __attribute__((swift_name("init(privateKey:ownCard:cardVersion:seen:friends:history:categories:blockedPubkeys:blockedLegacyIds:exportedAtMillis:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreExportPayloadCompanion *companion __attribute__((swift_name("companion")));
- (FurcardsCoreExportPayload *)doCopyPrivateKey:(NSString *)privateKey ownCard:(FurcardsCoreFurcard *)ownCard cardVersion:(int64_t)cardVersion seen:(NSArray<FurcardsCoreFurcard *> *)seen friends:(NSArray<FurcardsCoreFurcard *> *)friends history:(NSDictionary<NSString *, NSArray<FurcardsCoreEncounter *> *> *)history categories:(NSArray<FurcardsCoreCardCategory *> *)categories blockedPubkeys:(NSArray<NSString *> *)blockedPubkeys blockedLegacyIds:(NSArray<NSString *> *)blockedLegacyIds exportedAtMillis:(int64_t)exportedAtMillis __attribute__((swift_name("doCopy(privateKey:ownCard:cardVersion:seen:friends:history:categories:blockedPubkeys:blockedLegacyIds:exportedAtMillis:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<NSString *> *blockedLegacyIds __attribute__((swift_name("blockedLegacyIds")));
@property (readonly) NSArray<NSString *> *blockedPubkeys __attribute__((swift_name("blockedPubkeys")));

/** monotonic card version so the new device reseals ABOVE it */
@property (readonly) int64_t cardVersion __attribute__((swift_name("cardVersion")));
@property (readonly) NSArray<FurcardsCoreCardCategory *> *categories __attribute__((swift_name("categories")));
@property (readonly) int64_t exportedAtMillis __attribute__((swift_name("exportedAtMillis")));
@property (readonly) NSArray<FurcardsCoreFurcard *> *friends __attribute__((swift_name("friends")));
@property (readonly) NSDictionary<NSString *, NSArray<FurcardsCoreEncounter *> *> *history __attribute__((swift_name("history")));
@property (readonly) FurcardsCoreFurcard *ownCard __attribute__((swift_name("ownCard")));

/** ed25519 private seed, base64 - the identity itself travels */
@property (readonly) NSString *privateKey __attribute__((swift_name("privateKey")));
@property (readonly) NSArray<FurcardsCoreFurcard *> *seen __attribute__((swift_name("seen")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExportPayload.Companion")))
@interface FurcardsCoreExportPayloadCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreExportPayloadCompanion *shared __attribute__((swift_name("shared")));
- (FurcardsCoreKotlinByteArray * _Nullable)decodeKeyEncoded:(NSString *)encoded __attribute__((swift_name("decodeKey(encoded:)")));
- (NSString *)encodeKeyPrivateKey:(FurcardsCoreKotlinByteArray *)privateKey __attribute__((swift_name("encodeKey(privateKey:)")));
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/** grouping of collected cards the user made. mirrors ios CardCategory
 *
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardCategory")))
@interface FurcardsCoreCardCategory : FurcardsCoreBase
- (instancetype)initWithId:(NSString *)id name:(NSString *)name cardIDs:(NSArray<NSString *> *)cardIDs __attribute__((swift_name("init(id:name:cardIDs:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreCardCategoryCompanion *companion __attribute__((swift_name("companion")));
- (FurcardsCoreCardCategory *)doCopyId:(NSString *)id name:(NSString *)name cardIDs:(NSArray<NSString *> *)cardIDs __attribute__((swift_name("doCopy(id:name:cardIDs:)")));

/** grouping of collected cards the user made. mirrors ios CardCategory */
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));

/** grouping of collected cards the user made. mirrors ios CardCategory */
- (NSUInteger)hash __attribute__((swift_name("hash()")));

/** grouping of collected cards the user made. mirrors ios CardCategory */
- (NSString *)description __attribute__((swift_name("description()")));

/** card ids in here, newest added first */
@property (readonly) NSArray<NSString *> *cardIDs __attribute__((swift_name("cardIDs")));
@property (readonly) NSString *id __attribute__((swift_name("id")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@end


/** grouping of collected cards the user made. mirrors ios CardCategory */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardCategory.Companion")))
@interface FurcardsCoreCardCategoryCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/** grouping of collected cards the user made. mirrors ios CardCategory */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreCardCategoryCompanion *shared __attribute__((swift_name("shared")));

/** grouping of collected cards the user made. mirrors ios CardCategory */
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * rgb color that rides along with a card. components 0.0-1.0 in srgb
 * matches ios Color(red:green:blue:) so cards look teh same on both
 *
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardColor")))
@interface FurcardsCoreCardColor : FurcardsCoreBase
- (instancetype)initWithId:(NSString *)id red:(double)red green:(double)green blue:(double)blue __attribute__((swift_name("init(id:red:green:blue:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreCardColorCompanion *companion __attribute__((swift_name("companion")));
- (FurcardsCoreCardColor *)doCopyId:(NSString *)id red:(double)red green:(double)green blue:(double)blue __attribute__((swift_name("doCopy(id:red:green:blue:)")));

/**
 * rgb color that rides along with a card. components 0.0-1.0 in srgb
 * matches ios Color(red:green:blue:) so cards look teh same on both
 */
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));

/**
 * rgb color that rides along with a card. components 0.0-1.0 in srgb
 * matches ios Color(red:green:blue:) so cards look teh same on both
 */
- (NSUInteger)hash __attribute__((swift_name("hash()")));

/**
 * rgb color that rides along with a card. components 0.0-1.0 in srgb
 * matches ios Color(red:green:blue:) so cards look teh same on both
 */
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) double blue __attribute__((swift_name("blue")));
@property (readonly) double green __attribute__((swift_name("green")));
@property (readonly) NSString *id __attribute__((swift_name("id")));
@property (readonly) double red __attribute__((swift_name("red")));
@end


/**
 * rgb color that rides along with a card. components 0.0-1.0 in srgb
 * matches ios Color(red:green:blue:) so cards look teh same on both
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardColor.Companion")))
@interface FurcardsCoreCardColorCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/**
 * rgb color that rides along with a card. components 0.0-1.0 in srgb
 * matches ios Color(red:green:blue:) so cards look teh same on both
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreCardColorCompanion *shared __attribute__((swift_name("shared")));

/**
 * rgb color that rides along with a card. components 0.0-1.0 in srgb
 * matches ios Color(red:green:blue:) so cards look teh same on both
 */
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((swift_name("KotlinComparable")))
@protocol FurcardsCoreKotlinComparable
@required
- (int32_t)compareToOther:(id _Nullable)other __attribute__((swift_name("compareTo(other:)")));
@end

__attribute__((swift_name("KotlinEnum")))
@interface FurcardsCoreKotlinEnum<E> : FurcardsCoreBase <FurcardsCoreKotlinComparable>
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreKotlinEnumCompanion *companion __attribute__((swift_name("companion")));
- (int32_t)compareToOther:(E)other __attribute__((swift_name("compareTo(other:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@property (readonly) int32_t ordinal __attribute__((swift_name("ordinal")));
@end


/** decorative overlay pattern on a card
 *
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardPattern")))
@interface FurcardsCoreCardPattern : FurcardsCoreKotlinEnum<FurcardsCoreCardPattern *>
+ (instancetype)alloc __attribute__((unavailable));

/** decorative overlay pattern on a card */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) FurcardsCoreCardPatternCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) FurcardsCoreCardPattern *none __attribute__((swift_name("none")));
@property (class, readonly) FurcardsCoreCardPattern *sparkles __attribute__((swift_name("sparkles")));
@property (class, readonly) FurcardsCoreCardPattern *dots __attribute__((swift_name("dots")));
+ (FurcardsCoreKotlinArray<FurcardsCoreCardPattern *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<FurcardsCoreCardPattern *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *label __attribute__((swift_name("label")));
@end


/** decorative overlay pattern on a card */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardPattern.Companion")))
@interface FurcardsCoreCardPatternCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/** decorative overlay pattern on a card */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreCardPatternCompanion *shared __attribute__((swift_name("shared")));

/** decorative overlay pattern on a card */
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));

/** decorative overlay pattern on a card */
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(FurcardsCoreKotlinArray<id<FurcardsCoreKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end


/**
 * layout template for the card front - how the photo + info are arranged.
 * wire compatible w the ios CardTemplate ("classic"/"fullBleed"/"portrait")
 *
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardTemplate")))
@interface FurcardsCoreCardTemplate : FurcardsCoreKotlinEnum<FurcardsCoreCardTemplate *>
+ (instancetype)alloc __attribute__((unavailable));

/**
 * layout template for the card front - how the photo + info are arranged.
 * wire compatible w the ios CardTemplate ("classic"/"fullBleed"/"portrait")
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) FurcardsCoreCardTemplateCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) FurcardsCoreCardTemplate *classic __attribute__((swift_name("classic")));
@property (class, readonly) FurcardsCoreCardTemplate *fullBleed __attribute__((swift_name("fullBleed")));
@property (class, readonly) FurcardsCoreCardTemplate *portrait __attribute__((swift_name("portrait")));
+ (FurcardsCoreKotlinArray<FurcardsCoreCardTemplate *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<FurcardsCoreCardTemplate *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *label __attribute__((swift_name("label")));
@end


/**
 * layout template for the card front - how the photo + info are arranged.
 * wire compatible w the ios CardTemplate ("classic"/"fullBleed"/"portrait")
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardTemplate.Companion")))
@interface FurcardsCoreCardTemplateCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/**
 * layout template for the card front - how the photo + info are arranged.
 * wire compatible w the ios CardTemplate ("classic"/"fullBleed"/"portrait")
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreCardTemplateCompanion *shared __attribute__((swift_name("shared")));

/**
 * layout template for the card front - how the photo + info are arranged.
 * wire compatible w the ios CardTemplate ("classic"/"fullBleed"/"portrait")
 */
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));

/**
 * layout template for the card front - how the photo + info are arranged.
 * wire compatible w the ios CardTemplate ("classic"/"fullBleed"/"portrait")
 */
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(FurcardsCoreKotlinArray<id<FurcardsCoreKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end


/**
 * whole look of a card - bg gradient, overlay pattern and the friend glow
 * mirrors ios CardTheme
 *
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardTheme")))
@interface FurcardsCoreCardTheme : FurcardsCoreBase
- (instancetype)initWithColors:(NSArray<FurcardsCoreCardColor *> *)colors pattern:(FurcardsCoreCardPattern *)pattern glowColors:(NSArray<FurcardsCoreCardColor *> *)glowColors __attribute__((swift_name("init(colors:pattern:glowColors:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreCardThemeCompanion *companion __attribute__((swift_name("companion")));
- (FurcardsCoreCardTheme *)doCopyColors:(NSArray<FurcardsCoreCardColor *> *)colors pattern:(FurcardsCoreCardPattern *)pattern glowColors:(NSArray<FurcardsCoreCardColor *> *)glowColors __attribute__((swift_name("doCopy(colors:pattern:glowColors:)")));

/**
 * whole look of a card - bg gradient, overlay pattern and the friend glow
 * mirrors ios CardTheme
 */
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));

/**
 * whole look of a card - bg gradient, overlay pattern and the friend glow
 * mirrors ios CardTheme
 */
- (NSUInteger)hash __attribute__((swift_name("hash()")));

/**
 * whole look of a card - bg gradient, overlay pattern and the friend glow
 * mirrors ios CardTheme
 */
- (NSString *)description __attribute__((swift_name("description()")));

/** bg gradient colors, top-leading down to bottom-trailing */
@property (readonly) NSArray<FurcardsCoreCardColor *> *colors __attribute__((swift_name("colors")));

/** colors we cycle thru for the animated friend card glow */
@property (readonly) NSArray<FurcardsCoreCardColor *> *glowColors __attribute__((swift_name("glowColors")));
@property (readonly) FurcardsCoreCardPattern *pattern __attribute__((swift_name("pattern")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardTheme.Companion")))
@interface FurcardsCoreCardThemeCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreCardThemeCompanion *shared __attribute__((swift_name("shared")));
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));

/** plain default look, neutral gray gradient no pattern */
@property (readonly) FurcardsCoreCardTheme *DEFAULT __attribute__((swift_name("DEFAULT")));

/** distinct looks for the fake people so they dont look like the users own card */
@property (readonly) NSArray<FurcardsCoreCardTheme *> *presets __attribute__((swift_name("presets")));
@end


/** one dated + located run-in with someone. mirrors ios Encounter
 *
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Encounter")))
@interface FurcardsCoreEncounter : FurcardsCoreBase
- (instancetype)initWithId:(NSString *)id kind:(FurcardsCoreEncounterKind *)kind date:(int64_t)date latitude:(FurcardsCoreDouble * _Nullable)latitude longitude:(FurcardsCoreDouble * _Nullable)longitude myMessage:(NSString *)myMessage theirMessage:(NSString *)theirMessage __attribute__((swift_name("init(id:kind:date:latitude:longitude:myMessage:theirMessage:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreEncounterCompanion *companion __attribute__((swift_name("companion")));
- (FurcardsCoreEncounter *)doCopyId:(NSString *)id kind:(FurcardsCoreEncounterKind *)kind date:(int64_t)date latitude:(FurcardsCoreDouble * _Nullable)latitude longitude:(FurcardsCoreDouble * _Nullable)longitude myMessage:(NSString *)myMessage theirMessage:(NSString *)theirMessage __attribute__((swift_name("doCopy(id:kind:date:latitude:longitude:myMessage:theirMessage:)")));

/** one dated + located run-in with someone. mirrors ios Encounter */
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));

/** one dated + located run-in with someone. mirrors ios Encounter */
- (NSUInteger)hash __attribute__((swift_name("hash()")));

/** one dated + located run-in with someone. mirrors ios Encounter */
- (NSString *)description __attribute__((swift_name("description()")));

/** epoch millis when it happend */
@property (readonly) int64_t date __attribute__((swift_name("date")));
@property (readonly) BOOL hasLocation __attribute__((swift_name("hasLocation")));
@property (readonly) NSString *id __attribute__((swift_name("id")));
@property (readonly) FurcardsCoreEncounterKind *kind __attribute__((swift_name("kind")));
@property (readonly) FurcardsCoreDouble * _Nullable latitude __attribute__((swift_name("latitude")));
@property (readonly) FurcardsCoreDouble * _Nullable longitude __attribute__((swift_name("longitude")));

/** message i sent, empty for walk-bys */
@property (readonly) NSString *myMessage __attribute__((swift_name("myMessage")));

/** message they sent, empty for walk-bys */
@property (readonly) NSString *theirMessage __attribute__((swift_name("theirMessage")));
@end


/** one dated + located run-in with someone. mirrors ios Encounter */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Encounter.Companion")))
@interface FurcardsCoreEncounterCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/** one dated + located run-in with someone. mirrors ios Encounter */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreEncounterCompanion *shared __attribute__((swift_name("shared")));

/** one dated + located run-in with someone. mirrors ios Encounter */
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Encounter.Kind")))
@interface FurcardsCoreEncounterKind : FurcardsCoreKotlinEnum<FurcardsCoreEncounterKind *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) FurcardsCoreEncounterKindCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) FurcardsCoreEncounterKind *walkedBy __attribute__((swift_name("walkedBy")));
@property (class, readonly) FurcardsCoreEncounterKind *bump __attribute__((swift_name("bump")));
+ (FurcardsCoreKotlinArray<FurcardsCoreEncounterKind *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<FurcardsCoreEncounterKind *> *entries __attribute__((swift_name("entries")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Encounter.KindCompanion")))
@interface FurcardsCoreEncounterKindCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreEncounterKindCompanion *shared __attribute__((swift_name("shared")));
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(FurcardsCoreKotlinArray<id<FurcardsCoreKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end


/** one trading card profile. wire compatible w the ios Furcard
 *
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Furcard")))
@interface FurcardsCoreFurcard : FurcardsCoreBase
- (instancetype)initWithId:(NSString *)id name:(NSString *)name pronouns:(NSString *)pronouns identityFlags:(NSString *)identityFlags artworkName:(NSString *)artworkName artworkData:(NSString * _Nullable)artworkData originalArtworkData:(NSString * _Nullable)originalArtworkData artistCredit:(NSString *)artistCredit tags:(NSArray<NSString *> *)tags bio:(NSString *)bio socials:(NSArray<FurcardsCoreSocialLink *> *)socials message:(NSString *)message theme:(FurcardsCoreCardTheme *)theme template:(FurcardsCoreCardTemplate * _Nullable)template_ walkedByCount:(FurcardsCoreInt * _Nullable)walkedByCount bumpCount:(FurcardsCoreInt * _Nullable)bumpCount pubkey:(NSString * _Nullable)pubkey signedCardVersion:(FurcardsCoreLong * _Nullable)signedCardVersion __attribute__((swift_name("init(id:name:pronouns:identityFlags:artworkName:artworkData:originalArtworkData:artistCredit:tags:bio:socials:message:theme:template:walkedByCount:bumpCount:pubkey:signedCardVersion:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreFurcardCompanion *companion __attribute__((swift_name("companion")));
- (FurcardsCoreFurcard *)doCopyId:(NSString *)id name:(NSString *)name pronouns:(NSString *)pronouns identityFlags:(NSString *)identityFlags artworkName:(NSString *)artworkName artworkData:(NSString * _Nullable)artworkData originalArtworkData:(NSString * _Nullable)originalArtworkData artistCredit:(NSString *)artistCredit tags:(NSArray<NSString *> *)tags bio:(NSString *)bio socials:(NSArray<FurcardsCoreSocialLink *> *)socials message:(NSString *)message theme:(FurcardsCoreCardTheme *)theme template:(FurcardsCoreCardTemplate * _Nullable)template_ walkedByCount:(FurcardsCoreInt * _Nullable)walkedByCount bumpCount:(FurcardsCoreInt * _Nullable)bumpCount pubkey:(NSString * _Nullable)pubkey signedCardVersion:(FurcardsCoreLong * _Nullable)signedCardVersion __attribute__((swift_name("doCopy(id:name:pronouns:identityFlags:artworkName:artworkData:originalArtworkData:artistCredit:tags:bio:socials:message:theme:template:walkedByCount:bumpCount:pubkey:signedCardVersion:)")));

/** one trading card profile. wire compatible w the ios Furcard */
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));

/** one trading card profile. wire compatible w the ios Furcard */
- (NSUInteger)hash __attribute__((swift_name("hash()")));

/** one trading card profile. wire compatible w the ios Furcard */
- (NSString *)description __attribute__((swift_name("description()")));

/** artist we credit, shows up as "Art by …" */
@property (readonly) NSString *artistCredit __attribute__((swift_name("artistCredit")));

/** user picked card-cropped photo as a data: uri. wins over artworkName */
@property (readonly) NSString * _Nullable artworkData __attribute__((swift_name("artworkData")));

/** name of a bundled artwork asset, fallback when theres no photo */
@property (readonly) NSString *artworkName __attribute__((swift_name("artworkName")));
@property (readonly) NSString *bio __attribute__((swift_name("bio")));
@property (readonly) FurcardsCoreInt * _Nullable bumpCount __attribute__((swift_name("bumpCount")));

/** public version of the card, friends-only socials stripped */
@property (readonly) FurcardsCoreFurcard *commonCard __attribute__((swift_name("commonCard")));

/** the layout to render, treating a missing template as classic */
@property (readonly) FurcardsCoreCardTemplate *effectiveTemplate __attribute__((swift_name("effectiveTemplate")));
@property (readonly) NSString *id __attribute__((swift_name("id")));

/** identity flags under the pronouns eg "🏳️‍⚧️ 🏳️‍🌈" */
@property (readonly) NSString *identityFlags __attribute__((swift_name("identityFlags")));

/**
 * server-era card that predates signing. derived, not stored: pubkey-less
 * cards are legacy by definition, which makes the migration shim
 * idempotent by construction (nothing to run twice, nothing to forget).
 * legacy cards stay displayable, are never relayed, and upgrade in place
 * on the next in-person exchange (CardSupersession.legacyUpgradeCandidate).
 */
@property (readonly) BOOL isLegacy __attribute__((swift_name("isLegacy")));

/** message down at the bottom of the card */
@property (readonly) NSString *message __attribute__((swift_name("message")));
@property (readonly) NSString *name __attribute__((swift_name("name")));

/**
 * the full uncropped photo the crop was made from, so changing layouts can
 * re-crop from the original rather than an already cropped image. owner only
 * (everyone else gets just the cropped `artworkData`).
 */
@property (readonly) NSString * _Nullable originalArtworkData __attribute__((swift_name("originalArtworkData")));
@property (readonly) NSString *pronouns __attribute__((swift_name("pronouns")));

/**
 * hex ed25519 public key when this entry was built from a verified signed
 * blob (ble exchange). null for server-era cards and the owner's own
 * card. absence IS the legacy marker - see [isLegacy].
 */
@property (readonly) NSString * _Nullable pubkey __attribute__((swift_name("pubkey")));

/** cardVersion of the signed blob this entry was built from */
@property (readonly) FurcardsCoreLong * _Nullable signedCardVersion __attribute__((swift_name("signedCardVersion")));
@property (readonly) NSArray<FurcardsCoreSocialLink *> *socials __attribute__((swift_name("socials")));
@property (readonly) NSArray<NSString *> *tags __attribute__((swift_name("tags")));

/**
 * the front layout template. nullable for backwards compat w cards saved
 * before templates existed (null is treated as classic, see effectiveTemplate)
 */
@property (readonly, getter=template) FurcardsCoreCardTemplate * _Nullable template_ __attribute__((swift_name("template_")));

/** the cards look - bg, pattern, friend glow */
@property (readonly) FurcardsCoreCardTheme *theme __attribute__((swift_name("theme")));

/**
 * lifetime stats computed by the backend, shown on the card back. read only
 * from the clients side (the server recomputes them).
 */
@property (readonly) FurcardsCoreInt * _Nullable walkedByCount __attribute__((swift_name("walkedByCount")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Furcard.Companion")))
@interface FurcardsCoreFurcardCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreFurcardCompanion *shared __attribute__((swift_name("shared")));
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));

/** blank card, where a new account starts from */
@property (readonly) FurcardsCoreFurcard *sample __attribute__((swift_name("sample")));

/** fake cards for other ppl, for previews + test data */
@property (readonly) NSArray<FurcardsCoreFurcard *> *samplePeople __attribute__((swift_name("samplePeople")));
@end


/** one social link shown on the back of a card
 *
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SocialLink")))
@interface FurcardsCoreSocialLink : FurcardsCoreBase
- (instancetype)initWithId:(NSString *)id platform:(FurcardsCoreSocialPlatform *)platform handle:(NSString *)handle visibility:(FurcardsCoreSocialVisibility *)visibility __attribute__((swift_name("init(id:platform:handle:visibility:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreSocialLinkCompanion *companion __attribute__((swift_name("companion")));
- (FurcardsCoreSocialLink *)doCopyId:(NSString *)id platform:(FurcardsCoreSocialPlatform *)platform handle:(NSString *)handle visibility:(FurcardsCoreSocialVisibility *)visibility __attribute__((swift_name("doCopy(id:platform:handle:visibility:)")));

/** one social link shown on the back of a card */
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));

/** one social link shown on the back of a card */
- (NSUInteger)hash __attribute__((swift_name("hash()")));

/** one social link shown on the back of a card */
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *handle __attribute__((swift_name("handle")));
@property (readonly) NSString *id __attribute__((swift_name("id")));
@property (readonly) FurcardsCoreSocialPlatform *platform __attribute__((swift_name("platform")));
@property (readonly) FurcardsCoreSocialVisibility *visibility __attribute__((swift_name("visibility")));
@end


/** one social link shown on the back of a card */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SocialLink.Companion")))
@interface FurcardsCoreSocialLinkCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/** one social link shown on the back of a card */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreSocialLinkCompanion *shared __attribute__((swift_name("shared")));

/** one social link shown on the back of a card */
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/** social platform a card can link out to
 *
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SocialPlatform")))
@interface FurcardsCoreSocialPlatform : FurcardsCoreKotlinEnum<FurcardsCoreSocialPlatform *>
+ (instancetype)alloc __attribute__((unavailable));

/** social platform a card can link out to */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) FurcardsCoreSocialPlatformCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) FurcardsCoreSocialPlatform *bluesky __attribute__((swift_name("bluesky")));
@property (class, readonly) FurcardsCoreSocialPlatform *twitter __attribute__((swift_name("twitter")));
@property (class, readonly) FurcardsCoreSocialPlatform *instagram __attribute__((swift_name("instagram")));
@property (class, readonly) FurcardsCoreSocialPlatform *telegram __attribute__((swift_name("telegram")));
@property (class, readonly) FurcardsCoreSocialPlatform *discord __attribute__((swift_name("discord")));
@property (class, readonly) FurcardsCoreSocialPlatform *barq __attribute__((swift_name("barq")));
@property (class, readonly) FurcardsCoreSocialPlatform *website __attribute__((swift_name("website")));
@property (class, readonly) FurcardsCoreSocialPlatform *email __attribute__((swift_name("email")));
+ (FurcardsCoreKotlinArray<FurcardsCoreSocialPlatform *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<FurcardsCoreSocialPlatform *> *entries __attribute__((swift_name("entries")));

/** url that opens the profile, null for handles that dont have one */
- (NSString * _Nullable)profileUrlHandle:(NSString *)handle __attribute__((swift_name("profileUrl(handle:)")));
@property (readonly) NSString *label __attribute__((swift_name("label")));
@end


/** social platform a card can link out to */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SocialPlatform.Companion")))
@interface FurcardsCoreSocialPlatformCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/** social platform a card can link out to */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreSocialPlatformCompanion *shared __attribute__((swift_name("shared")));

/** social platform a card can link out to */
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));

/** social platform a card can link out to */
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(FurcardsCoreKotlinArray<id<FurcardsCoreKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end


/** who gets to see a given social link
 *
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SocialVisibility")))
@interface FurcardsCoreSocialVisibility : FurcardsCoreKotlinEnum<FurcardsCoreSocialVisibility *>
+ (instancetype)alloc __attribute__((unavailable));

/** who gets to see a given social link */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) FurcardsCoreSocialVisibilityCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) FurcardsCoreSocialVisibility *everyone __attribute__((swift_name("everyone")));
@property (class, readonly) FurcardsCoreSocialVisibility *friends __attribute__((swift_name("friends")));
+ (FurcardsCoreKotlinArray<FurcardsCoreSocialVisibility *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<FurcardsCoreSocialVisibility *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *label __attribute__((swift_name("label")));
@end


/** who gets to see a given social link */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SocialVisibility.Companion")))
@interface FurcardsCoreSocialVisibilityCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/** who gets to see a given social link */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreSocialVisibilityCompanion *shared __attribute__((swift_name("shared")));

/** who gets to see a given social link */
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));

/** who gets to see a given social link */
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(FurcardsCoreKotlinArray<id<FurcardsCoreKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end


/**
 * keeps dense rooms (con floors, dealer dens) from turning into connection
 * storms (PROTOCOL.md "anti-storm"). policy only - transports ask, this
 * answers. time is always injected epoch millis.
 *
 *  - dedupe: a (ephemeralId, cardVersion) pair we exchanged with is not worth
 *    reconnecting to for [DEDUPE_TTL_MILLIS] (30 min - outlives one 15-min id
 *    rotation on purpose: the version part still dedupes across the roll).
 *  - backoff: per-peer exponential on failed/aborted sessions.
 *  - concurrency: at most [MAX_CONCURRENT_SESSIONS] live sessions.
 *  - duty cycle: after [QUIET_BEFORE_DUTY_CYCLE_MILLIS] with no new peers,
 *    recommend 5 s scanning / 15 s idle to save battery (badge mode ignores
 *    this and runs full duty).
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("AntiStormPolicy")))
@interface FurcardsCoreAntiStormPolicy : FurcardsCoreBase

/**
 * keeps dense rooms (con floors, dealer dens) from turning into connection
 * storms (PROTOCOL.md "anti-storm"). policy only - transports ask, this
 * answers. time is always injected epoch millis.
 *
 *  - dedupe: a (ephemeralId, cardVersion) pair we exchanged with is not worth
 *    reconnecting to for [DEDUPE_TTL_MILLIS] (30 min - outlives one 15-min id
 *    rotation on purpose: the version part still dedupes across the roll).
 *  - backoff: per-peer exponential on failed/aborted sessions.
 *  - concurrency: at most [MAX_CONCURRENT_SESSIONS] live sessions.
 *  - duty cycle: after [QUIET_BEFORE_DUTY_CYCLE_MILLIS] with no new peers,
 *    recommend 5 s scanning / 15 s idle to save battery (badge mode ignores
 *    this and runs full duty).
 */
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));

/**
 * keeps dense rooms (con floors, dealer dens) from turning into connection
 * storms (PROTOCOL.md "anti-storm"). policy only - transports ask, this
 * answers. time is always injected epoch millis.
 *
 *  - dedupe: a (ephemeralId, cardVersion) pair we exchanged with is not worth
 *    reconnecting to for [DEDUPE_TTL_MILLIS] (30 min - outlives one 15-min id
 *    rotation on purpose: the version part still dedupes across the roll).
 *  - backoff: per-peer exponential on failed/aborted sessions.
 *  - concurrency: at most [MAX_CONCURRENT_SESSIONS] live sessions.
 *  - duty cycle: after [QUIET_BEFORE_DUTY_CYCLE_MILLIS] with no new peers,
 *    recommend 5 s scanning / 15 s idle to save battery (badge mode ignores
 *    this and runs full duty).
 */
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property (class, readonly, getter=companion) FurcardsCoreAntiStormPolicyCompanion *companion __attribute__((swift_name("companion")));
- (BOOL)canStartSessionActiveSessionCount:(int32_t)activeSessionCount __attribute__((swift_name("canStartSession(activeSessionCount:)")));

/**
 * scan duty cycle recommendation. [lastNewPeerMillis] = when a not-seen-
 * before advertisement last appeared (0 if never).
 */
- (FurcardsCoreDutyCycle *)dutyCycleLastNewPeerMillis:(int64_t)lastNewPeerMillis nowMillis:(int64_t)nowMillis __attribute__((swift_name("dutyCycle(lastNewPeerMillis:nowMillis:)")));

/** call on a completed exchange; suppresses this (id, version) for 30 min */
- (void)recordExchangeEphemeralIdHex:(NSString *)ephemeralIdHex cardVersion:(uint32_t)cardVersion nowMillis:(int64_t)nowMillis __attribute__((swift_name("recordExchange(ephemeralIdHex:cardVersion:nowMillis:)")));

/** call on a failed/aborted session; doubles the per-peer retry delay */
- (void)recordFailureEphemeralIdHex:(NSString *)ephemeralIdHex nowMillis:(int64_t)nowMillis __attribute__((swift_name("recordFailure(ephemeralIdHex:nowMillis:)")));

/** should we bother connecting to this advertisement right now? */
- (BOOL)shouldConnectEphemeralIdHex:(NSString *)ephemeralIdHex cardVersion:(uint32_t)cardVersion nowMillis:(int64_t)nowMillis __attribute__((swift_name("shouldConnect(ephemeralIdHex:cardVersion:nowMillis:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("AntiStormPolicy.Companion")))
@interface FurcardsCoreAntiStormPolicyCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreAntiStormPolicyCompanion *shared __attribute__((swift_name("shared")));
@property (readonly) int64_t BACKOFF_BASE_MILLIS __attribute__((swift_name("BACKOFF_BASE_MILLIS")));
@property (readonly) int32_t BACKOFF_MAX_DOUBLINGS __attribute__((swift_name("BACKOFF_MAX_DOUBLINGS")));
@property (readonly) int64_t BACKOFF_MAX_MILLIS __attribute__((swift_name("BACKOFF_MAX_MILLIS")));
@property (readonly) int64_t DEDUPE_TTL_MILLIS __attribute__((swift_name("DEDUPE_TTL_MILLIS")));
@property (readonly) int32_t MAX_CONCURRENT_SESSIONS __attribute__((swift_name("MAX_CONCURRENT_SESSIONS")));
@property (readonly) int64_t QUIET_BEFORE_DUTY_CYCLE_MILLIS __attribute__((swift_name("QUIET_BEFORE_DUTY_CYCLE_MILLIS")));
@end


/**
 * pubkey blocklist (PROTOCOL.md "blocklist"). enforcement is two-sided by
 * design and BOTH sides live in the core so neither platform can forget one:
 *
 *  - display: a blocked identity's cards never reach the collection/UI, and
 *    an existing stored card is removed when its identity gets blocked.
 *  - relay: a blocked identity's cards are never gossiped onward, and gossip
 *    arriving FROM anyone still carrying them is dropped card-by-card.
 *
 * unlike the server-era block this cannot be mutual (there is no server to
 * hide *you* from *them*) - blocking is strictly "i never see or spread this
 * identity again". legacy (unsigned) cards have no pubkey; those are blocked
 * by local storage id in app code until they upgrade, tracked here too so the
 * semantics stay in one place.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Blocklist")))
@interface FurcardsCoreBlocklist : FurcardsCoreBase
- (instancetype)initWithBlockedPublicKeys:(NSSet<NSString *> *)blockedPublicKeys blockedLegacyIds:(NSSet<NSString *> *)blockedLegacyIds __attribute__((swift_name("init(blockedPublicKeys:blockedLegacyIds:)"))) __attribute__((objc_designated_initializer));
- (void)blockPublicKey:(FurcardsCoreKotlinByteArray *)publicKey __attribute__((swift_name("block(publicKey:)")));
- (void)blockHexPublicKeyHex:(NSString *)publicKeyHex __attribute__((swift_name("blockHex(publicKeyHex:)")));
- (void)blockLegacyStorageId:(NSString *)storageId __attribute__((swift_name("blockLegacy(storageId:)")));

/**
 * the full block rule for a verified card: blocked identity, OR a signed
 * card claiming the legacyId of a server-era card the user blocked (the
 * block must survive the person's upgrade to a signed identity, D10).
 */
- (BOOL)blocksCard:(FurcardsCoreVerifiedCard *)card __attribute__((swift_name("blocks(card:)")));

/** display-path gate: drop blocked identities before anything is stored/shown */
- (NSArray<FurcardsCoreVerifiedCard *> *)filterDisplayCards:(NSArray<FurcardsCoreVerifiedCard *> *)cards __attribute__((swift_name("filterDisplay(cards:)")));

/** relay-path gate: identical rule, named separately so call sites read as policy */
- (NSArray<FurcardsCoreVerifiedCard *> *)filterRelayCards:(NSArray<FurcardsCoreVerifiedCard *> *)cards __attribute__((swift_name("filterRelay(cards:)")));
- (BOOL)isBlockedPublicKey:(FurcardsCoreKotlinByteArray *)publicKey __attribute__((swift_name("isBlocked(publicKey:)")));
- (BOOL)isBlockedHexPublicKeyHex:(NSString *)publicKeyHex __attribute__((swift_name("isBlockedHex(publicKeyHex:)")));
- (BOOL)isLegacyBlockedStorageId:(NSString *)storageId __attribute__((swift_name("isLegacyBlocked(storageId:)")));
- (void)unblockPublicKey:(FurcardsCoreKotlinByteArray *)publicKey __attribute__((swift_name("unblock(publicKey:)")));
- (void)unblockHexPublicKeyHex:(NSString *)publicKeyHex __attribute__((swift_name("unblockHex(publicKeyHex:)")));
- (void)unblockLegacyStorageId:(NSString *)storageId __attribute__((swift_name("unblockLegacy(storageId:)")));
@property (readonly) NSSet<NSString *> *blockedLegacyIds __attribute__((swift_name("blockedLegacyIds")));
@property (readonly) NSSet<NSString *> *blockedPublicKeys __attribute__((swift_name("blockedPublicKeys")));
@end


/**
 * fixed-size bloom filter carried in the hello message so peers can diff
 * collections without listing them. hand-rolled (~50 lines) instead of a
 * dependency, per the migration ground rules.
 *
 * parameters are frozen protocol surface (PROTOCOL.md): m = 2048 bits
 * (256 bytes), k = 5, double hashing with fnv-1a 64. at a big con day of
 * ~200 collected cards thats a ~1% false-positive rate; a false positive
 * only means one card doesnt get offered this session - it'll come around
 * again on the next encounter or via gossip.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("BloomFilter")))
@interface FurcardsCoreBloomFilter : FurcardsCoreBase
- (instancetype)initWithBits:(FurcardsCoreKotlinByteArray *)bits __attribute__((swift_name("init(bits:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreBloomFilterCompanion *companion __attribute__((swift_name("companion")));
- (void)addKey:(FurcardsCoreKotlinByteArray *)key __attribute__((swift_name("add(key:)")));
- (BOOL)mightContainKey:(FurcardsCoreKotlinByteArray *)key __attribute__((swift_name("mightContain(key:)")));
@property (readonly) FurcardsCoreKotlinByteArray *bits __attribute__((swift_name("bits")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("BloomFilter.Companion")))
@interface FurcardsCoreBloomFilterCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreBloomFilterCompanion *shared __attribute__((swift_name("shared")));

/**
 * the key a card occupies the filter under: identity + version, so a
 * newer version of a known card still reads as "unseen" and gets
 * offered/gossiped.
 */
- (FurcardsCoreKotlinByteArray *)cardKeyPublicKey:(FurcardsCoreKotlinByteArray *)publicKey cardVersion:(uint32_t)cardVersion __attribute__((swift_name("cardKey(publicKey:cardVersion:)")));
@property (readonly) int32_t BIT_COUNT __attribute__((swift_name("BIT_COUNT")));
@property (readonly) int32_t HASH_COUNT __attribute__((swift_name("HASH_COUNT")));
@property (readonly) int32_t SIZE_BYTES __attribute__((swift_name("SIZE_BYTES")));
@end


/**
 * receiving side. [expectedSize] comes from the transfer's announce message;
 * anything that would overflow it aborts the transfer (a lying announce or a
 * corrupted offset must not allocate unbounded memory).
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChunkAssembler")))
@interface FurcardsCoreChunkAssembler : FurcardsCoreBase
- (instancetype)initWithExpectedSize:(int32_t)expectedSize __attribute__((swift_name("init(expectedSize:)"))) __attribute__((objc_designated_initializer));

/**
 * feeds one wire chunk. returns false when the transfer is broken and
 * must be aborted (gap, overflow, malformed) - already-seen data is fine
 * and just ignored (duplicate delivery after a resume).
 */
- (BOOL)acceptChunk:(FurcardsCoreKotlinByteArray *)chunk __attribute__((swift_name("accept(chunk:)")));

/** only valid when [isComplete] */
- (FurcardsCoreKotlinByteArray *)assembled __attribute__((swift_name("assembled()")));
@property (readonly) int32_t expectedSize __attribute__((swift_name("expectedSize")));
@property (readonly) BOOL isComplete __attribute__((swift_name("isComplete")));

/** contiguous bytes received so far == the offset to resume from */
@property (readonly) int32_t received __attribute__((swift_name("received")));
@end


/**
 * offset-based chunking for payloads bigger than one att write (card blobs,
 * gossip batches, full art). resumable: the receiver acks its contiguous
 * prefix, so a dropped connection resumes from the last byte that landed
 * rather than starting over (PROTOCOL.md "chunked transfer").
 *
 * each chunk on the wire is [u32 big-endian offset][data]. the receiver
 * ignores chunks it already has and refuses gaps - senders always send in
 * order from the requested offset.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Chunking")))
@interface FurcardsCoreChunking : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/**
 * offset-based chunking for payloads bigger than one att write (card blobs,
 * gossip batches, full art). resumable: the receiver acks its contiguous
 * prefix, so a dropped connection resumes from the last byte that landed
 * rather than starting over (PROTOCOL.md "chunked transfer").
 *
 * each chunk on the wire is [u32 big-endian offset][data]. the receiver
 * ignores chunks it already has and refuses gaps - senders always send in
 * order from the requested offset.
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)chunking __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreChunking *shared __attribute__((swift_name("shared")));
- (id<FurcardsCoreKotlinSequence>)chunkPayload:(FurcardsCoreKotlinByteArray *)payload mtu:(int32_t)mtu fromOffset:(int32_t)fromOffset __attribute__((swift_name("chunk(payload:mtu:fromOffset:)")));

/** usable data bytes per chunk for a negotiated mtu */
- (int32_t)dataBytesPerChunkMtu:(int32_t)mtu __attribute__((swift_name("dataBytesPerChunk(mtu:)")));

/** att opcode + handle overhead on a gatt write-without-response */
@property (readonly) int32_t ATT_OVERHEAD_BYTES __attribute__((swift_name("ATT_OVERHEAD_BYTES")));
@property (readonly) int32_t OFFSET_PREFIX_BYTES __attribute__((swift_name("OFFSET_PREFIX_BYTES")));
@end


/** recommended scan cadence; transports map this onto platform scan settings */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("DutyCycle")))
@interface FurcardsCoreDutyCycle : FurcardsCoreKotlinEnum<FurcardsCoreDutyCycle *>
+ (instancetype)alloc __attribute__((unavailable));

/** recommended scan cadence; transports map this onto platform scan settings */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) FurcardsCoreDutyCycle *active __attribute__((swift_name("active")));
@property (class, readonly) FurcardsCoreDutyCycle *quiet __attribute__((swift_name("quiet")));
+ (FurcardsCoreKotlinArray<FurcardsCoreDutyCycle *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<FurcardsCoreDutyCycle *> *entries __attribute__((swift_name("entries")));
@property (readonly) int64_t scanOffMillis __attribute__((swift_name("scanOffMillis")));
@property (readonly) int64_t scanOnMillis __attribute__((swift_name("scanOnMillis")));
@end


/**
 * rotating 8-byte identifier broadcast while discovering peers, so nobody can
 * be tracked across time by a stable ble identity. replaces the server-era
 * random uuid token (same 15-minute cadence users already have) but needs no
 * registration anywhere: it is derived from a per-identity secret, and the
 * owner proves it implicitly by presenting a card signed by the matching key
 * during the exchange.
 *
 * core never reads a clock - callers pass epoch seconds in (keeps every
 * function replayable in tests and in the golden vectors).
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("EphemeralId")))
@interface FurcardsCoreEphemeralId : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/**
 * rotating 8-byte identifier broadcast while discovering peers, so nobody can
 * be tracked across time by a stable ble identity. replaces the server-era
 * random uuid token (same 15-minute cadence users already have) but needs no
 * registration anywhere: it is derived from a per-identity secret, and the
 * owner proves it implicitly by presenting a card signed by the matching key
 * during the exchange.
 *
 * core never reads a clock - callers pass epoch seconds in (keeps every
 * function replayable in tests and in the golden vectors).
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)ephemeralId __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreEphemeralId *shared __attribute__((swift_name("shared")));
- (FurcardsCoreKotlinByteArray *)currentSeed:(FurcardsCoreKotlinByteArray *)seed epochSeconds:(int64_t)epochSeconds __attribute__((swift_name("current(seed:epochSeconds:)")));

/**
 * per-identity rotation secret, derived once from the signing key and
 * stored next to it. deriving (not random) means export/import of the
 * identity reproduces the same ids; domain separation keeps the signing
 * key itself out of any hmac input.
 */
- (FurcardsCoreKotlinByteArray *)deriveSeedPrivateKey:(FurcardsCoreKotlinByteArray *)privateKey __attribute__((swift_name("deriveSeed(privateKey:)")));
- (FurcardsCoreKotlinByteArray *)forWindowSeed:(FurcardsCoreKotlinByteArray *)seed window:(int64_t)window __attribute__((swift_name("forWindow(seed:window:)")));
- (int64_t)windowEpochSeconds:(int64_t)epochSeconds __attribute__((swift_name("window(epochSeconds:)")));
@property (readonly) int32_t SIZE_BYTES __attribute__((swift_name("SIZE_BYTES")));
@property (readonly) int32_t WINDOW_SECONDS __attribute__((swift_name("WINDOW_SECONDS")));
@end


/**
 * picks which held cards to relay to a peer (PROTOCOL.md "gossip").
 * rules, all enforced here and nowhere else:
 *
 *  - only cards whose owner opted in (FLAG_ALLOW_RELAY)
 *  - only common-tier blobs; friend blobs were given to *you*, they are
 *    never passed along
 *  - nothing the peer already holds (their hello bloom; false positives just
 *    delay a card one session)
 *  - nothing on the local blocklist
 *  - at most [MAX_SESSION_BYTES] of blob bytes per session
 *
 * [candidates] should arrive newest-first (most recently received first);
 * selection preserves that order, so freshest cards spread fastest.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Gossip")))
@interface FurcardsCoreGossip : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/**
 * picks which held cards to relay to a peer (PROTOCOL.md "gossip").
 * rules, all enforced here and nowhere else:
 *
 *  - only cards whose owner opted in (FLAG_ALLOW_RELAY)
 *  - only common-tier blobs; friend blobs were given to *you*, they are
 *    never passed along
 *  - nothing the peer already holds (their hello bloom; false positives just
 *    delay a card one session)
 *  - nothing on the local blocklist
 *  - at most [MAX_SESSION_BYTES] of blob bytes per session
 *
 * [candidates] should arrive newest-first (most recently received first);
 * selection preserves that order, so freshest cards spread fastest.
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)gossip __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreGossip *shared __attribute__((swift_name("shared")));
- (NSArray<FurcardsCoreVerifiedCard *> *)selectCandidates:(NSArray<FurcardsCoreVerifiedCard *> *)candidates peerBloom:(FurcardsCoreBloomFilter *)peerBloom blocklist:(FurcardsCoreBlocklist *)blocklist budgetBytes:(int32_t)budgetBytes __attribute__((swift_name("select(candidates:peerBloom:blocklist:budgetBytes:)")));
@property (readonly) int32_t MAX_SESSION_BYTES __attribute__((swift_name("MAX_SESSION_BYTES")));
@end


/**
 * first message each side sends after connecting (PROTOCOL.md "hello").
 * cbor with integer labels, same [WireCbor] configuration as card payloads.
 *
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Hello")))
@interface FurcardsCoreHello : FurcardsCoreBase
- (instancetype)initWithProtocolVersion:(int32_t)protocolVersion ephemeralId:(FurcardsCoreKotlinByteArray *)ephemeralId cardVersion:(int64_t)cardVersion seenBloom:(FurcardsCoreKotlinByteArray *)seenBloom bumpIntent:(BOOL)bumpIntent bumpMessage:(NSString *)bumpMessage publicKey:(FurcardsCoreKotlinByteArray *)publicKey __attribute__((swift_name("init(protocolVersion:ephemeralId:cardVersion:seenBloom:bumpIntent:bumpMessage:publicKey:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreHelloCompanion *companion __attribute__((swift_name("companion")));
- (FurcardsCoreHello *)doCopyProtocolVersion:(int32_t)protocolVersion ephemeralId:(FurcardsCoreKotlinByteArray *)ephemeralId cardVersion:(int64_t)cardVersion seenBloom:(FurcardsCoreKotlinByteArray *)seenBloom bumpIntent:(BOOL)bumpIntent bumpMessage:(NSString *)bumpMessage publicKey:(FurcardsCoreKotlinByteArray *)publicKey __attribute__((swift_name("doCopy(protocolVersion:ephemeralId:cardVersion:seenBloom:bumpIntent:bumpMessage:publicKey:)")));
- (FurcardsCoreKotlinByteArray *)encode __attribute__((swift_name("encode()")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));

/**
 * first message each side sends after connecting (PROTOCOL.md "hello").
 * cbor with integer labels, same [WireCbor] configuration as card payloads.
 */
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * true when the user is actively asking to bump (deliberate friend
 * exchange, migration ruling D6). both sides must set it for the session
 * to enter the friend-blob + messages phase.
 */
@property (readonly) BOOL bumpIntent __attribute__((swift_name("bumpIntent")));

/** custom message attached to the bump, only read when bump completes */
@property (readonly) NSString *bumpMessage __attribute__((swift_name("bumpMessage")));

/** version of the senders own card, so peers skip re-fetching known ones */
@property (readonly) int64_t cardVersion __attribute__((swift_name("cardVersion")));

/** senders current rotating id, [EphemeralId.SIZE_BYTES] bytes */
@property (readonly) FurcardsCoreKotlinByteArray *ephemeralId __attribute__((swift_name("ephemeralId")));
@property (readonly) int32_t protocolVersion __attribute__((swift_name("protocolVersion")));

/**
 * senders identity key. lets both sides compute the card-swap decision
 * (peer bloom vs own key) in BOTH directions - without it neither side
 * knows whether a card is coming and the session end deadlocks - and lets
 * the blocklist kill a session before any transfer. sent only over an
 * established connection, never advertised: connections always end in the
 * signed card anyway, so this reveals nothing extra.
 */
@property (readonly) FurcardsCoreKotlinByteArray *publicKey __attribute__((swift_name("publicKey")));

/** bloom filter over [BloomFilter.cardKey]s of every card the sender holds */
@property (readonly) FurcardsCoreKotlinByteArray *seenBloom __attribute__((swift_name("seenBloom")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Hello.Companion")))
@interface FurcardsCoreHelloCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreHelloCompanion *shared __attribute__((swift_name("shared")));

/** decode + structural validation; null means ignore the peer */
- (FurcardsCoreHello * _Nullable)decodeBytes:(FurcardsCoreKotlinByteArray *)bytes __attribute__((swift_name("decode(bytes:)")));
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@property (readonly) int32_t MAX_BUMP_MESSAGE_CHARS __attribute__((swift_name("MAX_BUMP_MESSAGE_CHARS")));

/** hello with a full bloom + message stays well under one l2cap/gatt exchange */
@property (readonly) int32_t MAX_ENCODED_BYTES __attribute__((swift_name("MAX_ENCODED_BYTES")));
@property (readonly) int32_t PROTOCOL_VERSION __attribute__((swift_name("PROTOCOL_VERSION")));
@end


/**
 * drives one [ExchangeSession] over one transport until it completes, fails
 * or times out. lives in the core so every platform runs the identical loop -
 * adapters only move bytes.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExchangeRunner")))
@interface FurcardsCoreExchangeRunner : FurcardsCoreBase
- (instancetype)initWithScope:(id<FurcardsCoreKotlinx_coroutines_coreCoroutineScope>)scope clock:(FurcardsCoreLong *(^)(void))clock __attribute__((swift_name("init(scope:clock:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreExchangeRunnerCompanion *companion __attribute__((swift_name("companion")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)runSession:(FurcardsCoreExchangeSession *)session transport:(id<FurcardsCoreExchangeTransport>)transport completionHandler:(void (^)(FurcardsCoreExchangeSessionSessionResult * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("run(session:transport:completionHandler:)")));

/**
 * [lastActivityMillis], when provided, reads the transport's last
 * byte-arrival clock so mid-frame progress (a big art frame arriving in
 * mtu chunks) keeps the session's stall deadline fed. without it only
 * whole frames count as progress.
 *
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)runSession:(FurcardsCoreExchangeSession *)session transport:(id<FurcardsCoreExchangeTransport>)transport lastActivityMillis:(FurcardsCoreLong *(^ _Nullable)(void))lastActivityMillis completionHandler:(void (^)(FurcardsCoreExchangeSessionSessionResult * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("run(session:transport:lastActivityMillis:completionHandler:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExchangeRunner.Companion")))
@interface FurcardsCoreExchangeRunnerCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreExchangeRunnerCompanion *shared __attribute__((swift_name("shared")));
@property (readonly) int64_t TICK_MILLIS __attribute__((swift_name("TICK_MILLIS")));
@end

__attribute__((swift_name("KotlinThrowable")))
@interface FurcardsCoreKotlinThrowable : FurcardsCoreBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(FurcardsCoreKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(FurcardsCoreKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));

/**
 * @note annotations
 *   kotlin.experimental.ExperimentalNativeApi
*/
- (FurcardsCoreKotlinArray<NSString *> *)getStackTrace __attribute__((swift_name("getStackTrace()")));
- (void)printStackTrace __attribute__((swift_name("printStackTrace()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) FurcardsCoreKotlinThrowable * _Nullable cause __attribute__((swift_name("cause")));
@property (readonly) NSString * _Nullable message __attribute__((swift_name("message")));
- (NSError *)asError __attribute__((swift_name("asError()")));
@end

__attribute__((swift_name("KotlinException")))
@interface FurcardsCoreKotlinException : FurcardsCoreKotlinThrowable
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(FurcardsCoreKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(FurcardsCoreKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExchangeRunner.SessionFailedException")))
@interface FurcardsCoreExchangeRunnerSessionFailedException : FurcardsCoreKotlinException
- (instancetype)initWithReason:(FurcardsCoreExchangeSessionFailReason *)reason __attribute__((swift_name("init(reason:)"))) __attribute__((objc_designated_initializer));
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
- (instancetype)initWithCause:(FurcardsCoreKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(FurcardsCoreKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (readonly) FurcardsCoreExchangeSessionFailReason *reason __attribute__((swift_name("reason")));
@end


/**
 * one card-exchange session, as a pure state machine (PROTOCOL.md "session").
 * no clocks, no sockets, no coroutines: events go in, actions come out, so
 * the exact same machine runs under corebluetooth, android gatt, and the
 * in-memory transport in commonTest.
 *
 * flow (symmetric; both sides run the same machine):
 *
 *   connected(mtu) ─→ send HELLO
 *   HELLO received ─→ blocklist gate; queue own CARD if peer bloom lacks it,
 *                     FRIEND_CARD too when both sides set bumpIntent (D5/D6),
 *                     then GOSSIP_CARDs (Gossip.select), then maybe
 *                     ART_REQUEST (only after the peer card it refers to has
 *                     arrived), then DONE
 *   settled        ─→ sent DONE + received DONE + no outstanding art either way
 *
 * DONE means "my push phase is over"; ART_DATA answers may still flow after
 * it. every incoming blob is structurally checked, signature-verified and
 * blocklist-filtered before it reaches the result - an unverified byte never
 * leaves this class.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExchangeSession")))
@interface FurcardsCoreExchangeSession : FurcardsCoreBase
- (instancetype)initWithMe:(FurcardsCoreExchangeSessionLocalIdentity *)me crypto:(id<FurcardsCoreCryptoProvider>)crypto blocklist:(FurcardsCoreBlocklist *)blocklist relayCandidates:(NSArray<FurcardsCoreVerifiedCard *> *)relayCandidates nowMillis:(int64_t)nowMillis __attribute__((swift_name("init(me:crypto:blocklist:relayCandidates:nowMillis:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreExchangeSessionCompanion *companion __attribute__((swift_name("companion")));
- (NSArray<id<FurcardsCoreExchangeSessionAction>> *)onConnectedMtu:(int32_t)mtu nowMillis:(int64_t)nowMillis __attribute__((swift_name("onConnected(mtu:nowMillis:)")));
- (NSArray<id<FurcardsCoreExchangeSessionAction>> *)onFrameFrame:(FurcardsCoreKotlinByteArray *)frame __attribute__((swift_name("onFrame(frame:)")));

/**
 * call whenever the LINK shows life (bytes/packets arriving, not just
 * whole frames). the deadline is a STALL detector, not a total-duration
 * cap - a bump moving 300 KB of art at gatt speeds is healthy but slow,
 * and killing it at a fixed 10 s was the field's "timeouts super often".
 * an absolute ceiling still bounds a byte-dribbling peer.
 */
- (void)onProgressNowMillis:(int64_t)nowMillis __attribute__((swift_name("onProgress(nowMillis:)")));

/** call periodically (or on transport quiet); enforces the stall deadline */
- (NSArray<id<FurcardsCoreExchangeSessionAction>> *)onTickNowMillis:(int64_t)nowMillis __attribute__((swift_name("onTick(nowMillis:)")));
@property (readonly) BOOL isSettled __attribute__((swift_name("isSettled")));
@end

__attribute__((swift_name("ExchangeSessionAction")))
@protocol FurcardsCoreExchangeSessionAction
@required
@end


/** session over; report and disconnect */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExchangeSessionActionComplete")))
@interface FurcardsCoreExchangeSessionActionComplete : FurcardsCoreBase <FurcardsCoreExchangeSessionAction>
- (instancetype)initWithResult:(FurcardsCoreExchangeSessionSessionResult *)result __attribute__((swift_name("init(result:)"))) __attribute__((objc_designated_initializer));
- (FurcardsCoreExchangeSessionActionComplete *)doCopyResult:(FurcardsCoreExchangeSessionSessionResult *)result __attribute__((swift_name("doCopy(result:)")));

/** session over; report and disconnect */
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));

/** session over; report and disconnect */
- (NSUInteger)hash __attribute__((swift_name("hash()")));

/** session over; report and disconnect */
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) FurcardsCoreExchangeSessionSessionResult *result __attribute__((swift_name("result")));
@end


/** session dead; disconnect and let anti-storm record the failure */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExchangeSessionActionFail")))
@interface FurcardsCoreExchangeSessionActionFail : FurcardsCoreBase <FurcardsCoreExchangeSessionAction>
- (instancetype)initWithReason:(FurcardsCoreExchangeSessionFailReason *)reason __attribute__((swift_name("init(reason:)"))) __attribute__((objc_designated_initializer));
- (FurcardsCoreExchangeSessionActionFail *)doCopyReason:(FurcardsCoreExchangeSessionFailReason *)reason __attribute__((swift_name("doCopy(reason:)")));

/** session dead; disconnect and let anti-storm record the failure */
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));

/** session dead; disconnect and let anti-storm record the failure */
- (NSUInteger)hash __attribute__((swift_name("hash()")));

/** session dead; disconnect and let anti-storm record the failure */
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) FurcardsCoreExchangeSessionFailReason *reason __attribute__((swift_name("reason")));
@end


/** hand these bytes to the transport as one frame */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExchangeSessionActionSend")))
@interface FurcardsCoreExchangeSessionActionSend : FurcardsCoreBase <FurcardsCoreExchangeSessionAction>
- (instancetype)initWithFrame:(FurcardsCoreKotlinByteArray *)frame __attribute__((swift_name("init(frame:)"))) __attribute__((objc_designated_initializer));
- (FurcardsCoreExchangeSessionActionSend *)doCopyFrame:(FurcardsCoreKotlinByteArray *)frame __attribute__((swift_name("doCopy(frame:)")));

/** hand these bytes to the transport as one frame */
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));

/** hand these bytes to the transport as one frame */
- (NSUInteger)hash __attribute__((swift_name("hash()")));

/** hand these bytes to the transport as one frame */
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) FurcardsCoreKotlinByteArray *frame __attribute__((swift_name("frame")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExchangeSession.Companion")))
@interface FurcardsCoreExchangeSessionCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreExchangeSessionCompanion *shared __attribute__((swift_name("shared")));

/** absolute ceiling per session, art transfers included */
@property (readonly) int64_t MAX_SESSION_MILLIS __attribute__((swift_name("MAX_SESSION_MILLIS")));

/** no bytes for this long = the link is dead, fail the session */
@property (readonly) int64_t STALL_TIMEOUT_MILLIS __attribute__((swift_name("STALL_TIMEOUT_MILLIS")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExchangeSession.FailReason")))
@interface FurcardsCoreExchangeSessionFailReason : FurcardsCoreKotlinEnum<FurcardsCoreExchangeSessionFailReason *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) FurcardsCoreExchangeSessionFailReason *blocked __attribute__((swift_name("blocked")));
@property (class, readonly) FurcardsCoreExchangeSessionFailReason *badHello __attribute__((swift_name("badHello")));
@property (class, readonly) FurcardsCoreExchangeSessionFailReason *protocolViolation __attribute__((swift_name("protocolViolation")));
@property (class, readonly) FurcardsCoreExchangeSessionFailReason *timeout __attribute__((swift_name("timeout")));
+ (FurcardsCoreKotlinArray<FurcardsCoreExchangeSessionFailReason *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<FurcardsCoreExchangeSessionFailReason *> *entries __attribute__((swift_name("entries")));
@end


/** everything the session needs about the local user */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExchangeSession.LocalIdentity")))
@interface FurcardsCoreExchangeSessionLocalIdentity : FurcardsCoreBase
- (instancetype)initWithEphemeralId:(FurcardsCoreKotlinByteArray *)ephemeralId commonCard:(FurcardsCoreSignedCard *)commonCard friendCard:(FurcardsCoreSignedCard * _Nullable)friendCard fullArt:(FurcardsCoreKotlinByteArray * _Nullable)fullArt seenBloom:(FurcardsCoreBloomFilter *)seenBloom bumpIntent:(BOOL)bumpIntent bumpMessage:(NSString *)bumpMessage wantsPeerFullArt:(BOOL)wantsPeerFullArt bumpTargetPublicKey:(FurcardsCoreKotlinByteArray * _Nullable)bumpTargetPublicKey __attribute__((swift_name("init(ephemeralId:commonCard:friendCard:fullArt:seenBloom:bumpIntent:bumpMessage:wantsPeerFullArt:bumpTargetPublicKey:)"))) __attribute__((objc_designated_initializer));
@property (readonly) BOOL bumpIntent __attribute__((swift_name("bumpIntent")));
@property (readonly) NSString *bumpMessage __attribute__((swift_name("bumpMessage")));

/**
 * when set, the bump only completes with THIS identity (the
 * bump-from-their-card flow - no "is this the right person"
 * confirmation needed). null = bump whoever also armed (badge/idle).
 */
@property (readonly) FurcardsCoreKotlinByteArray * _Nullable bumpTargetPublicKey __attribute__((swift_name("bumpTargetPublicKey")));
@property (readonly) FurcardsCoreSignedCard *commonCard __attribute__((swift_name("commonCard")));
@property (readonly) FurcardsCoreKotlinByteArray *ephemeralId __attribute__((swift_name("ephemeralId")));

/** friend-tier blob, absent when the user has no friend tier configured */
@property (readonly) FurcardsCoreSignedCard * _Nullable friendCard __attribute__((swift_name("friendCard")));

/** full art bytes matching the payload fullArtHash, if any */
@property (readonly) FurcardsCoreKotlinByteArray * _Nullable fullArt __attribute__((swift_name("fullArt")));

/** bloom over every card key we hold (own card NOT included) */
@property (readonly) FurcardsCoreBloomFilter *seenBloom __attribute__((swift_name("seenBloom")));
@property (readonly) BOOL wantsPeerFullArt __attribute__((swift_name("wantsPeerFullArt")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ExchangeSession.SessionResult")))
@interface FurcardsCoreExchangeSessionSessionResult : FurcardsCoreBase
- (instancetype)initWithPeerCard:(FurcardsCoreVerifiedCard * _Nullable)peerCard peerFriendCard:(FurcardsCoreVerifiedCard * _Nullable)peerFriendCard gossip:(NSArray<FurcardsCoreVerifiedCard *> *)gossip bumpCompleted:(BOOL)bumpCompleted peerBumpMessage:(NSString *)peerBumpMessage peerFullArt:(FurcardsCoreKotlinByteArray * _Nullable)peerFullArt droppedCount:(int32_t)droppedCount peerCardVersion:(uint32_t)peerCardVersion __attribute__((swift_name("init(peerCard:peerFriendCard:gossip:bumpCompleted:peerBumpMessage:peerFullArt:droppedCount:peerCardVersion:)"))) __attribute__((objc_designated_initializer));
@property (readonly) BOOL bumpCompleted __attribute__((swift_name("bumpCompleted")));

/** received blobs that failed verification or were blocked - diagnostics only */
@property (readonly) int32_t droppedCount __attribute__((swift_name("droppedCount")));
@property (readonly) NSArray<FurcardsCoreVerifiedCard *> *gossip __attribute__((swift_name("gossip")));
@property (readonly) NSString *peerBumpMessage __attribute__((swift_name("peerBumpMessage")));
@property (readonly) FurcardsCoreVerifiedCard * _Nullable peerCard __attribute__((swift_name("peerCard")));

/**
 * the peer's own card version from their hello - present even when no
 * card transferred (bloom hit). anti-storm dedupe keys on this, so a
 * "nothing new" session suppresses reconnects exactly like a full one
 * (without it the field devices re-handshook every few seconds forever).
 */
@property (readonly) uint32_t peerCardVersion __attribute__((swift_name("peerCardVersion")));
@property (readonly) FurcardsCoreVerifiedCard * _Nullable peerFriendCard __attribute__((swift_name("peerFriendCard")));
@property (readonly) FurcardsCoreKotlinByteArray * _Nullable peerFullArt __attribute__((swift_name("peerFullArt")));
@end


/**
 * what a platform ble adapter implements (corebluetooth / android gatt /
 * l2cap - and the in-memory pair in commonTest). the contract the session
 * machine relies on:
 *
 *  - frames are delivered whole (adapters own mtu chunking/reassembly via
 *    [com.fulltimefeline.furcards.core.protocol.Chunking]) and IN ORDER
 *  - [incoming] closes when the link drops
 *  - [send] suspends until the frame is handed to the link (backpressure)
 */
__attribute__((swift_name("ExchangeTransport")))
@protocol FurcardsCoreExchangeTransport
@required
- (void)close __attribute__((swift_name("close()")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)sendFrame:(FurcardsCoreKotlinByteArray *)frame completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("send(frame:completionHandler:)")));
@property (readonly) id<FurcardsCoreKotlinx_coroutines_coreReceiveChannel> incoming __attribute__((swift_name("incoming")));

/** negotiated mtu, for adapters that chunk; informational to the core */
@property (readonly) int32_t mtu __attribute__((swift_name("mtu")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FramePipeDecoder")))
@interface FurcardsCoreFramePipeDecoder : FurcardsCoreBase
- (instancetype)initWithMaxFrameBytes:(int32_t)maxFrameBytes __attribute__((swift_name("init(maxFrameBytes:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreFramePipeDecoderCompanion *companion __attribute__((swift_name("companion")));

/**
 * feeds one received packet; returns a completed frame when this packet
 * finished one, null otherwise. a null return with [isPoisoned] set means
 * the stream is broken and the connection must be dropped.
 */
- (FurcardsCoreKotlinByteArray * _Nullable)acceptPacket:(FurcardsCoreKotlinByteArray *)packet __attribute__((swift_name("accept(packet:)")));
@property (readonly) BOOL isPoisoned __attribute__((swift_name("isPoisoned")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FramePipeDecoder.Companion")))
@interface FurcardsCoreFramePipeDecoderCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreFramePipeDecoderCompanion *shared __attribute__((swift_name("shared")));

/** largest legal frame: full art + frame type byte, with headroom */
@property (readonly) int32_t MAX_FRAME_BYTES __attribute__((swift_name("MAX_FRAME_BYTES")));
@end


/**
 * turns whole session frames into mtu-sized packets and back (PROTOCOL.md
 * §4/§10). both directions of the gatt pipe run one of these each; the l2cap
 * path uses plain u32-length-prefixed frames instead and skips this.
 *
 * packet stream per frame:
 *   [0x46]['F' header][u32be frameLength]           - announces one frame
 *   [u32be offset][data...]                          - chunks until complete
 *
 * a header is only legal between frames and a chunk only inside one, so the
 * decoder is never ambiguous. any violation poisons the pipe - the session
 * dies rather than guessing (transports reconnect + resume).
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FramePipeEncoder")))
@interface FurcardsCoreFramePipeEncoder : FurcardsCoreBase
- (instancetype)initWithMtu:(int32_t)mtu __attribute__((swift_name("init(mtu:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreFramePipeEncoderCompanion *companion __attribute__((swift_name("companion")));
- (NSArray<FurcardsCoreKotlinByteArray *> *)encodeFrame:(FurcardsCoreKotlinByteArray *)frame __attribute__((swift_name("encode(frame:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FramePipeEncoder.Companion")))
@interface FurcardsCoreFramePipeEncoderCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreFramePipeEncoderCompanion *shared __attribute__((swift_name("shared")));
@property (readonly) int8_t HEADER_MARKER __attribute__((swift_name("HEADER_MARKER")));
@end


/** frame = [type u8][body]; framing/reassembly is the transport's job */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Frames")))
@interface FurcardsCoreFrames : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/** frame = [type u8][body]; framing/reassembly is the transport's job */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)frames __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreFrames *shared __attribute__((swift_name("shared")));
- (FurcardsCoreKotlinByteArray *)frameType:(int8_t)type body:(FurcardsCoreKotlinByteArray *)body __attribute__((swift_name("frame(type:body:)")));
@property (readonly) int8_t ART_DATA __attribute__((swift_name("ART_DATA")));
@property (readonly) int8_t ART_REQUEST __attribute__((swift_name("ART_REQUEST")));
@property (readonly) int8_t CARD __attribute__((swift_name("CARD")));
@property (readonly) int8_t DONE __attribute__((swift_name("DONE")));
@property (readonly) int8_t FRIEND_CARD __attribute__((swift_name("FRIEND_CARD")));
@property (readonly) int8_t GOSSIP_CARD __attribute__((swift_name("GOSSIP_CARD")));
@property (readonly) int8_t HELLO __attribute__((swift_name("HELLO")));
@end


/**
 * pull whole frames out of an arbitrary-boundary byte stream. feed whatever
 * the socket read returned; complete frames come out in order. oversized
 * announces poison the stream (drop the socket, never guess).
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("L2capFrameReader")))
@interface FurcardsCoreL2capFrameReader : FurcardsCoreBase
- (instancetype)initWithMaxFrameBytes:(int32_t)maxFrameBytes __attribute__((swift_name("init(maxFrameBytes:)"))) __attribute__((objc_designated_initializer));
- (NSArray<FurcardsCoreKotlinByteArray *> *)acceptBytes:(FurcardsCoreKotlinByteArray *)bytes __attribute__((swift_name("accept(bytes:)")));
@property (readonly) BOOL isPoisoned __attribute__((swift_name("isPoisoned")));
@end


/**
 * frame codec for the l2cap path (PROTOCOL.md §4): the channel is a plain
 * reliable byte stream, so frames are just `[u32be length][frame]` - no
 * chunking, no headers, no resume (a dropped socket restarts the session;
 * l2cap credit-based flow control already handles segmentation).
 *
 * shared so ios (CBL2CAPChannel streams) and android (BluetoothSocket
 * streams) cannot drift on the framing.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("L2capFraming")))
@interface FurcardsCoreL2capFraming : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/**
 * frame codec for the l2cap path (PROTOCOL.md §4): the channel is a plain
 * reliable byte stream, so frames are just `[u32be length][frame]` - no
 * chunking, no headers, no resume (a dropped socket restarts the session;
 * l2cap credit-based flow control already handles segmentation).
 *
 * shared so ios (CBL2CAPChannel streams) and android (BluetoothSocket
 * streams) cannot drift on the framing.
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)l2capFraming __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreL2capFraming *shared __attribute__((swift_name("shared")));
- (FurcardsCoreKotlinByteArray *)encodeFrame:(FurcardsCoreKotlinByteArray *)frame __attribute__((swift_name("encode(frame:)")));
@end


/** hard caps enforced when sealing AND when parsing (PROTOCOL.md "caps") */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardCaps")))
@interface FurcardsCoreCardCaps : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/** hard caps enforced when sealing AND when parsing (PROTOCOL.md "caps") */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)cardCaps __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreCardCaps *shared __attribute__((swift_name("shared")));

/** violations, empty when the payload is sealable */
- (NSArray<NSString *> *)validateP:(FurcardsCoreCardPayload *)p __attribute__((swift_name("validate(p:)")));
@property (readonly) int32_t MAX_ARTIST_CREDIT_CHARS __attribute__((swift_name("MAX_ARTIST_CREDIT_CHARS")));
@property (readonly) int32_t MAX_BIO_CHARS __attribute__((swift_name("MAX_BIO_CHARS")));
@property (readonly) int32_t MAX_FULL_ART_BYTES __attribute__((swift_name("MAX_FULL_ART_BYTES")));
@property (readonly) int32_t MAX_IDENTITY_FLAGS_CHARS __attribute__((swift_name("MAX_IDENTITY_FLAGS_CHARS")));
@property (readonly) int32_t MAX_MESSAGE_CHARS __attribute__((swift_name("MAX_MESSAGE_CHARS")));
@property (readonly) int32_t MAX_NAME_CHARS __attribute__((swift_name("MAX_NAME_CHARS")));

/** ceiling for a whole encoded payload; anything bigger is rejected unparsed */
@property (readonly) int32_t MAX_PAYLOAD_BYTES __attribute__((swift_name("MAX_PAYLOAD_BYTES")));
@property (readonly) int32_t MAX_PRONOUNS_CHARS __attribute__((swift_name("MAX_PRONOUNS_CHARS")));
@property (readonly) int32_t MAX_SOCIALS __attribute__((swift_name("MAX_SOCIALS")));
@property (readonly) int32_t MAX_SOCIAL_HANDLE_CHARS __attribute__((swift_name("MAX_SOCIAL_HANDLE_CHARS")));
@property (readonly) int32_t MAX_TAGS __attribute__((swift_name("MAX_TAGS")));
@property (readonly) int32_t MAX_TAG_CHARS __attribute__((swift_name("MAX_TAG_CHARS")));
@property (readonly) int32_t MAX_THEME_COLORS __attribute__((swift_name("MAX_THEME_COLORS")));
@property (readonly) int32_t MAX_THUMBNAIL_BYTES __attribute__((swift_name("MAX_THUMBNAIL_BYTES")));
@end


/**
 * bridges the persisted/UI [Furcard] model and the wire [CardPayload].
 * the app model keeps its uuid ids and platform-side artwork fields; the
 * payload drops them (D3/D20). artwork bytes <-> data-uri conversion happens
 * in platform code (ios stores Data, android stores a data: uri string), so
 * the mapping here takes/hands raw bytes.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardMapping")))
@interface FurcardsCoreCardMapping : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/**
 * bridges the persisted/UI [Furcard] model and the wire [CardPayload].
 * the app model keeps its uuid ids and platform-side artwork fields; the
 * payload drops them (D3/D20). artwork bytes <-> data-uri conversion happens
 * in platform code (ios stores Data, android stores a data: uri string), so
 * the mapping here takes/hands raw bytes.
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)cardMapping __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreCardMapping *shared __attribute__((swift_name("shared")));

/** stripped socials rule shared by both tiers, mirrors Furcard.commonCard */
- (NSArray<FurcardsCoreSocialLink *> *)commonSocialsCard:(FurcardsCoreFurcard *)card __attribute__((swift_name("commonSocials(card:)")));

/**
 * deterministic storage id for a signed card, shaped like the uuid strings
 * both apps already key their collections by. derived from the identity so
 * every re-receipt of any version of the same card maps onto the same
 * stored entry (friend + common tiers collapse to the same id: they are
 * the same person, the friend blob just renders with more fields).
 */
- (NSString *)storageIdPublicKey:(FurcardsCoreKotlinByteArray *)publicKey __attribute__((swift_name("storageId(publicKey:)")));

/**
 * rebuilds a displayable [Furcard] from a verified payload. [artworkData]
 * is the platform-encoded artwork field (data: uri on android, base64 on
 * ios' side of the bridge) built from the payload thumbnail by the caller.
 */
- (FurcardsCoreFurcard *)toFurcardVerified:(FurcardsCoreVerifiedCard *)verified artworkData:(NSString * _Nullable)artworkData __attribute__((swift_name("toFurcard(verified:artworkData:)")));

/**
 * builds the payload for one tier of the owner's card. [thumbnail] must
 * already be re-encoded to the 256x256 <=32 KB cap - the core does not do
 * image processing.
 */
- (FurcardsCoreCardPayload *)toPayloadCard:(FurcardsCoreFurcard *)card friendTier:(BOOL)friendTier allowRelay:(BOOL)allowRelay allowEncounterCount:(BOOL)allowEncounterCount thumbnail:(FurcardsCoreKotlinByteArray * _Nullable)thumbnail fullArtHash:(FurcardsCoreKotlinByteArray * _Nullable)fullArtHash legacyId:(NSString * _Nullable)legacyId commonCount:(int64_t)commonCount shinyCount:(int64_t)shinyCount __attribute__((swift_name("toPayload(card:friendTier:allowRelay:allowEncounterCount:thumbnail:fullArtHash:legacyId:commonCount:shinyCount:)")));
@end


/**
 * the cbor payload inside a signed card blob.
 *
 * field set mirrors the EXISTING Furcard model (migration ruling D4) - no
 * invented "species"/"accentColor" fields. differences from the app model are
 * all wire hygiene:
 *  - no uuid ids on the card, socials or colors (identity = pubkey in the
 *    header; ids are a local storage concern, D20)
 *  - artwork rides as raw thumbnail bytes; the optional full-size art travels
 *    OUTSIDE the blob (separate chunked/l2cap transfer) and is pinned here by
 *    its sha-256 so blobs stay small enough to gossip
 *  - no artworkName (asset-catalog names dont exist cross-platform, D3) and
 *    no originalArtworkData (owner-local re-crop convenience, D3)
 *  - no walkedByCount/bumpCount (server stats are dead; local counts are
 *    gated by [FLAG_ALLOW_ENCOUNTER_COUNT], D7)
 *
 * integer cbor labels instead of field-name strings keep a full card ~1 KB
 * smaller; labels are frozen protocol surface - never renumber (PROTOCOL.md).
 *
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardPayload")))
@interface FurcardsCoreCardPayload : FurcardsCoreBase
- (instancetype)initWithName:(NSString *)name pronouns:(NSString *)pronouns identityFlags:(NSString *)identityFlags artistCredit:(NSString *)artistCredit tags:(NSArray<NSString *> *)tags bio:(NSString *)bio socials:(NSArray<FurcardsCorePayloadSocial *> *)socials message:(NSString *)message theme:(FurcardsCorePayloadTheme *)theme template:(FurcardsCoreCardTemplate * _Nullable)template_ thumbnail:(FurcardsCoreKotlinByteArray * _Nullable)thumbnail fullArtHash:(FurcardsCoreKotlinByteArray * _Nullable)fullArtHash flags:(int64_t)flags legacyId:(NSString * _Nullable)legacyId commonCount:(int64_t)commonCount shinyCount:(int64_t)shinyCount __attribute__((swift_name("init(name:pronouns:identityFlags:artistCredit:tags:bio:socials:message:theme:template:thumbnail:fullArtHash:flags:legacyId:commonCount:shinyCount:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCoreCardPayloadCompanion *companion __attribute__((swift_name("companion")));
- (FurcardsCoreCardPayload *)doCopyName:(NSString *)name pronouns:(NSString *)pronouns identityFlags:(NSString *)identityFlags artistCredit:(NSString *)artistCredit tags:(NSArray<NSString *> *)tags bio:(NSString *)bio socials:(NSArray<FurcardsCorePayloadSocial *> *)socials message:(NSString *)message theme:(FurcardsCorePayloadTheme *)theme template:(FurcardsCoreCardTemplate * _Nullable)template_ thumbnail:(FurcardsCoreKotlinByteArray * _Nullable)thumbnail fullArtHash:(FurcardsCoreKotlinByteArray * _Nullable)fullArtHash flags:(int64_t)flags legacyId:(NSString * _Nullable)legacyId commonCount:(int64_t)commonCount shinyCount:(int64_t)shinyCount __attribute__((swift_name("doCopy(name:pronouns:identityFlags:artistCredit:tags:bio:socials:message:theme:template:thumbnail:fullArtHash:flags:legacyId:commonCount:shinyCount:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));

/**
 * the cbor payload inside a signed card blob.
 *
 * field set mirrors the EXISTING Furcard model (migration ruling D4) - no
 * invented "species"/"accentColor" fields. differences from the app model are
 * all wire hygiene:
 *  - no uuid ids on the card, socials or colors (identity = pubkey in the
 *    header; ids are a local storage concern, D20)
 *  - artwork rides as raw thumbnail bytes; the optional full-size art travels
 *    OUTSIDE the blob (separate chunked/l2cap transfer) and is pinned here by
 *    its sha-256 so blobs stay small enough to gossip
 *  - no artworkName (asset-catalog names dont exist cross-platform, D3) and
 *    no originalArtworkData (owner-local re-crop convenience, D3)
 *  - no walkedByCount/bumpCount (server stats are dead; local counts are
 *    gated by [FLAG_ALLOW_ENCOUNTER_COUNT], D7)
 *
 * integer cbor labels instead of field-name strings keep a full card ~1 KB
 * smaller; labels are frozen protocol surface - never renumber (PROTOCOL.md).
 */
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *artistCredit __attribute__((swift_name("artistCredit")));
@property (readonly) NSString *bio __attribute__((swift_name("bio")));

/**
 * how many cards the owner has collected, shown as vanity stats on the
 * card back. only meaningful when [FLAG_ALLOW_ENCOUNTER_COUNT] is set;
 * 0 otherwise. [commonCount] = cards collected by nearby trading,
 * [shinyCount] = shiny (friend) cards unlocked by bumping.
 */
@property (readonly) int64_t commonCount __attribute__((swift_name("commonCount")));

/** bitfield, see FLAG_* */
@property (readonly) int64_t flags __attribute__((swift_name("flags")));

/** sha-256 of the optional out-of-band full art (<= [CardCaps.MAX_FULL_ART_BYTES]) */
@property (readonly) FurcardsCoreKotlinByteArray * _Nullable fullArtHash __attribute__((swift_name("fullArtHash")));
@property (readonly) NSString *identityFlags __attribute__((swift_name("identityFlags")));

/**
 * the owner's pre-migration server-era card uuid, if any. lets a receiver
 * who holds that unsigned legacy card offer an in-place upgrade when this
 * signed card arrives over an in-person exchange. self-asserted (anyone
 * who ever RECEIVED the legacy card knows its id), which is why upgrades
 * driven by this hint still require user confirmation - see
 * CardSupersession.legacyUpgradeCandidate.
 */
@property (readonly) NSString * _Nullable legacyId __attribute__((swift_name("legacyId")));
@property (readonly) NSString *message __attribute__((swift_name("message")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@property (readonly) NSString *pronouns __attribute__((swift_name("pronouns")));
@property (readonly) int64_t shinyCount __attribute__((swift_name("shinyCount")));
@property (readonly) NSArray<FurcardsCorePayloadSocial *> *socials __attribute__((swift_name("socials")));
@property (readonly) NSArray<NSString *> *tags __attribute__((swift_name("tags")));
@property (readonly, getter=template) FurcardsCoreCardTemplate * _Nullable template_ __attribute__((swift_name("template_")));
@property (readonly) FurcardsCorePayloadTheme *theme __attribute__((swift_name("theme")));

/** card-cropped artwork, jpeg/png/heic bytes, <= [CardCaps.MAX_THUMBNAIL_BYTES] at 256x256 */
@property (readonly) FurcardsCoreKotlinByteArray * _Nullable thumbnail __attribute__((swift_name("thumbnail")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardPayload.Companion")))
@interface FurcardsCoreCardPayloadCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreCardPayloadCompanion *shared __attribute__((swift_name("shared")));
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));

/** receivers may show the owner a local encounter count */
@property (readonly) int64_t FLAG_ALLOW_ENCOUNTER_COUNT __attribute__((swift_name("FLAG_ALLOW_ENCOUNTER_COUNT")));

/** this card may be re-shared to third parties over gossip */
@property (readonly) int64_t FLAG_ALLOW_RELAY __attribute__((swift_name("FLAG_ALLOW_RELAY")));

/** this is the friend-tier blob (full socials); absent = common tier (D5) */
@property (readonly) int64_t FLAG_FRIEND_TIER __attribute__((swift_name("FLAG_FRIEND_TIER")));

/** full art exists and can be requested out of band */
@property (readonly) int64_t FLAG_HAS_FULL_ART __attribute__((swift_name("FLAG_HAS_FULL_ART")));
@end


/** version supersession + legacy upgrade rules (PROTOCOL.md "supersession") */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardSupersession")))
@interface FurcardsCoreCardSupersession : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));

/** version supersession + legacy upgrade rules (PROTOCOL.md "supersession") */
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)cardSupersession __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreCardSupersession *shared __attribute__((swift_name("shared")));

/**
 * whether [incoming] is an upgrade candidate for an unsigned server-era
 * card with local storage id [legacyCardId]. the hint is self-asserted
 * and public to anyone who ever received the legacy card, so matching it
 * is a collision guard, not a security boundary - upgrades only happen on
 * direct in-person sessions, never from gossip (see CardPayload.legacyId).
 * (a handle match used to be required too; handles were removed from the
 * protocol and added nothing anyway - receivers knew the handle as well.)
 */
- (BOOL)legacyUpgradeCandidateIncoming:(FurcardsCoreVerifiedCard *)incoming legacyCardId:(NSString *)legacyCardId __attribute__((swift_name("legacyUpgradeCandidate(incoming:legacyCardId:)")));

/**
 * true when [incoming] should replace [existing] in a store or relay
 * cache. same identity+tier only; higher version wins; the same version
 * never replaces (first-seen wins - two DIFFERENT blobs with equal
 * version means a buggy or malicious signer, and churn helps nobody).
 */
- (BOOL)supersedesIncoming:(FurcardsCoreVerifiedCard *)incoming existing:(FurcardsCoreVerifiedCard *)existing __attribute__((swift_name("supersedes(incoming:existing:)")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PayloadColor")))
@interface FurcardsCorePayloadColor : FurcardsCoreBase
- (instancetype)initWithRed:(double)red green:(double)green blue:(double)blue __attribute__((swift_name("init(red:green:blue:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCorePayloadColorCompanion *companion __attribute__((swift_name("companion")));
- (FurcardsCorePayloadColor *)doCopyRed:(double)red green:(double)green blue:(double)blue __attribute__((swift_name("doCopy(red:green:blue:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) double blue __attribute__((swift_name("blue")));
@property (readonly) double green __attribute__((swift_name("green")));
@property (readonly) double red __attribute__((swift_name("red")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PayloadColor.Companion")))
@interface FurcardsCorePayloadColorCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCorePayloadColorCompanion *shared __attribute__((swift_name("shared")));
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PayloadSocial")))
@interface FurcardsCorePayloadSocial : FurcardsCoreBase
- (instancetype)initWithPlatform:(FurcardsCoreSocialPlatform *)platform handle:(NSString *)handle visibility:(FurcardsCoreSocialVisibility *)visibility __attribute__((swift_name("init(platform:handle:visibility:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCorePayloadSocialCompanion *companion __attribute__((swift_name("companion")));
- (FurcardsCorePayloadSocial *)doCopyPlatform:(FurcardsCoreSocialPlatform *)platform handle:(NSString *)handle visibility:(FurcardsCoreSocialVisibility *)visibility __attribute__((swift_name("doCopy(platform:handle:visibility:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *handle __attribute__((swift_name("handle")));
@property (readonly) FurcardsCoreSocialPlatform *platform __attribute__((swift_name("platform")));
@property (readonly) FurcardsCoreSocialVisibility *visibility __attribute__((swift_name("visibility")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PayloadSocial.Companion")))
@interface FurcardsCorePayloadSocialCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCorePayloadSocialCompanion *shared __attribute__((swift_name("shared")));
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PayloadTheme")))
@interface FurcardsCorePayloadTheme : FurcardsCoreBase
- (instancetype)initWithColors:(NSArray<FurcardsCorePayloadColor *> *)colors pattern:(FurcardsCoreCardPattern *)pattern glowColors:(NSArray<FurcardsCorePayloadColor *> *)glowColors __attribute__((swift_name("init(colors:pattern:glowColors:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) FurcardsCorePayloadThemeCompanion *companion __attribute__((swift_name("companion")));
- (FurcardsCorePayloadTheme *)doCopyColors:(NSArray<FurcardsCorePayloadColor *> *)colors pattern:(FurcardsCoreCardPattern *)pattern glowColors:(NSArray<FurcardsCorePayloadColor *> *)glowColors __attribute__((swift_name("doCopy(colors:pattern:glowColors:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<FurcardsCorePayloadColor *> *colors __attribute__((swift_name("colors")));
@property (readonly) NSArray<FurcardsCorePayloadColor *> *glowColors __attribute__((swift_name("glowColors")));
@property (readonly) FurcardsCoreCardPattern *pattern __attribute__((swift_name("pattern")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PayloadTheme.Companion")))
@interface FurcardsCorePayloadThemeCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCorePayloadThemeCompanion *shared __attribute__((swift_name("shared")));
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * a signed card blob. layout (all integers big-endian):
 *
 * ```
 * offset  size  field
 *      0     1  format version (0x01)
 *      1     4  card version, u32, monotonic per (identity, tier)
 *      5     4  payload length, u32
 *      9    32  ed25519 public key = the owner's identity
 *     41    64  ed25519 signature
 *    105     n  cbor payload (see CardPayload)
 * ```
 *
 * the signature covers bytes [0, 41) ++ [105, 105+n) - i.e. everything except
 * itself.
 *
 * SIGN-EXACT-BYTES RULE: the payload is cbor-encoded exactly once, at seal
 * time, and signed as those bytes. from then on the blob is opaque - it is
 * stored, transmitted, relayed and re-verified as-is, and the payload is
 * parsed ONLY from a blob whose signature already checked out. nothing on
 * either platform may re-encode a payload it didnt author: cbor encoders are
 * not canonical across libraries/versions, so re-encoding would silently
 * invalidate signatures.
 */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SignedCard")))
@interface FurcardsCoreSignedCard : FurcardsCoreBase
@property (class, readonly, getter=companion) FurcardsCoreSignedCardCompanion *companion __attribute__((swift_name("companion")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));

/**
 * checks the signature and only then parses the payload. returns null on
 * any mismatch - a blob that doesnt verify carries no information at all.
 */
- (FurcardsCoreVerifiedCard * _Nullable)verifyCrypto:(id<FurcardsCoreCryptoProvider>)crypto __attribute__((swift_name("verify(crypto:)")));
@property (readonly) FurcardsCoreKotlinByteArray *bytes __attribute__((swift_name("bytes")));
@property (readonly) uint32_t cardVersion __attribute__((swift_name("cardVersion")));
@property (readonly) int32_t formatVersion __attribute__((swift_name("formatVersion")));

/** raw signed payload bytes. parse via [verify] only. */
@property (readonly) FurcardsCoreKotlinByteArray *payloadBytes __attribute__((swift_name("payloadBytes")));
@property (readonly) int32_t payloadLength __attribute__((swift_name("payloadLength")));
@property (readonly) FurcardsCoreKotlinByteArray *publicKey __attribute__((swift_name("publicKey")));

/** stable identity key for dedupe caches and stores: pubkey hex */
@property (readonly) NSString *publicKeyHex __attribute__((swift_name("publicKeyHex")));
@property (readonly) FurcardsCoreKotlinByteArray *signature __attribute__((swift_name("signature")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SignedCard.Companion")))
@interface FurcardsCoreSignedCardCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreSignedCardCompanion *shared __attribute__((swift_name("shared")));

/**
 * wraps received bytes after structural checks only (sizes, format
 * version, length field). signature is NOT checked here - callers must
 * [verify] before trusting or parsing anything. returns null for
 * blobs from a future format version; they are dropped, not relayed
 * (we couldnt enforce caps or blocklists on bytes we cant read).
 */
- (FurcardsCoreSignedCard * _Nullable)fromBytesBytes:(FurcardsCoreKotlinByteArray *)bytes __attribute__((swift_name("fromBytes(bytes:)")));

/**
 * encodes [payload] to cbor ONCE and signs those exact bytes.
 * caps are enforced here so an over-limit card can never be sealed.
 */
- (FurcardsCoreSignedCard *)sealPayload:(FurcardsCoreCardPayload *)payload cardVersion:(uint32_t)cardVersion privateKey:(FurcardsCoreKotlinByteArray *)privateKey crypto:(id<FurcardsCoreCryptoProvider>)crypto __attribute__((swift_name("seal(payload:cardVersion:privateKey:crypto:)")));
@property (readonly) int32_t FORMAT_VERSION __attribute__((swift_name("FORMAT_VERSION")));
@property (readonly) int32_t HEADER_SIZE __attribute__((swift_name("HEADER_SIZE")));
@property (readonly) int32_t MAX_BLOB_BYTES __attribute__((swift_name("MAX_BLOB_BYTES")));
@end


/** a card whose signature checked out; the only source of parsed payloads */
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VerifiedCard")))
@interface FurcardsCoreVerifiedCard : FurcardsCoreBase
- (instancetype)initWithCard:(FurcardsCoreSignedCard *)card payload:(FurcardsCoreCardPayload *)payload __attribute__((swift_name("init(card:payload:)"))) __attribute__((objc_designated_initializer));
@property (readonly) BOOL allowsEncounterCount __attribute__((swift_name("allowsEncounterCount")));
@property (readonly) BOOL allowsRelay __attribute__((swift_name("allowsRelay")));
@property (readonly) FurcardsCoreSignedCard *card __attribute__((swift_name("card")));
@property (readonly) uint32_t cardVersion __attribute__((swift_name("cardVersion")));
@property (readonly) BOOL isFriendTier __attribute__((swift_name("isFriendTier")));
@property (readonly) FurcardsCoreCardPayload *payload __attribute__((swift_name("payload")));
@property (readonly) FurcardsCoreKotlinByteArray *publicKey __attribute__((swift_name("publicKey")));
@property (readonly) NSString *publicKeyHex __attribute__((swift_name("publicKeyHex")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CardPayloadKt")))
@interface FurcardsCoreCardPayloadKt : FurcardsCoreBase

/**
 * the ONE cbor configuration used for every wire structure. definite lengths
 * so identical values always encode to identical bytes (golden vectors);
 * unknown keys ignored so older builds can parse cards from newer ones.
 */
@property (class, readonly) FurcardsCoreKotlinx_serialization_cborCbor *WireCbor __attribute__((swift_name("WireCbor")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CollectionsKt")))
@interface FurcardsCoreCollectionsKt : FurcardsCoreBase

/** cooldowns for logging encounters, same as the ios globals */
@property (class, readonly) int64_t BUMP_COOLDOWN_MS __attribute__((swift_name("BUMP_COOLDOWN_MS")));
@property (class, readonly) int64_t WALK_BY_COOLDOWN_MS __attribute__((swift_name("WALK_BY_COOLDOWN_MS")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IdsKt")))
@interface FurcardsCoreIdsKt : FurcardsCoreBase

/**
 * random uuid string in the exact shape both apps already persist: uppercase
 * hex-and-dashes (ios `UUID().uuidString`, android `UUID.randomUUID().toString().uppercase()`).
 * stored collections are keyed by these, so the format must not drift.
 */
+ (NSString *)randomIdString __attribute__((swift_name("randomIdString()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinByteArray")))
@interface FurcardsCoreKotlinByteArray : FurcardsCoreBase
+ (instancetype)arrayWithSize:(int32_t)size __attribute__((swift_name("init(size:)")));
+ (instancetype)arrayWithSize:(int32_t)size init:(FurcardsCoreByte *(^)(FurcardsCoreInt *))init __attribute__((swift_name("init(size:init:)")));
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (int8_t)getIndex:(int32_t)index __attribute__((swift_name("get(index:)")));
- (FurcardsCoreKotlinByteIterator *)iterator __attribute__((swift_name("iterator()")));
- (void)setIndex:(int32_t)index value:(int8_t)value __attribute__((swift_name("set(index:value:)")));
@property (readonly) int32_t size __attribute__((swift_name("size")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreSerializationStrategy")))
@protocol FurcardsCoreKotlinx_serialization_coreSerializationStrategy
@required
- (void)serializeEncoder:(id<FurcardsCoreKotlinx_serialization_coreEncoder>)encoder value:(id _Nullable)value __attribute__((swift_name("serialize(encoder:value:)")));
@property (readonly) id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor> descriptor __attribute__((swift_name("descriptor")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreDeserializationStrategy")))
@protocol FurcardsCoreKotlinx_serialization_coreDeserializationStrategy
@required
- (id _Nullable)deserializeDecoder:(id<FurcardsCoreKotlinx_serialization_coreDecoder>)decoder __attribute__((swift_name("deserialize(decoder:)")));
@property (readonly) id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor> descriptor __attribute__((swift_name("descriptor")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreKSerializer")))
@protocol FurcardsCoreKotlinx_serialization_coreKSerializer <FurcardsCoreKotlinx_serialization_coreSerializationStrategy, FurcardsCoreKotlinx_serialization_coreDeserializationStrategy>
@required
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinEnumCompanion")))
@interface FurcardsCoreKotlinEnumCompanion : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreKotlinEnumCompanion *shared __attribute__((swift_name("shared")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinArray")))
@interface FurcardsCoreKotlinArray<T> : FurcardsCoreBase
+ (instancetype)arrayWithSize:(int32_t)size init:(T _Nullable (^)(FurcardsCoreInt *))init __attribute__((swift_name("init(size:init:)")));
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (T _Nullable)getIndex:(int32_t)index __attribute__((swift_name("get(index:)")));
- (id<FurcardsCoreKotlinIterator>)iterator __attribute__((swift_name("iterator()")));
- (void)setIndex:(int32_t)index value:(T _Nullable)value __attribute__((swift_name("set(index:value:)")));
@property (readonly) int32_t size __attribute__((swift_name("size")));
@end

__attribute__((swift_name("KotlinSequence")))
@protocol FurcardsCoreKotlinSequence
@required
- (id<FurcardsCoreKotlinIterator>)iterator __attribute__((swift_name("iterator()")));
@end

__attribute__((swift_name("Kotlinx_coroutines_coreCoroutineScope")))
@protocol FurcardsCoreKotlinx_coroutines_coreCoroutineScope
@required
@property (readonly) id<FurcardsCoreKotlinCoroutineContext> coroutineContext __attribute__((swift_name("coroutineContext")));
@end

__attribute__((swift_name("KotlinRuntimeException")))
@interface FurcardsCoreKotlinRuntimeException : FurcardsCoreKotlinException
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(FurcardsCoreKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(FurcardsCoreKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));
@end

__attribute__((swift_name("KotlinIllegalStateException")))
@interface FurcardsCoreKotlinIllegalStateException : FurcardsCoreKotlinRuntimeException
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(FurcardsCoreKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(FurcardsCoreKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.4")
*/
__attribute__((swift_name("KotlinCancellationException")))
@interface FurcardsCoreKotlinCancellationException : FurcardsCoreKotlinIllegalStateException
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(FurcardsCoreKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(FurcardsCoreKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));
@end

__attribute__((swift_name("Kotlinx_coroutines_coreReceiveChannel")))
@protocol FurcardsCoreKotlinx_coroutines_coreReceiveChannel
@required
- (void)cancelCause:(FurcardsCoreKotlinCancellationException * _Nullable)cause __attribute__((swift_name("cancel(cause:)")));
- (id<FurcardsCoreKotlinx_coroutines_coreChannelIterator>)iterator __attribute__((swift_name("iterator()")));
- (id _Nullable)poll __attribute__((swift_name("poll()"))) __attribute__((unavailable("Deprecated in the favour of 'tryReceive'. Please note that the provided replacement does not rethrow channel's close cause as 'poll' did, for the precise replacement please refer to the 'poll' documentation")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)receiveWithCompletionHandler:(void (^)(id _Nullable_result, NSError * _Nullable))completionHandler __attribute__((swift_name("receive(completionHandler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)receiveCatchingWithCompletionHandler:(void (^)(id _Nullable_result, NSError * _Nullable))completionHandler __attribute__((swift_name("receiveCatching(completionHandler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)receiveOrNullWithCompletionHandler:(void (^)(id _Nullable_result, NSError * _Nullable))completionHandler __attribute__((swift_name("receiveOrNull(completionHandler:)"))) __attribute__((unavailable("Deprecated in favor of 'receiveCatching'. Please note that the provided replacement does not rethrow channel's close cause as 'receiveOrNull' did, for the detailed replacement please refer to the 'receiveOrNull' documentation")));
- (id _Nullable)tryReceive __attribute__((swift_name("tryReceive()")));

/**
 * @note annotations
 *   kotlinx.coroutines.DelicateCoroutinesApi
*/
@property (readonly) BOOL isClosedForReceive __attribute__((swift_name("isClosedForReceive")));

/**
 * @note annotations
 *   kotlinx.coroutines.ExperimentalCoroutinesApi
*/
@property (readonly) BOOL isEmpty __attribute__((swift_name("isEmpty")));
@property (readonly) id<FurcardsCoreKotlinx_coroutines_coreSelectClause1> onReceive __attribute__((swift_name("onReceive")));
@property (readonly) id<FurcardsCoreKotlinx_coroutines_coreSelectClause1> onReceiveCatching __attribute__((swift_name("onReceiveCatching")));
@property (readonly) id<FurcardsCoreKotlinx_coroutines_coreSelectClause1> onReceiveOrNull __attribute__((swift_name("onReceiveOrNull"))) __attribute__((unavailable("Deprecated in favor of onReceiveCatching extension")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreSerialFormat")))
@protocol FurcardsCoreKotlinx_serialization_coreSerialFormat
@required
@property (readonly) FurcardsCoreKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreBinaryFormat")))
@protocol FurcardsCoreKotlinx_serialization_coreBinaryFormat <FurcardsCoreKotlinx_serialization_coreSerialFormat>
@required
- (id _Nullable)decodeFromByteArrayDeserializer:(id<FurcardsCoreKotlinx_serialization_coreDeserializationStrategy>)deserializer bytes:(FurcardsCoreKotlinByteArray *)bytes __attribute__((swift_name("decodeFromByteArray(deserializer:bytes:)")));
- (FurcardsCoreKotlinByteArray *)encodeToByteArraySerializer:(id<FurcardsCoreKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeToByteArray(serializer:value:)")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
__attribute__((swift_name("Kotlinx_serialization_cborCbor")))
@interface FurcardsCoreKotlinx_serialization_cborCbor : FurcardsCoreBase <FurcardsCoreKotlinx_serialization_coreBinaryFormat>
@property (class, readonly, getter=companion) FurcardsCoreKotlinx_serialization_cborCborDefault *companion __attribute__((swift_name("companion")));
- (id _Nullable)decodeFromByteArrayDeserializer:(id<FurcardsCoreKotlinx_serialization_coreDeserializationStrategy>)deserializer bytes:(FurcardsCoreKotlinByteArray *)bytes __attribute__((swift_name("decodeFromByteArray(deserializer:bytes:)")));
- (FurcardsCoreKotlinByteArray *)encodeToByteArraySerializer:(id<FurcardsCoreKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeToByteArray(serializer:value:)")));
@property (readonly) FurcardsCoreKotlinx_serialization_cborCborConfiguration *configuration __attribute__((swift_name("configuration")));
@property (readonly) FurcardsCoreKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((swift_name("KotlinIterator")))
@protocol FurcardsCoreKotlinIterator
@required
- (BOOL)hasNext __attribute__((swift_name("hasNext()")));
- (id _Nullable)next __attribute__((swift_name("next()")));
@end

__attribute__((swift_name("KotlinByteIterator")))
@interface FurcardsCoreKotlinByteIterator : FurcardsCoreBase <FurcardsCoreKotlinIterator>
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (FurcardsCoreByte *)next __attribute__((swift_name("next()")));
- (int8_t)nextByte __attribute__((swift_name("nextByte()")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreEncoder")))
@protocol FurcardsCoreKotlinx_serialization_coreEncoder
@required
- (id<FurcardsCoreKotlinx_serialization_coreCompositeEncoder>)beginCollectionDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor collectionSize:(int32_t)collectionSize __attribute__((swift_name("beginCollection(descriptor:collectionSize:)")));
- (id<FurcardsCoreKotlinx_serialization_coreCompositeEncoder>)beginStructureDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("beginStructure(descriptor:)")));
- (void)encodeBooleanValue:(BOOL)value __attribute__((swift_name("encodeBoolean(value:)")));
- (void)encodeByteValue:(int8_t)value __attribute__((swift_name("encodeByte(value:)")));
- (void)encodeCharValue:(unichar)value __attribute__((swift_name("encodeChar(value:)")));
- (void)encodeDoubleValue:(double)value __attribute__((swift_name("encodeDouble(value:)")));
- (void)encodeEnumEnumDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)enumDescriptor index:(int32_t)index __attribute__((swift_name("encodeEnum(enumDescriptor:index:)")));
- (void)encodeFloatValue:(float)value __attribute__((swift_name("encodeFloat(value:)")));
- (id<FurcardsCoreKotlinx_serialization_coreEncoder>)encodeInlineDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("encodeInline(descriptor:)")));
- (void)encodeIntValue:(int32_t)value __attribute__((swift_name("encodeInt(value:)")));
- (void)encodeLongValue:(int64_t)value __attribute__((swift_name("encodeLong(value:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)encodeNotNullMark __attribute__((swift_name("encodeNotNullMark()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)encodeNull __attribute__((swift_name("encodeNull()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)encodeNullableSerializableValueSerializer:(id<FurcardsCoreKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeNullableSerializableValue(serializer:value:)")));
- (void)encodeSerializableValueSerializer:(id<FurcardsCoreKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeSerializableValue(serializer:value:)")));
- (void)encodeShortValue:(int16_t)value __attribute__((swift_name("encodeShort(value:)")));
- (void)encodeStringValue:(NSString *)value __attribute__((swift_name("encodeString(value:)")));
@property (readonly) FurcardsCoreKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreSerialDescriptor")))
@protocol FurcardsCoreKotlinx_serialization_coreSerialDescriptor
@required
- (NSArray<id<FurcardsCoreKotlinAnnotation>> *)getElementAnnotationsIndex:(int32_t)index __attribute__((swift_name("getElementAnnotations(index:)")));
- (id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)getElementDescriptorIndex:(int32_t)index __attribute__((swift_name("getElementDescriptor(index:)")));
- (int32_t)getElementIndexName:(NSString *)name __attribute__((swift_name("getElementIndex(name:)")));
- (NSString *)getElementNameIndex:(int32_t)index __attribute__((swift_name("getElementName(index:)")));
- (BOOL)isElementOptionalIndex:(int32_t)index __attribute__((swift_name("isElementOptional(index:)")));
@property (readonly) NSArray<id<FurcardsCoreKotlinAnnotation>> *annotations __attribute__((swift_name("annotations")));
@property (readonly) int32_t elementsCount __attribute__((swift_name("elementsCount")));
@property (readonly) BOOL isInline __attribute__((swift_name("isInline")));
@property (readonly) BOOL isNullable __attribute__((swift_name("isNullable")));
@property (readonly) FurcardsCoreKotlinx_serialization_coreSerialKind *kind __attribute__((swift_name("kind")));
@property (readonly) NSString *serialName __attribute__((swift_name("serialName")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreDecoder")))
@protocol FurcardsCoreKotlinx_serialization_coreDecoder
@required
- (id<FurcardsCoreKotlinx_serialization_coreCompositeDecoder>)beginStructureDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("beginStructure(descriptor:)")));
- (BOOL)decodeBoolean __attribute__((swift_name("decodeBoolean()")));
- (int8_t)decodeByte __attribute__((swift_name("decodeByte()")));
- (unichar)decodeChar __attribute__((swift_name("decodeChar()")));
- (double)decodeDouble __attribute__((swift_name("decodeDouble()")));
- (int32_t)decodeEnumEnumDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)enumDescriptor __attribute__((swift_name("decodeEnum(enumDescriptor:)")));
- (float)decodeFloat __attribute__((swift_name("decodeFloat()")));
- (id<FurcardsCoreKotlinx_serialization_coreDecoder>)decodeInlineDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("decodeInline(descriptor:)")));
- (int32_t)decodeInt __attribute__((swift_name("decodeInt()")));
- (int64_t)decodeLong __attribute__((swift_name("decodeLong()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (BOOL)decodeNotNullMark __attribute__((swift_name("decodeNotNullMark()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (FurcardsCoreKotlinNothing * _Nullable)decodeNull __attribute__((swift_name("decodeNull()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id _Nullable)decodeNullableSerializableValueDeserializer:(id<FurcardsCoreKotlinx_serialization_coreDeserializationStrategy>)deserializer __attribute__((swift_name("decodeNullableSerializableValue(deserializer:)")));
- (id _Nullable)decodeSerializableValueDeserializer:(id<FurcardsCoreKotlinx_serialization_coreDeserializationStrategy>)deserializer __attribute__((swift_name("decodeSerializableValue(deserializer:)")));
- (int16_t)decodeShort __attribute__((swift_name("decodeShort()")));
- (NSString *)decodeString __attribute__((swift_name("decodeString()")));
@property (readonly) FurcardsCoreKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.3")
*/
__attribute__((swift_name("KotlinCoroutineContext")))
@protocol FurcardsCoreKotlinCoroutineContext
@required
- (id _Nullable)foldInitial:(id _Nullable)initial operation:(id _Nullable (^)(id _Nullable, id<FurcardsCoreKotlinCoroutineContextElement>))operation __attribute__((swift_name("fold(initial:operation:)")));
- (id<FurcardsCoreKotlinCoroutineContextElement> _Nullable)getKey:(id<FurcardsCoreKotlinCoroutineContextKey>)key __attribute__((swift_name("get(key:)")));
- (id<FurcardsCoreKotlinCoroutineContext>)minusKeyKey:(id<FurcardsCoreKotlinCoroutineContextKey>)key __attribute__((swift_name("minusKey(key:)")));
- (id<FurcardsCoreKotlinCoroutineContext>)plusContext:(id<FurcardsCoreKotlinCoroutineContext>)context __attribute__((swift_name("plus(context:)")));
@end

__attribute__((swift_name("Kotlinx_coroutines_coreChannelIterator")))
@protocol FurcardsCoreKotlinx_coroutines_coreChannelIterator
@required

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)hasNextWithCompletionHandler:(void (^)(FurcardsCoreBoolean * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("hasNext(completionHandler:)")));
- (id _Nullable)next __attribute__((swift_name("next()")));
@end


/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
__attribute__((swift_name("Kotlinx_coroutines_coreSelectClause")))
@protocol FurcardsCoreKotlinx_coroutines_coreSelectClause
@required
@property (readonly) id clauseObject __attribute__((swift_name("clauseObject")));
@property (readonly) FurcardsCoreKotlinUnit *(^(^ _Nullable onCancellationConstructor)(id<FurcardsCoreKotlinx_coroutines_coreSelectInstance> select, id _Nullable param, id _Nullable internalResult))(FurcardsCoreKotlinThrowable *, id _Nullable, id<FurcardsCoreKotlinCoroutineContext>) __attribute__((swift_name("onCancellationConstructor")));
@property (readonly) id _Nullable (^processResFunc)(id clauseObject, id _Nullable param, id _Nullable clauseResult) __attribute__((swift_name("processResFunc")));
@property (readonly) void (^regFunc)(id clauseObject, id<FurcardsCoreKotlinx_coroutines_coreSelectInstance> select, id _Nullable param) __attribute__((swift_name("regFunc")));
@end

__attribute__((swift_name("Kotlinx_coroutines_coreSelectClause1")))
@protocol FurcardsCoreKotlinx_coroutines_coreSelectClause1 <FurcardsCoreKotlinx_coroutines_coreSelectClause>
@required
@end

__attribute__((swift_name("Kotlinx_serialization_coreSerializersModule")))
@interface FurcardsCoreKotlinx_serialization_coreSerializersModule : FurcardsCoreBase

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)dumpToCollector:(id<FurcardsCoreKotlinx_serialization_coreSerializersModuleCollector>)collector __attribute__((swift_name("dumpTo(collector:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id<FurcardsCoreKotlinx_serialization_coreKSerializer> _Nullable)getContextualKClass:(id<FurcardsCoreKotlinKClass>)kClass typeArgumentsSerializers:(NSArray<id<FurcardsCoreKotlinx_serialization_coreKSerializer>> *)typeArgumentsSerializers __attribute__((swift_name("getContextual(kClass:typeArgumentsSerializers:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id<FurcardsCoreKotlinx_serialization_coreSerializationStrategy> _Nullable)getPolymorphicBaseClass:(id<FurcardsCoreKotlinKClass>)baseClass value:(id)value __attribute__((swift_name("getPolymorphic(baseClass:value:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id<FurcardsCoreKotlinx_serialization_coreDeserializationStrategy> _Nullable)getPolymorphicBaseClass:(id<FurcardsCoreKotlinKClass>)baseClass serializedClassName:(NSString * _Nullable)serializedClassName __attribute__((swift_name("getPolymorphic(baseClass:serializedClassName:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Kotlinx_serialization_cborCbor.Default")))
@interface FurcardsCoreKotlinx_serialization_cborCborDefault : FurcardsCoreKotlinx_serialization_cborCbor
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)default_ __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreKotlinx_serialization_cborCborDefault *shared __attribute__((swift_name("shared")));
@property (readonly) FurcardsCoreKotlinx_serialization_cborCbor *CoseCompliant __attribute__((swift_name("CoseCompliant")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Kotlinx_serialization_cborCborConfiguration")))
@interface FurcardsCoreKotlinx_serialization_cborCborConfiguration : FurcardsCoreBase
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL alwaysUseByteString __attribute__((swift_name("alwaysUseByteString")));
@property (readonly) BOOL encodeDefaults __attribute__((swift_name("encodeDefaults")));
@property (readonly) BOOL encodeKeyTags __attribute__((swift_name("encodeKeyTags")));
@property (readonly) BOOL encodeObjectTags __attribute__((swift_name("encodeObjectTags")));
@property (readonly) BOOL encodeValueTags __attribute__((swift_name("encodeValueTags")));
@property (readonly) BOOL ignoreUnknownKeys __attribute__((swift_name("ignoreUnknownKeys")));
@property (readonly) BOOL preferCborLabelsOverNames __attribute__((swift_name("preferCborLabelsOverNames")));
@property (readonly) BOOL useDefiniteLengthEncoding __attribute__((swift_name("useDefiniteLengthEncoding")));
@property (readonly) BOOL verifyKeyTags __attribute__((swift_name("verifyKeyTags")));
@property (readonly) BOOL verifyObjectTags __attribute__((swift_name("verifyObjectTags")));
@property (readonly) BOOL verifyValueTags __attribute__((swift_name("verifyValueTags")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreCompositeEncoder")))
@protocol FurcardsCoreKotlinx_serialization_coreCompositeEncoder
@required
- (void)encodeBooleanElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(BOOL)value __attribute__((swift_name("encodeBooleanElement(descriptor:index:value:)")));
- (void)encodeByteElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(int8_t)value __attribute__((swift_name("encodeByteElement(descriptor:index:value:)")));
- (void)encodeCharElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(unichar)value __attribute__((swift_name("encodeCharElement(descriptor:index:value:)")));
- (void)encodeDoubleElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(double)value __attribute__((swift_name("encodeDoubleElement(descriptor:index:value:)")));
- (void)encodeFloatElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(float)value __attribute__((swift_name("encodeFloatElement(descriptor:index:value:)")));
- (id<FurcardsCoreKotlinx_serialization_coreEncoder>)encodeInlineElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("encodeInlineElement(descriptor:index:)")));
- (void)encodeIntElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(int32_t)value __attribute__((swift_name("encodeIntElement(descriptor:index:value:)")));
- (void)encodeLongElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(int64_t)value __attribute__((swift_name("encodeLongElement(descriptor:index:value:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)encodeNullableSerializableElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index serializer:(id<FurcardsCoreKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeNullableSerializableElement(descriptor:index:serializer:value:)")));
- (void)encodeSerializableElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index serializer:(id<FurcardsCoreKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeSerializableElement(descriptor:index:serializer:value:)")));
- (void)encodeShortElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(int16_t)value __attribute__((swift_name("encodeShortElement(descriptor:index:value:)")));
- (void)encodeStringElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(NSString *)value __attribute__((swift_name("encodeStringElement(descriptor:index:value:)")));
- (void)endStructureDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("endStructure(descriptor:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (BOOL)shouldEncodeElementDefaultDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("shouldEncodeElementDefault(descriptor:index:)")));
@property (readonly) FurcardsCoreKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((swift_name("KotlinAnnotation")))
@protocol FurcardsCoreKotlinAnnotation
@required
@end

__attribute__((swift_name("Kotlinx_serialization_coreSerialKind")))
@interface FurcardsCoreKotlinx_serialization_coreSerialKind : FurcardsCoreBase
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreCompositeDecoder")))
@protocol FurcardsCoreKotlinx_serialization_coreCompositeDecoder
@required
- (BOOL)decodeBooleanElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeBooleanElement(descriptor:index:)")));
- (int8_t)decodeByteElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeByteElement(descriptor:index:)")));
- (unichar)decodeCharElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeCharElement(descriptor:index:)")));
- (int32_t)decodeCollectionSizeDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("decodeCollectionSize(descriptor:)")));
- (double)decodeDoubleElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeDoubleElement(descriptor:index:)")));
- (int32_t)decodeElementIndexDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("decodeElementIndex(descriptor:)")));
- (float)decodeFloatElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeFloatElement(descriptor:index:)")));
- (id<FurcardsCoreKotlinx_serialization_coreDecoder>)decodeInlineElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeInlineElement(descriptor:index:)")));
- (int32_t)decodeIntElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeIntElement(descriptor:index:)")));
- (int64_t)decodeLongElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeLongElement(descriptor:index:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id _Nullable)decodeNullableSerializableElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index deserializer:(id<FurcardsCoreKotlinx_serialization_coreDeserializationStrategy>)deserializer previousValue:(id _Nullable)previousValue __attribute__((swift_name("decodeNullableSerializableElement(descriptor:index:deserializer:previousValue:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (BOOL)decodeSequentially __attribute__((swift_name("decodeSequentially()")));
- (id _Nullable)decodeSerializableElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index deserializer:(id<FurcardsCoreKotlinx_serialization_coreDeserializationStrategy>)deserializer previousValue:(id _Nullable)previousValue __attribute__((swift_name("decodeSerializableElement(descriptor:index:deserializer:previousValue:)")));
- (int16_t)decodeShortElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeShortElement(descriptor:index:)")));
- (NSString *)decodeStringElementDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeStringElement(descriptor:index:)")));
- (void)endStructureDescriptor:(id<FurcardsCoreKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("endStructure(descriptor:)")));
@property (readonly) FurcardsCoreKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinNothing")))
@interface FurcardsCoreKotlinNothing : FurcardsCoreBase
@end

__attribute__((swift_name("KotlinCoroutineContextElement")))
@protocol FurcardsCoreKotlinCoroutineContextElement <FurcardsCoreKotlinCoroutineContext>
@required
@property (readonly) id<FurcardsCoreKotlinCoroutineContextKey> key __attribute__((swift_name("key")));
@end

__attribute__((swift_name("KotlinCoroutineContextKey")))
@protocol FurcardsCoreKotlinCoroutineContextKey
@required
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinUnit")))
@interface FurcardsCoreKotlinUnit : FurcardsCoreBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)unit __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) FurcardsCoreKotlinUnit *shared __attribute__((swift_name("shared")));
- (NSString *)description __attribute__((swift_name("description()")));
@end


/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
__attribute__((swift_name("Kotlinx_coroutines_coreSelectInstance")))
@protocol FurcardsCoreKotlinx_coroutines_coreSelectInstance
@required
- (void)disposeOnCompletionDisposableHandle:(id<FurcardsCoreKotlinx_coroutines_coreDisposableHandle>)disposableHandle __attribute__((swift_name("disposeOnCompletion(disposableHandle:)")));
- (void)selectInRegistrationPhaseInternalResult:(id _Nullable)internalResult __attribute__((swift_name("selectInRegistrationPhase(internalResult:)")));
- (BOOL)trySelectClauseObject:(id)clauseObject result:(id _Nullable)result __attribute__((swift_name("trySelect(clauseObject:result:)")));
@property (readonly) id<FurcardsCoreKotlinCoroutineContext> context __attribute__((swift_name("context")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
__attribute__((swift_name("Kotlinx_serialization_coreSerializersModuleCollector")))
@protocol FurcardsCoreKotlinx_serialization_coreSerializersModuleCollector
@required
- (void)contextualKClass:(id<FurcardsCoreKotlinKClass>)kClass provider:(id<FurcardsCoreKotlinx_serialization_coreKSerializer> (^)(NSArray<id<FurcardsCoreKotlinx_serialization_coreKSerializer>> *typeArgumentsSerializers))provider __attribute__((swift_name("contextual(kClass:provider:)")));
- (void)contextualKClass:(id<FurcardsCoreKotlinKClass>)kClass serializer:(id<FurcardsCoreKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("contextual(kClass:serializer:)")));
- (void)polymorphicBaseClass:(id<FurcardsCoreKotlinKClass>)baseClass actualClass:(id<FurcardsCoreKotlinKClass>)actualClass actualSerializer:(id<FurcardsCoreKotlinx_serialization_coreKSerializer>)actualSerializer __attribute__((swift_name("polymorphic(baseClass:actualClass:actualSerializer:)")));
- (void)polymorphicDefaultBaseClass:(id<FurcardsCoreKotlinKClass>)baseClass defaultDeserializerProvider:(id<FurcardsCoreKotlinx_serialization_coreDeserializationStrategy> _Nullable (^)(NSString * _Nullable className))defaultDeserializerProvider __attribute__((swift_name("polymorphicDefault(baseClass:defaultDeserializerProvider:)"))) __attribute__((deprecated("Deprecated in favor of function with more precise name: polymorphicDefaultDeserializer")));
- (void)polymorphicDefaultDeserializerBaseClass:(id<FurcardsCoreKotlinKClass>)baseClass defaultDeserializerProvider:(id<FurcardsCoreKotlinx_serialization_coreDeserializationStrategy> _Nullable (^)(NSString * _Nullable className))defaultDeserializerProvider __attribute__((swift_name("polymorphicDefaultDeserializer(baseClass:defaultDeserializerProvider:)")));
- (void)polymorphicDefaultSerializerBaseClass:(id<FurcardsCoreKotlinKClass>)baseClass defaultSerializerProvider:(id<FurcardsCoreKotlinx_serialization_coreSerializationStrategy> _Nullable (^)(id value))defaultSerializerProvider __attribute__((swift_name("polymorphicDefaultSerializer(baseClass:defaultSerializerProvider:)")));
@end

__attribute__((swift_name("KotlinKDeclarationContainer")))
@protocol FurcardsCoreKotlinKDeclarationContainer
@required
@end

__attribute__((swift_name("KotlinKAnnotatedElement")))
@protocol FurcardsCoreKotlinKAnnotatedElement
@required
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.1")
*/
__attribute__((swift_name("KotlinKClassifier")))
@protocol FurcardsCoreKotlinKClassifier
@required
@end

__attribute__((swift_name("KotlinKClass")))
@protocol FurcardsCoreKotlinKClass <FurcardsCoreKotlinKDeclarationContainer, FurcardsCoreKotlinKAnnotatedElement, FurcardsCoreKotlinKClassifier>
@required

/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.1")
*/
- (BOOL)isInstanceValue:(id _Nullable)value __attribute__((swift_name("isInstance(value:)")));
@property (readonly) NSString * _Nullable qualifiedName __attribute__((swift_name("qualifiedName")));
@property (readonly) NSString * _Nullable simpleName __attribute__((swift_name("simpleName")));
@end

__attribute__((swift_name("Kotlinx_coroutines_coreDisposableHandle")))
@protocol FurcardsCoreKotlinx_coroutines_coreDisposableHandle
@required
- (void)dispose __attribute__((swift_name("dispose()")));
@end

#pragma pop_macro("_Nullable_result")
#pragma clang diagnostic pop
NS_ASSUME_NONNULL_END
