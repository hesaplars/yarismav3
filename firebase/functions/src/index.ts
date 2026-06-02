import { initializeApp } from 'firebase-admin/app';
import { FieldValue, getFirestore } from 'firebase-admin/firestore';
import { getDatabase, ServerValue } from 'firebase-admin/database';
import { HttpsError, onCall } from 'firebase-functions/v2/https';
import { setGlobalOptions } from 'firebase-functions/v2/options';

initializeApp({
  databaseURL: 'https://yarisma-live-e6281-default-rtdb.europe-west1.firebasedatabase.app',
});

setGlobalOptions({ region: 'europe-west1', invoker: 'public' });

const firestore = getFirestore();
const realtimeDb = getDatabase();

const DEFAULT_GUEST_AVATAR = '🍄';
const DEFAULT_LIMITS = {
  friend_request: { label: 'Arkadas istegi', freeLimit: 5, ygCost: 20, extraAmount: 1, hardLimit: 18 },
  direct_message: { label: 'Ozel mesaj', freeLimit: 45, ygCost: 25, extraAmount: 10, hardLimit: 180 },
  public_chat: { label: 'Genel sohbet', freeLimit: 35, ygCost: 25, extraAmount: 10, hardLimit: 160 },
  room_chat: { label: 'Oda sohbeti', freeLimit: 30, ygCost: 20, extraAmount: 10, hardLimit: 140 },
  custom_quiz_comment: { label: 'Yorum', freeLimit: 5, ygCost: 20, extraAmount: 1, hardLimit: 22 },
  custom_quiz_create: { label: 'Oyun olusturma', freeLimit: 1, ygCost: 120, extraAmount: 1, hardLimit: 5 },
  room_create: { label: 'Oda kurma', freeLimit: 3, ygCost: 80, extraAmount: 1, hardLimit: 12 },
};

const DEFAULT_STORE_ITEMS = [
  { id: 'frame_gold', name: 'Altin Cerceve', type: 'avatarFrame', price: 120, active: true },
  { id: 'cover_sunrise', name: 'Gun Dogumu Kapagi', type: 'cover', price: 90, active: true },
  { id: 'badge_founder', name: 'Kurucu Rozeti', type: 'badge', price: 180, active: true },
  { id: 'avatar_badge_star', name: 'Yildiz Avatar Rozeti', type: 'avatarBadge', price: 75, active: true },
];

function requireAuth(request: { auth?: { uid: string; token?: Record<string, unknown> } }) {
  if (!request.auth?.uid) throw new HttpsError('unauthenticated', 'Giris gerekli.');
  return request.auth;
}

function cleanName(value: unknown) {
  const name = String(value ?? '').trim().replace(/\s+/g, ' ');
  if (name.length < 2) throw new HttpsError('invalid-argument', 'Kullanici adi cok kisa.');
  if (name.length > 18) throw new HttpsError('invalid-argument', 'Kullanici adi cok uzun.');
  return name;
}

function assertTerms(value: unknown) {
  if (value !== true) throw new HttpsError('failed-precondition', 'Kullanim sartlari kabul edilmeli.');
}

async function profilePayload(uid: string) {
  const snap = await firestore.collection('users').doc(uid).get();
  if (!snap.exists) return null;
  return { uid, ...snap.data() };
}

export const bootstrapProfile = onCall({ cors: true }, async (request) => {
  const auth = requireAuth(request);
  const existing = await profilePayload(auth.uid);
  if (existing) return existing;

  const isGuest = !auth.token?.email;
  const name = isGuest ? 'Misafir Oyuncu' : String(auth.token?.name ?? auth.token?.email ?? 'Oyuncu');
  const payload = {
    uid: auth.uid,
    name,
    avatar: isGuest ? DEFAULT_GUEST_AVATAR : DEFAULT_GUEST_AVATAR,
    photoUrl: String(auth.token?.picture ?? ''),
    isGuest,
    acceptedTerms: false,
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  };

  await firestore.collection('users').doc(auth.uid).set(payload, { merge: true });
  await realtimeDb.ref(`profiles/${auth.uid}`).update({ ...payload, updatedAt: ServerValue.TIMESTAMP });
  return payload;
});

export const completeGuestAccess = onCall({ cors: true }, async (request) => {
  const auth = requireAuth(request);
  assertTerms(request.data?.acceptedTerms);
  const name = cleanName(request.data?.name);

  const payload = {
    uid: auth.uid,
    name,
    avatar: DEFAULT_GUEST_AVATAR,
    photoUrl: '',
    isGuest: true,
    acceptedTerms: true,
    termsAcceptedAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  };

  await firestore.collection('users').doc(auth.uid).set(payload, { merge: true });
  await realtimeDb.ref(`profiles/${auth.uid}`).update({ ...payload, updatedAt: ServerValue.TIMESTAMP });
  return payload;
});

export const completeGoogleAccess = onCall({ cors: true }, async (request) => {
  const auth = requireAuth(request);
  assertTerms(request.data?.acceptedTerms);

  const name = cleanName(auth.token?.name ?? auth.token?.email ?? 'Oyuncu');
  const payload = {
    uid: auth.uid,
    name,
    avatar: DEFAULT_GUEST_AVATAR,
    photoUrl: String(auth.token?.picture ?? ''),
    isGuest: false,
    acceptedTerms: true,
    termsAcceptedAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  };

  await firestore.collection('users').doc(auth.uid).set(payload, { merge: true });
  await realtimeDb.ref(`profiles/${auth.uid}`).update({ ...payload, updatedAt: ServerValue.TIMESTAMP });
  await grantRewardOnce(auth.uid, 'google-link', 30, 'googleLink');
  return payload;
});

export const getEconomyState = onCall({ cors: true }, async (request) => {
  const auth = requireAuth(request);
  const [walletSnap, inventorySnap, storeSnap] = await Promise.all([
    firestore.collection('wallets').doc(auth.uid).get(),
    firestore.collection('userInventory').doc(auth.uid).collection('items').limit(500).get(),
    firestore.collection('storeItems').where('active', '==', true).limit(300).get(),
  ]);

  const dbItems = storeSnap.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
  const itemIds = new Set(dbItems.map((item) => item.id));
  const storeItems = [
    ...dbItems,
    ...DEFAULT_STORE_ITEMS.filter((item) => !itemIds.has(item.id)),
  ];

  return {
    wallet: walletSnap.exists ? walletSnap.data() : { balance: 0, lifetimeEarned: 0, lifetimeSpent: 0 },
    inventory: inventorySnap.docs.map((doc) => ({ id: doc.id, ...doc.data() })),
    storeItems,
    limits: DEFAULT_LIMITS,
  };
});

export const purchaseStoreItem = onCall({ cors: true }, async (request) => {
  const auth = requireAuth(request);
  const itemId = String(request.data?.itemId ?? '');
  const items = DEFAULT_STORE_ITEMS;
  const item = items.find((candidate) => candidate.id === itemId);
  if (!item) throw new HttpsError('not-found', 'Urun bulunamadi.');

  await changeWallet(auth.uid, -Number(item.price), 'storePurchase', { itemId });
  await firestore.collection('userInventory').doc(auth.uid).collection('items').doc(itemId).set({
    ...item,
    ownedAt: FieldValue.serverTimestamp(),
  }, { merge: true });

  return { ok: true };
});

export const equipCosmetic = onCall({ cors: true }, async (request) => {
  const auth = requireAuth(request);
  const itemId = String(request.data?.itemId ?? '');
  const slot = String(request.data?.slot ?? '');
  if (!itemId || !slot) throw new HttpsError('invalid-argument', 'Eksik ekipman bilgisi.');

  const owned = await firestore.collection('userInventory').doc(auth.uid).collection('items').doc(itemId).get();
  if (!owned.exists) throw new HttpsError('permission-denied', 'Bu esyaya sahip degilsin.');

  await firestore.collection('users').doc(auth.uid).set({ equipped: { [slot]: itemId }, updatedAt: FieldValue.serverTimestamp() }, { merge: true });
  await realtimeDb.ref(`profiles/${auth.uid}/equipped/${slot}`).set(itemId);
  return { ok: true };
});

export const spendForLimit = onCall({ cors: true }, async (request) => {
  const auth = requireAuth(request);
  const actionKey = String(request.data?.actionKey ?? '');
  const limit = DEFAULT_LIMITS[actionKey as keyof typeof DEFAULT_LIMITS];
  if (!limit) throw new HttpsError('invalid-argument', 'Limit bulunamadi.');

  await changeWallet(auth.uid, -limit.ygCost, 'limitUnlock', { actionKey });
  await firestore.collection('limitUnlocks').doc(`${auth.uid}_${actionKey}`).set({
    uid: auth.uid,
    actionKey,
    extraAmount: FieldValue.increment(limit.extraAmount),
    updatedAt: FieldValue.serverTimestamp(),
  }, { merge: true });
  return { ok: true };
});

async function grantRewardOnce(uid: string, claimId: string, amount: number, reason: string) {
  const claimRef = firestore.collection('rewardClaims').doc(uid).collection('claims').doc(claimId);
  await firestore.runTransaction(async (tx) => {
    const claim = await tx.get(claimRef);
    if (claim.exists) return;
    tx.set(claimRef, { uid, claimId, amount, reason, createdAt: FieldValue.serverTimestamp() });
    tx.set(firestore.collection('wallets').doc(uid), {
      balance: FieldValue.increment(amount),
      lifetimeEarned: FieldValue.increment(amount),
      updatedAt: FieldValue.serverTimestamp(),
    }, { merge: true });
  });
}

async function changeWallet(uid: string, amount: number, reason: string, meta: Record<string, unknown>) {
  const walletRef = firestore.collection('wallets').doc(uid);
  const ledgerRef = walletRef.collection('ledger').doc();

  await firestore.runTransaction(async (tx) => {
    const wallet = await tx.get(walletRef);
    const balance = Number(wallet.data()?.balance ?? 0);
    if (balance + amount < 0) throw new HttpsError('failed-precondition', 'YG bakiyesi yetersiz.');

    tx.set(walletRef, {
      balance: FieldValue.increment(amount),
      lifetimeEarned: amount > 0 ? FieldValue.increment(amount) : FieldValue.increment(0),
      lifetimeSpent: amount < 0 ? FieldValue.increment(Math.abs(amount)) : FieldValue.increment(0),
      updatedAt: FieldValue.serverTimestamp(),
    }, { merge: true });
    tx.set(ledgerRef, { uid, amount, reason, meta, createdAt: FieldValue.serverTimestamp() });
  });
}
